<template>
    <div>
        <app-head></app-head>
        <app-body>
            <div class="release-container app-container">
                <div class="release-card apple-card">
                    <div class="card-header">
                        <h1 class="text-h2">发布闲置</h1>
                        <p class="text-small">填写商品信息，让更多人看到你的好物</p>
                    </div>
                    
                    <div class="form-section">
                        <div class="form-group">
                            <el-input
                                    placeholder="商品名称"
                                    v-model="idleItemInfo.idleName"
                                    maxlength="30"
                                    show-word-limit
                                    class="apple-input-borderless title-input">
                            </el-input>
                        </div>

                        <div class="form-group">
                            <div class="section-header">
                                <span class="section-label">商品描述</span>
                                <div class="ai-actions">
                                    <el-button
                                            type="text"
                                            class="ai-btn"
                                            :loading="aiLoading"
                                            :disabled="aiLoading || !imgList.length"
                                            @click="handleAIDescription">
                                        <i class="el-icon-magic-stick"></i> AI 帮写
                                    </el-button>
                                    <span class="ai-hint" v-if="!imgList.length">需先上传图片</span>
                                </div>
                            </div>
                            <el-input
                                    type="textarea"
                                    :rows="6"
                                    placeholder="描述一下宝贝的品牌型号、新旧程度、入手渠道等信息..."
                                    v-model="idleItemInfo.idleDetails"
                                    maxlength="1000"
                                    show-word-limit
                                    class="apple-textarea-borderless">
                            </el-input>
                        </div>

                        <div class="form-row">
                            <div class="form-group half-width">
                                <div class="label-text">所在地区</div>
                                <el-cascader
                                        :options="options"
                                        v-model="selectedOptions"
                                        @change="handleChange"
                                        :separator="' / '"
                                        class="apple-cascader"
                                        placeholder="选择地区"
                                >
                                </el-cascader>
                            </div>
                            <div class="form-group half-width">
                                <div class="label-text">商品分类</div>
                                <el-select v-model="idleItemInfo.idleLabel" placeholder="选择分类" class="apple-select">
                                    <el-option
                                            v-for="item in options2"
                                            :key="item.value"
                                            :label="item.label"
                                            :value="item.value">
                                    </el-option>
                                </el-select>
                            </div>
                        </div>

                        <div class="form-group price-group">
                            <div class="label-text">价格</div>
                            <el-input-number 
                                v-model="idleItemInfo.idlePrice" 
                                :precision="2" 
                                :step="10" 
                                :max="10000000"
                                :controls="false"
                                class="apple-input-number">
                            </el-input-number>
                            <span class="currency-symbol">￥</span>
                        </div>

                        <div class="form-group upload-group">
                            <div class="label-text">商品图片</div>
                            <el-upload
                                    class="apple-upload"
                                    action="/api/file"
                                    :on-preview="fileHandlePreview"
                                    :on-remove="fileHandleRemove"
                                    :on-success="fileHandleSuccess"
                                    :show-file-list="true"
                                    :limit="10"
                                    :on-exceed="handleExceed"
                                    accept="image/*"
                                    drag
                                    multiple
                                    list-type="picture-card">
                                <i class="el-icon-camera"></i>
                                <div class="el-upload__text">点击或拖拽上传</div>
                            </el-upload>
                            <el-dialog :visible.sync="imgDialogVisible">
                                <img width="100%" :src="dialogImageUrl" alt="">
                            </el-dialog>
                        </div>

                        <div class="form-actions">
                            <el-button type="primary" class="apple-btn-primary submit-btn" @click="releaseButton">发布商品</el-button>
                        </div>
                    </div>
                </div>
            </div>
            <app-foot></app-foot>
        </app-body>
    </div>
</template>

<script>
    import AppHead from '../common/AppHeader.vue';
    import AppBody from '../common/AppPageBody.vue'
    import AppFoot from '../common/AppFoot.vue'
    import options from '../common/country-data.js'
    import { generateIdleDescription } from '../../api/ai';

    export default {
        name: "release",
        components: {
            AppHead,
            AppBody,
            AppFoot
        },
        data() {
            return {
                imgDialogVisible:false,
                dialogImageUrl:'',
                showFileList:true,
                options:options,
                selectedOptions:[],
                aiLoading:false,
                options2: [{
                    value: 1,
                    label: '数码'
                }, {
                    value: 2,
                    label: '家电'
                }, {
                    value: 3,
                    label: '户外'
                }, {
                    value: 4,
                    label: '图书'
                }, {
                    value: 5,
                    label: '其他'
                }],
                imgList:[],
                idleItemInfo:{
                    idleName:'',
                    idleDetails:'',
                    pictureList:'',
                    idlePrice:0,
                    idlePlace:'',
                    idleLabel:''
                }
            };
        },
        methods: {
            handleChange(value) {
                console.log(value);
                this.idleItemInfo.idlePlace=value[1];
            },
            fileHandleRemove(file, fileList) {
                console.log(file, fileList);
                for(let i=0;i<this.imgList.length;i++){
                    if(this.imgList[i]===file.response.data){
                        this.imgList.splice(i,1);
                    }
                }
            },
            fileHandlePreview(file) {
                console.log(file);
                this.dialogImageUrl=file.response.data;
                this.imgDialogVisible=true;
            },
            fileHandleSuccess(response, file, fileList){
                console.log("file:",response,file,fileList);
                this.imgList.push(response.data);
            },
            async handleAIDescription(){
                if(!this.imgList.length){
                    this.$message.warning('请先上传至少一张图片再使用AI描写');
                    return;
                }
                this.aiLoading=true;
                try {
                    const aiText = await generateIdleDescription(this.imgList);
                    this.idleItemInfo.idleDetails = aiText;
                    this.$message.success('已生成描述，可根据需要微调');
                } catch (error) {
                    const response = error && error.response;
                    const respData = response && response.data;
                    const respError = respData && respData.error;
                    const tip = (respError && respError.message) || (error && error.message) || 'AI生成描述失败';
                    this.$message.error(tip);
                } finally {
                    this.aiLoading=false;
                }
            },
            releaseButton(){
                this.idleItemInfo.pictureList=JSON.stringify(this.imgList);
                console.log(this.idleItemInfo);
                if(this.idleItemInfo.idleName&&
                    this.idleItemInfo.idleDetails&&
                    this.idleItemInfo.idlePlace&&
                    this.idleItemInfo.idleLabel&&
                    this.idleItemInfo.idlePrice){
                    this.$api.addIdleItem(this.idleItemInfo).then(res=>{
                        if (res.status_code === 1) {
                            this.$message({
                                message: '发布成功！',
                                type: 'success'
                            });
                            console.log(res.data);
                            this.$router.replace({path: '/details', query: {id: res.data.id}});
                        } else {
                            this.$message.error('发布失败！'+res.msg);
                        }
                    }).catch(e=>{
                        this.$message.error('请填写完整信息');
                    })
                }else {
                    this.$message.error('请填写完整信息！');
                }

            },
            handleExceed(files, fileList) {
                this.$message.warning(`限制10张图片，本次选择了 ${files.length} 张图，共选择了 ${files.length + fileList.length} 张图`);
            },
        }
    }
</script>

<style scoped>
    .release-container {
        padding-top: 40px;
        padding-bottom: 40px;
        min-height: 85vh;
    }

    .release-card {
        max-width: 800px;
        margin: 0 auto;
        padding: 40px;
    }

    .card-header {
        text-align: center;
        margin-bottom: 40px;
    }

    .card-header h1 {
        margin-bottom: 8px;
    }

    .form-section {
        display: flex;
        flex-direction: column;
        gap: 32px;
    }

    .form-group {
        display: flex;
        flex-direction: column;
    }

    /* Custom Input Styles */
    ::v-deep .apple-input-borderless .el-input__inner {
        border: none;
        border-bottom: 1px solid var(--color-bg-tertiary);
        border-radius: 0;
        padding: 10px 0;
        font-size: 24px;
        font-weight: 600;
        background: transparent;
        transition: border-color 0.3s ease;
    }

    ::v-deep .apple-input-borderless .el-input__inner:focus {
        border-bottom: 2px solid var(--color-brand-highlight);
        box-shadow: none;
    }

    ::v-deep .apple-textarea-borderless .el-textarea__inner {
        border: none;
        background: transparent;
        padding: 10px 0;
        font-size: 16px;
        font-family: inherit;
        resize: none;
    }

    .section-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 12px;
    }

    .section-label {
        font-weight: 600;
        font-size: 16px;
    }

    .ai-actions {
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .ai-btn {
        color: var(--color-brand-highlight);
        font-weight: 500;
        padding: 0;
    }

    .ai-hint {
        font-size: 12px;
        color: var(--color-text-secondary);
    }

    .form-row {
        display: flex;
        gap: 32px;
    }

    .half-width {
        flex: 1;
    }

    .label-text {
        font-size: 14px;
        font-weight: 500;
        color: var(--color-text-secondary);
        margin-bottom: 8px;
    }

    ::v-deep .apple-cascader .el-input__inner,
    ::v-deep .apple-select .el-input__inner {
        border: 1px solid transparent;
        background-color: var(--color-bg-secondary);
        border-radius: var(--radius-md);
    }

    ::v-deep .apple-cascader .el-input__inner:focus,
    ::v-deep .apple-select .el-input__inner:focus {
        background-color: #fff;
        box-shadow: 0 0 0 2px var(--color-brand-highlight);
    }

    .price-group {
        position: relative;
        width: 200px;
    }

    .currency-symbol {
        position: absolute;
        left: 12px;
        top: 38px;
        font-size: 18px;
        color: var(--color-text-primary);
        z-index: 10;
    }

    ::v-deep .apple-input-number {
        width: 100%;
    }

    ::v-deep .apple-input-number .el-input__inner {
        padding-left: 30px;
        text-align: left;
        border: 1px solid transparent;
        background-color: var(--color-bg-secondary);
        border-radius: var(--radius-md);
        font-size: 18px;
        font-weight: 600;
        color: var(--color-brand-highlight);
    }

    ::v-deep .apple-input-number .el-input__inner:focus {
        background-color: #fff;
        box-shadow: 0 0 0 2px var(--color-brand-highlight);
    }

    /* Upload */
    .upload-group {
        margin-top: 16px;
    }

    ::v-deep .apple-upload .el-upload--picture-card {
        border: 1px dashed #d1d1d6;
        background-color: #f9f9f9;
        border-radius: var(--radius-lg);
        width: 120px;
        height: 120px;
        line-height: 120px;
    }

    ::v-deep .apple-upload .el-upload-dragger {
        width: 100%;
        height: 100%;
        border: none;
        background: transparent;
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
    }

    ::v-deep .apple-upload .el-upload-dragger .el-icon-camera {
        font-size: 32px;
        color: var(--color-text-secondary);
        margin-bottom: 8px;
    }

    ::v-deep .apple-upload .el-upload__text {
        font-size: 12px;
        color: var(--color-text-secondary);
        line-height: 1.2;
    }

    ::v-deep .apple-upload .el-upload-list--picture-card .el-upload-list__item {
        width: 120px;
        height: 120px;
        border-radius: var(--radius-lg);
        border: none;
    }

    .form-actions {
        margin-top: 32px;
        display: flex;
        justify-content: center;
    }

    .submit-btn {
        width: 200px;
        height: 48px;
        font-size: 16px;
    }
</style>