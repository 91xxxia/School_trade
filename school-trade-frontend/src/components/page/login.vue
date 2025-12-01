<template>
    <div :class="['login-container', themeClass]" role="main">
        <particle-background :theme="themeMode" />
        <div class="gradient-overlay" aria-hidden="true"></div>
        <section class="login-panel" aria-label="校园二手交易平台登录">
            <header class="brand-lockup" @click="toIndex" role="button" tabindex="0" @keyup.enter="toIndex">
                <img src="../../assets/logo.png" alt="平台 logo" class="brand-logo">
                <div>
                    <p class="brand-eyebrow">Smart Circular Campus</p>
                    <h1>校园二手交易平台</h1>
                    <p class="brand-subtitle">专注安全、可持续的智慧校园交易体验</p>
                </div>
            </header>
            <form class="form-body" @submit.prevent="login">
                <label class="field">
                    <span class="field-label">账号</span>
                    <div class="field-control">
                        <span class="field-icon" aria-hidden="true">
                            <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="1.5">
                                <circle cx="12" cy="8" r="4" />
                                <path d="M4 20c1.5-3 4.5-4.5 8-4.5s6.5 1.5 8 4.5" />
                            </svg>
                        </span>
                        <input
                                id="accountNumber"
                                type="text"
                                autocomplete="username"
                                v-model.trim="userForm.accountNumber"
                                placeholder="请输入账号"
                                required
                                @keyup.enter="login"
                        >
                    </div>
                </label>
                <label class="field">
                    <span class="field-label">密码</span>
                    <div class="field-control">
                        <span class="field-icon" aria-hidden="true">
                            <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="1.5">
                                <rect x="4" y="10" width="16" height="10" rx="2" />
                                <path d="M8 10V7a4 4 0 0 1 8 0v3" />
                            </svg>
                        </span>
                        <input
                                id="userPassword"
                                :type="showPassword ? 'text' : 'password'"
                                autocomplete="current-password"
                                v-model.trim="userForm.userPassword"
                                placeholder="请输入密码"
                                required
                                @keyup.enter="login"
                        >
                        <button type="button" class="ghost-icon" @click="togglePassword" aria-label="切换密码可见性">
                            <svg v-if="showPassword" viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="1.5">
                                <path d="M2 12s4-7 10-7 10 7 10 7-4 7-10 7-10-7-10-7z" />
                                <circle cx="12" cy="12" r="3" />
                            </svg>
                            <svg v-else viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="1.5">
                                <path d="M3 3l18 18" />
                                <path d="M10.6 10.6a1.5 1.5 0 0 0 2.8 2.8" />
                                <path d="M9.9 5.1A10.94 10.94 0 0 1 12 5c6 0 10 7 10 7a18.14 18.14 0 0 1-3.06 4.26" />
                                <path d="M6.2 6.2A18.55 18.55 0 0 0 2 12s4 7 10 7a10.94 10.94 0 0 0 2.9-.4" />
                            </svg>
                        </button>
                    </div>
                </label>
                <div class="form-actions">
                    <button type="submit" class="cta" :disabled="authLoading">
                        <span>{{ authLoading ? '登录中...' : '立即登录' }}</span>
                    </button>
                    <div class="secondary-actions">
                        <button type="button" class="ghost-btn" @click="$router.push('/sign-in')">注册</button>
                        <button type="button" class="ghost-btn" @click="$router.push('/login-admin')">管理员登录</button>
                    </div>
                </div>
                <div class="social-divider" aria-hidden="true">
                    <span></span>
                    <p>或使用社交账号登录</p>
                    <span></span>
                </div>
                <div class="social-login" aria-label="社交登录选项">
                    <button type="button" class="social-btn" @click="handleSocial('Apple 登录')">
                        <span class="social-icon" aria-hidden="true">
                            <svg viewBox="0 0 20 24" width="18" height="18" fill="currentColor">
                                <path d="M15.6 13c0-3.2 2.6-4.6 2.7-4.7-1.5-2.2-3.9-2.5-4.7-2.6-2-.2-4 1.2-5 1.2s-2.6-1.2-4.4-1.2C2.2 5.7 0 7.1 0 10.2c0 2 0.8 4 1.8 5.3 1 1.3 2 2.6 3.4 2.6 1.3 0 1.8-.8 3.4-.8s2.1.8 3.4.8 2.3-1.2 3.2-2.5c1-1.4 1.4-2.8 1.4-2.8-.1-.1-2.9-1.1-2.9-4.8z"/>
                                <path d="M10.7 3.6c.9-1 1.5-2.4 1.3-3.6-1.3.1-2.8.9-3.7 1.9-.8.9-1.4 2.3-1.2 3.6 1.4.1 2.9-.8 3.6-1.9z"/>
                            </svg>
                        </span>
                        <span>Apple 登录</span>
                    </button>
                    <button type="button" class="social-btn" @click="handleSocial('微信登录')">
                        <span class="social-icon" aria-hidden="true">
                            <svg viewBox="0 0 24 24" width="18" height="18" fill="currentColor">
                                <path d="M9.5 3C5.4 3 2 5.9 2 9.5c0 2.1 1.3 3.9 3.3 5.1L4.5 17l3.3-1.7c.5.1 1.1.1 1.7.1 4.1 0 7.5-2.9 7.5-6.5S13.6 3 9.5 3zm-2.5 4c.6 0 1 .4 1 1s-.4 1-1 1-1-.4-1-1 .4-1 1-1zm5 0c.6 0 1 .4 1 1s-.4 1-1 1-1-.4-1-1 .4-1 1-1z"/>
                                <path d="M21.5 10.5c0-3-2.9-5.5-6.5-5.5.3.6.5 1.3.5 2 0 3.9-3.8 7-8.5 7h-.5c1.1 2.4 3.9 4 7 4 .6 0 1.2 0 1.7-.1l3 1.6-.8-2.2c1.9-1.1 3.1-3 3.1-5.1zm-4 1c-.5 0-1-.4-1-1s.5-1 1-1 1 .4 1 1-.4 1-1 1zm3 0c-.5 0-1-.4-1-1s.5-1 1-1 1 .4 1 1-.4 1-1 1z"/>
                            </svg>
                        </span>
                        <span>微信登录</span>
                    </button>
                </div>
            </form>
        </section>
    </div>
</template>

<script>
import ParticleBackground from '../ui/ParticleBackground.vue';

export default {
    name: 'login',
    components: {
        ParticleBackground
    },
    data() {
        return {
            userForm: {
                accountNumber: '',
                userPassword: ''
            },
            showPassword: false,
            authLoading: false,
            themeMode: 'day',
            themeTimer: null
        };
    },
    computed: {
        themeClass() {
            return this.themeMode === 'day' ? 'theme-day' : 'theme-night';
        }
    },
    mounted() {
        this.updateThemeMode();
        this.themeTimer = setInterval(this.updateThemeMode, 60000);
    },
    beforeDestroy() {
        if (this.themeTimer) {
            clearInterval(this.themeTimer);
        }
    },
    methods: {
        updateThemeMode() {
            const hour = new Date().getHours();
            this.themeMode = hour >= 6 && hour < 18 ? 'day' : 'night';
        },
        togglePassword() {
            this.showPassword = !this.showPassword;
        },
        async login() {
            if (this.authLoading) return;
            this.authLoading = true;
            try {
                const res = await this.$api.userLogin({
                    accountNumber: this.userForm.accountNumber,
                    userPassword: this.userForm.userPassword
                });
                if (res.status_code === 1) {
                    res.data.signInTime = res.data.signInTime.substring(0, 10);
                    this.$globalData.userInfo = res.data;
                    this.$router.replace({ path: '/index' });
                } else {
                    this.$message.error(res.msg || '登录失败');
                }
            } catch (error) {
                this.$message.error('网络异常，请稍后再试');
            } finally {
                this.authLoading = false;
            }
        },
        handleSocial(channel) {
            this.$message({
                message: `${channel} 即将开放，敬请期待`,
                type: 'info'
            });
        },
        toIndex() {
            this.$router.replace({ path: '/index' });
        }
    }
};
</script>

<style scoped>
:root {
    --day-bg: #f8f9fa;
    --day-primary: #334e68;
    --night-bg: #121826;
    --night-primary: #5c6ac4;
}

.login-container {
    position: relative;
    min-height: 100vh;
    padding: clamp(32px, 10vh, 120px) clamp(20px, 8vw, 120px);
    display: flex;
    justify-content: center;
    align-items: center;
    color: #e5e7eb;
    overflow: hidden;
    background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
}

.login-container.theme-day {
    color: #1f2933;
    background: var(--day-bg);
}

.login-container.theme-night {
    background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
}

.gradient-overlay {
    position: absolute;
    inset: 0;
    background: radial-gradient(circle at 20% 20%, rgba(99, 102, 241, 0.5), transparent 55%),
    radial-gradient(circle at 80% 0%, rgba(16, 185, 129, 0.25), transparent 45%);
    mix-blend-mode: screen;
    pointer-events: none;
    z-index: 0;
    opacity: 0.7;
}

.login-panel {
    position: relative;
    z-index: 1;
    width: min(420px, 100%);
    padding: clamp(32px, 5vw, 48px);
    backdrop-filter: blur(12px);
    background: rgba(15, 23, 42, 0.65);
    border: 1px solid rgba(99, 102, 241, 0.2);
    border-radius: 32px;
    box-shadow: 0 30px 80px rgba(15, 23, 42, 0.45);
}

.theme-day .login-panel {
    background: rgba(248, 249, 250, 0.85);
    border-color: rgba(92, 106, 196, 0.2);
    color: #1f2933;
}

.brand-lockup {
    display: flex;
    gap: 16px;
    align-items: center;
    margin-bottom: 40px;
    cursor: pointer;
    transition: transform 0.25s ease, opacity 0.25s ease;
}

.brand-lockup:focus-visible {
    outline: 2px solid rgba(99, 102, 241, 0.5);
    outline-offset: 6px;
}

.brand-lockup:hover {
    transform: translateY(-2px);
    opacity: 0.95;
}

.brand-logo {
    width: 56px;
    height: 56px;
    border-radius: 18px;
    box-shadow: 0 10px 25px rgba(15, 23, 42, 0.45);
}

.brand-eyebrow {
    font-size: 12px;
    letter-spacing: 0.2em;
    text-transform: uppercase;
    opacity: 0.7;
}

.brand-lockup h1 {
    font-size: clamp(24px, 3vw, 30px);
    margin: 4px 0;
    color: inherit;
}

.brand-subtitle {
    margin: 0;
    font-size: 14px;
    opacity: 0.75;
}

.form-body {
    display: flex;
    flex-direction: column;
    gap: 18px;
}

.field {
    display: flex;
    flex-direction: column;
    gap: 6px;
}

.field-label {
    font-size: 13px;
    letter-spacing: 0.04em;
    text-transform: uppercase;
    color: rgba(255, 255, 255, 0.75);
}

.theme-day .field-label {
    color: rgba(31, 41, 51, 0.75);
}

.field-control {
    position: relative;
    display: flex;
    align-items: center;
    padding: 12px 16px;
    border-radius: 18px;
    border: 1px solid rgba(255, 255, 255, 0.25);
    background: rgba(15, 23, 42, 0.25);
    transition: border 0.3s ease, box-shadow 0.3s ease;
}

.theme-day .field-control {
    background: rgba(255, 255, 255, 0.6);
    border-color: rgba(92, 106, 196, 0.3);
}

.field-control::before {
    content: '';
    position: absolute;
    left: 0;
    top: 8px;
    bottom: 8px;
    width: 3px;
    border-radius: 4px;
    background: linear-gradient(180deg, #818cf8 0%, #c084fc 100%);
    opacity: 0;
    transition: opacity 0.3s ease;
}

.field-control:focus-within::before {
    opacity: 1;
}

.field-control:focus-within {
    border-color: rgba(129, 140, 248, 0.8);
    box-shadow: 0 8px 30px rgba(99, 102, 241, 0.4);
}

.field-icon {
    display: flex;
    align-items: center;
    color: rgba(255, 255, 255, 0.8);
    margin-right: 10px;
}

.theme-day .field-icon {
    color: rgba(51, 78, 104, 0.8);
}

.field-control input {
    flex: 1;
    border: none;
    background: transparent;
    color: inherit;
    font-size: 15px;
    outline: none;
}

.ghost-icon {
    background: transparent;
    border: none;
    color: inherit;
    cursor: pointer;
    padding: 6px;
    display: flex;
    align-items: center;
    transition: opacity 0.25s ease;
}

.ghost-icon:hover {
    opacity: 0.7;
}

.form-actions {
    display: flex;
    flex-direction: column;
    gap: 16px;
    margin-top: 10px;
}

.cta {
    border: none;
    border-radius: 18px;
    padding: 14px;
    font-size: 16px;
    font-weight: 600;
    letter-spacing: 0.05em;
    color: #f8fafc;
    background: linear-gradient(135deg, #5c6ac4, #8b5cf6);
    cursor: pointer;
    transition: transform 0.2s ease, box-shadow 0.2s ease;
    box-shadow: 0 15px 30px rgba(91, 104, 196, 0.45);
}

.cta:disabled {
    opacity: 0.6;
    cursor: not-allowed;
}

.cta:not(:disabled):hover {
    transform: translateY(-2px);
    box-shadow: 0 20px 35px rgba(91, 104, 196, 0.55);
}

.secondary-actions {
    display: flex;
    gap: 12px;
    flex-wrap: wrap;
    justify-content: space-between;
}

.ghost-btn {
    flex: 1;
    border-radius: 14px;
    border: 1px solid rgba(255, 255, 255, 0.3);
    background: transparent;
    color: inherit;
    padding: 10px;
    cursor: pointer;
    transition: border 0.2s ease, background 0.2s ease;
}

.theme-day .ghost-btn {
    border-color: rgba(92, 106, 196, 0.4);
}

.ghost-btn:hover {
    border-color: rgba(129, 140, 248, 0.6);
    background: rgba(255, 255, 255, 0.08);
}

.social-divider {
    display: flex;
    align-items: center;
    gap: 12px;
    margin-top: 12px;
    color: rgba(255, 255, 255, 0.6);
    font-size: 12px;
    letter-spacing: 0.2em;
    text-transform: uppercase;
}

.theme-day .social-divider {
    color: rgba(31, 41, 51, 0.6);
}

.social-divider span {
    flex: 1;
    height: 1px;
    background: currentColor;
    opacity: 0.3;
}

.social-login {
    display: flex;
    gap: 12px;
    margin-top: 8px;
    flex-wrap: wrap;
}

.social-btn {
    flex: 1;
    min-width: 150px;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 10px;
    border-radius: 16px;
    border: 1px solid rgba(255, 255, 255, 0.3);
    background: rgba(15, 23, 42, 0.3);
    color: inherit;
    padding: 12px;
    cursor: pointer;
    transition: transform 0.3s ease, box-shadow 0.3s ease;
    animation: breathe 4s ease-in-out infinite;
}

.theme-day .social-btn {
    background: rgba(255, 255, 255, 0.7);
    border-color: rgba(92, 106, 196, 0.3);
}

.social-btn:hover {
    transform: translateY(-2px) scale(1.02);
    box-shadow: 0 15px 35px rgba(99, 102, 241, 0.35);
}

.social-icon {
    display: flex;
    align-items: center;
}

@keyframes breathe {
    0% { transform: scale(1); }
    50% { transform: scale(1.05); }
    100% { transform: scale(1); }
}

@media (max-width: 600px) {
    .login-panel {
        padding: 28px;
        border-radius: 24px;
    }
    .social-login {
        flex-direction: column;
    }
}

@media (prefers-reduced-motion: reduce) {
    * {
        animation-duration: 0.01ms !important;
        animation-iteration-count: 1 !important;
        transition-duration: 0.01ms !important;
    }
}
</style>
