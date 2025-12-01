import axios from 'axios';

const GLM_API_URL = 'https://open.bigmodel.cn/api/paas/v4/chat/completions';
const GLM_MODEL = process.env.VUE_APP_GLM_MODEL || 'glm-4.5v';
const GLM_API_KEY = process.env.VUE_APP_GLM_API_KEY || 'e0647e37eb8b4173b31cd3702857033b.6TsR8CYUrsFNMysB';

function arrayBufferToBase64(buffer) {
    const bytes = new Uint8Array(buffer);
    if (typeof window !== 'undefined' && window.btoa) {
        let binary = '';
        for (let i = 0; i < bytes.byteLength; i += 1) {
            binary += String.fromCharCode(bytes[i]);
        }
        return window.btoa(binary);
    }
    if (typeof Buffer !== 'undefined') {
        return Buffer.from(bytes).toString('base64');
    }
    let binary = '';
    for (let i = 0; i < bytes.byteLength; i += 1) {
        binary += String.fromCharCode(bytes[i]);
    }
    if (typeof btoa === 'function') {
        return btoa(binary);
    }
    const globalBtoa = typeof globalThis !== 'undefined' && globalThis.btoa;
    if (typeof globalBtoa === 'function') {
        return globalBtoa(binary);
    }
    throw new Error('当前环境不支持Base64转换');
}

async function ensureImageDataUrl(url) {
    try {
        const response = await axios.get(url, { responseType: 'arraybuffer' });
        const contentType = response.headers['content-type'] || 'image/jpeg';
        const base64 = arrayBufferToBase64(response.data);
        return `data:${contentType};base64,${base64}`;
    } catch (error) {
        console.warn('convert image to base64 failed, fallback to raw url', error);
        return url;
    }
}

async function buildContent(imageUrls) {
    const intro = {
        type: 'text',
        text: '你是一名熟悉校园二手交易的商品描述助手。请基于上传的图片，输出约80-120字的中文描述，突出外观成色、功能状态、适用场景以及任何可能的瑕疵。描述要自然、有吸引力，并鼓励买家尽快联系。'
    };

    const images = [];
    for (const url of imageUrls) {
        const safeUrl = await ensureImageDataUrl(url);
        images.push({
            type: 'image_url',
            image_url: { url: safeUrl }
        });
    }
    return [intro, ...images];
}

export async function generateIdleDescription(imageUrls) {
    if (!Array.isArray(imageUrls) || imageUrls.length === 0) {
        throw new Error('请至少上传一张商品图片');
    }

    const content = await buildContent(imageUrls);

    const payload = {
        model: GLM_MODEL,
        messages: [
            {
                role: 'user',
                content
            }
        ],
        temperature: 0.3,
        top_p: 0.8,
        stream: false,
        max_tokens: 600
    };

    const response = await axios.post(GLM_API_URL, payload, {
        headers: {
            Authorization: `Bearer ${GLM_API_KEY}`,
            'Content-Type': 'application/json'
        }
    });

    const responseData = response && response.data;
    const choices = responseData && responseData.choices;
    const firstChoice = Array.isArray(choices) && choices.length ? choices[0] : null;
    const firstMessage = firstChoice && firstChoice.message;
    let segments = firstMessage && firstMessage.content ? firstMessage.content : [];
    if (typeof segments === 'string') {
        segments = [{ type: 'text', text: segments }];
    }
    if (!Array.isArray(segments)) {
        segments = [];
    }

    const aiText = segments
        .filter(item => item && item.type === 'text' && item.text)
        .map(item => item.text.trim())
        .join('\n')
        .trim();

    if (!aiText) {
        throw new Error('AI 未返回有效描述，这个图片可能不是二手物品');
    }

    return aiText;
}
