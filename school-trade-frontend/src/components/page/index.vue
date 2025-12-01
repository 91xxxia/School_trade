<template>
    <div>
        <app-head></app-head>
        <app-body>
            <div class="main-content app-container">
                <div class="tabs-container">
                    <el-tabs v-model="labelName" @tab-click="handleClick" class="apple-tabs">
                        <el-tab-pane label="全部" name="0"></el-tab-pane>
                        <el-tab-pane label="推荐" name="recommend" v-if="isLogin"></el-tab-pane>
                        <el-tab-pane label="数码" name="1"></el-tab-pane>
                        <el-tab-pane label="家电" name="2"></el-tab-pane>
                        <el-tab-pane label="户外" name="3"></el-tab-pane>
                        <el-tab-pane label="图书" name="4"></el-tab-pane>
                        <el-tab-pane label="其他" name="5"></el-tab-pane>
                    </el-tabs>
                </div>

                <div class="goods-list-container">
                    <el-row :gutter="32">
                        <el-col :xs="24" :sm="12" :md="8" :lg="6" v-for="(idle,index) in idleList" :key="idle.id" class="goods-col">
                            <div class="idle-card apple-card" @click="toDetails(idle)">
                                <div class="card-image-wrapper">
                                    <el-image
                                            class="card-image"
                                            :src="idle.imgUrl"
                                            fit="cover">
                                        <div slot="error" class="image-slot">
                                            <i class="el-icon-picture-outline"></i>
                                        </div>
                                    </el-image>
                                </div>
                                <div class="card-content">
                                    <div class="idle-title text-h3">{{idle.idleName}}</div>
                                    <div class="idle-info">
                                        <div class="idle-price">
                                            <span class="currency">￥</span>
                                            <span class="amount">{{idle.idlePrice}}</span>
                                        </div>
                                        <div class="idle-place text-small">{{idle.idlePlace}}</div>
                                    </div>
                                    <div class="user-info">
                                        <el-avatar :size="24" :src="idle.user.avatar" class="user-avatar"></el-avatar>
                                        <span class="user-nickname text-small">{{idle.user.nickname}}</span>
                                    </div>
                                </div>
                            </div>
                        </el-col>
                    </el-row>

                    <!-- 空状态提示 -->
                    <div v-if="idleList.length === 0" class="empty-state">
                        <el-empty :description="emptyDescription" :image-size="200">
                            <el-button
                                v-if="labelName === 'recommend' && !isLogin"
                                type="primary"
                                class="apple-btn-primary"
                                @click="$router.push('/login')">
                                立即登录
                            </el-button>
                            <el-button
                                v-else-if="labelName === 'recommend' && isLogin"
                                type="primary"
                                class="apple-btn-primary"
                                @click="browseMoreItems">
                                去浏览更多商品
                            </el-button>
                        </el-empty>
                    </div>
                </div>
                
                <div class="pagination-container" v-if="totalItem > 0">
                    <el-pagination
                            background
                            @current-change="handleCurrentChange"
                            :current-page.sync="currentPage"
                            :page-size="8"
                            layout="prev, pager, next"
                            :total="totalItem">
                    </el-pagination>
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

    export default {
        name: "index",
        components: {
            AppHead,
            AppBody,
            AppFoot
        },
        data() {
            return {
                labelName: '0',
                idleList: [],
                currentPage: 1,
                totalItem: 1,
                isLogin: false,
                userId: null
            };
        },
        computed: {
            emptyDescription() {
                if (this.labelName === 'recommend') {
                    if (!this.isLogin) {
                        return '登录后查看个性化推荐';
                    } else {
                        return '多浏览商品，获取更精准的推荐';
                    }
                }
                return '暂无商品';
            }
        },
        created() {
            this.checkLoginStatus();
            this.findIdleTiem(1);
        },
        watch:{
            $route(to,from){
                this.labelName = to.query.labelName || '0';
                let val = parseInt(to.query.page) ? parseInt(to.query.page) : 1;
                this.currentPage = parseInt(to.query.page) ? parseInt(to.query.page) : 1;
                this.findIdleTiem(val);
            }
        },
        methods: {
            // 检查登录状态
            checkLoginStatus() {
                // 从cookie或localStorage获取用户ID
                const userId = this.getCookie('shUserId') || localStorage.getItem('shUserId');
                if (userId) {
                    this.isLogin = true;
                    this.userId = userId;
                } else {
                    this.isLogin = false;
                    this.userId = null;
                }
            },

            // 获取cookie
            getCookie(name) {
                const value = `; ${document.cookie}`;
                const parts = value.split(`; ${name}=`);
                if (parts.length === 2) return parts.pop().split(';').shift();
                return null;
            },

            findIdleTiem(page){
                const loading = this.$loading({
                    lock: true,
                    text: '加载数据中',
                    spinner: 'el-icon-loading',
                    background: 'rgba(0, 0, 0, 0)'
                });

                if (this.labelName === 'recommend') {
                    // 推荐商品
                    if (!this.isLogin) {
                        this.$message.warning('请先登录查看推荐商品');
                        this.idleList = [];
                        this.totalItem = 0;
                        loading.close();
                        return;
                    }

                    this.$api.getPersonalRecommend({
                        page: page,
                        nums: 8,
                        shUserId: this.userId
                    }).then(res => {
                        console.log('推荐商品:', res);
                        this.processIdleList(res);
                    }).catch(e => {
                        console.log('获取推荐失败:', e);
                        this.$message.error('获取推荐失败');
                        this.idleList = [];
                        this.totalItem = 0;
                    }).finally(() => {
                        loading.close();
                    });

                } else if (this.labelName > 0) {
                    // 按标签分类
                    this.$api.findIdleTiemByLable({
                        idleLabel: this.labelName,
                        page: page,
                        nums: 8
                    }).then(res => {
                        this.processIdleList(res);
                    }).catch(e => {
                        console.log(e);
                        this.idleList = [];
                        this.totalItem = 0;
                    }).finally(() => {
                        loading.close();
                    });
                } else {
                    // 全部商品
                    this.$api.findIdleTiem({
                        page: page,
                        nums: 8
                    }).then(res => {
                        this.processIdleList(res);
                    }).catch(e => {
                        console.log(e);
                        this.idleList = [];
                        this.totalItem = 0;
                    }).finally(() => {
                        loading.close();
                    });
                }
            },

            // 处理商品列表数据
            processIdleList(res) {
                let list = res.data.list || [];
                for (let i = 0; i < list.length; i++) {
                    list[i].timeStr = list[i].releaseTime ?
                        (list[i].releaseTime.substring(0, 10) + " " + list[i].releaseTime.substring(11, 19)) : '';

                    let pictureList = [];
                    try {
                        pictureList = JSON.parse(list[i].pictureList);
                    } catch (e) {
                        console.warn('图片列表解析失败:', list[i].pictureList);
                    }
                    list[i].imgUrl = pictureList.length > 0 ? pictureList[0] : '';

                    // 确保user对象存在
                    if (!list[i].user) {
                        list[i].user = {
                            nickname: '未知用户',
                            avatar: ''
                        };
                    }
                }
                this.idleList = list;
                this.totalItem = res.data.count || 0;
                console.log('商品数量:', this.totalItem);
            },

            handleClick(tab, event) {
                console.log('切换到标签:', this.labelName);
                if (this.labelName === 'recommend' && !this.isLogin) {
                    this.$message.warning('请先登录查看推荐商品');
                    return;
                }
                this.$router.replace({query: {page: 1, labelName: this.labelName}});
            },

            handleCurrentChange(val) {
                console.log(`当前页: ${val}`);
                this.$router.replace({query: {page: val, labelName: this.labelName}});
            },

            toDetails(idle) {
                // 记录浏览历史（如果已登录）
                if (this.isLogin && this.userId) {
                    this.$api.recordBrowseHistory({
                        idleId: idle.id,
                        shUserId: this.userId
                    }).then(() => {
                        console.log('浏览记录已保存');
                    }).catch(e => {
                        console.log('记录浏览历史失败:', e);
                    });
                }

                this.$router.push({path: '/details', query: {id: idle.id}});
            },

            // 去浏览更多商品
            browseMoreItems() {
                this.labelName = '0';
                this.$router.replace({query: {page: 1, labelName: '0'}});
            }
        }
    }
</script>

<style scoped>
    .main-content {
        min-height: 85vh;
        padding-top: 40px;
        padding-bottom: 40px;
    }

    .tabs-container {
        margin-bottom: 32px;
        display: flex;
        justify-content: center;
    }

    /* Apple Style Tabs Override */
    ::v-deep .el-tabs__header {
        margin: 0;
        border-bottom: none;
    }

    ::v-deep .el-tabs__nav-wrap::after {
        display: none;
    }

    ::v-deep .el-tabs__nav {
        border: none !important;
        background-color: var(--color-bg-secondary);
        border-radius: var(--radius-full);
        padding: 4px;
    }

    ::v-deep .el-tabs__item {
        border: none !important;
        border-radius: var(--radius-full);
        height: 32px;
        line-height: 32px;
        padding: 0 20px !important;
        margin: 0 2px;
        color: var(--color-text-secondary);
        font-weight: 500;
        transition: all 0.3s ease;
    }

    ::v-deep .el-tabs__item.is-active {
        background-color: #fff;
        color: var(--color-text-primary);
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }

    ::v-deep .el-tabs__item:hover:not(.is-active) {
        color: var(--color-text-primary);
    }

    /* Goods List */
    .goods-col {
        margin-bottom: 32px;
    }

    .idle-card {
        height: 100%;
        display: flex;
        flex-direction: column;
        padding: 0; /* Override default padding for image */
        overflow: hidden;
        cursor: pointer;
        background: #fff;
    }

    .card-image-wrapper {
        width: 100%;
        padding-top: 100%; /* 1:1 Aspect Ratio */
        position: relative;
        background-color: #f9f9f9;
    }

    .card-image {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        transition: transform 0.5s ease;
    }

    .idle-card:hover .card-image {
        transform: scale(1.05);
    }

    .card-content {
        padding: 20px;
        flex: 1;
        display: flex;
        flex-direction: column;
    }

    .idle-title {
        font-size: 17px;
        font-weight: 600;
        color: var(--color-text-primary);
        margin-bottom: 8px;
        overflow: hidden;
        white-space: nowrap;
        text-overflow: ellipsis;
    }

    .idle-info {
        display: flex;
        justify-content: space-between;
        align-items: baseline;
        margin-bottom: 16px;
    }

    .idle-price {
        color: var(--color-brand-highlight);
        font-weight: 600;
    }

    .currency {
        font-size: 14px;
    }

    .amount {
        font-size: 20px;
    }

    .idle-place {
        font-size: 13px;
        color: var(--color-text-secondary);
    }

    .user-info {
        display: flex;
        align-items: center;
        margin-top: auto;
        padding-top: 12px;
        border-top: 1px solid var(--color-bg-secondary);
    }

    .user-avatar {
        margin-right: 8px;
        border: 1px solid var(--color-bg-secondary);
    }

    .user-nickname {
        font-size: 13px;
        color: var(--color-text-secondary);
    }

    .empty-state {
        padding: 60px 0;
    }

    .pagination-container {
        display: flex;
        justify-content: center;
        margin-top: 40px;
    }
    
    ::v-deep .el-pagination.is-background .el-pager li:not(.disabled).active {
        background-color: var(--color-brand-highlight);
    }
</style>