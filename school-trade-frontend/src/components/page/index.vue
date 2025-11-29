<template>
    <div>
        <app-head></app-head>
        <app-body>
            <div style="min-height: 85vh;">
            <el-tabs v-model="labelName" type="card" @tab-click="handleClick">
                <el-tab-pane label="全部" name="0"></el-tab-pane>
                <!-- 新增推荐标签页 -->
                <el-tab-pane label="推荐" name="recommend" v-if="isLogin"></el-tab-pane>
                <el-tab-pane label="数码" name="1"></el-tab-pane>
                <el-tab-pane label="家电" name="2"></el-tab-pane>
                <el-tab-pane label="户外" name="3"></el-tab-pane>
                <el-tab-pane label="图书" name="4"></el-tab-pane>
                <el-tab-pane label="其他" name="5"></el-tab-pane>
            </el-tabs>

            <div style="margin: 0 20px;">
                <el-row :gutter="30">
                    <el-col :span="6" v-for="(idle,index) in idleList" :key="idle.id">
                        <div class="idle-card" @click="toDetails(idle)">
                            <el-image
                                    style="width: 100%; height: 160px"
                                    :src="idle.imgUrl"
                                    fit="contain">
                                <div slot="error" class="image-slot">
                                    <i class="el-icon-picture-outline">无图</i>
                                </div>
                            </el-image>
                            <div class="idle-title">
                                {{idle.idleName}}
                            </div>
                            <el-row style="margin: 5px 10px;">
                                <el-col :span="12">
                                    <div class="idle-prive">￥{{idle.idlePrice}}</div>
                                </el-col>
                                <el-col :span="12">
                                    <div class="idle-place">{{idle.idlePlace}}</div>
                                </el-col>
                            </el-row>
                            <div class="user-info">
                                <el-image
                                        style="width: 30px; height: 30px"
                                        :src="idle.user.avatar"
                                        fit="contain">
                                    <div slot="error" class="image-slot">
                                        <i class="el-icon-picture-outline">无图</i>
                                    </div>
                                </el-image>
                                <div class="user-nickname">{{idle.user.nickname}}</div>
                            </div>
                        </div>
                    </el-col>
                </el-row>

                <!-- 空状态提示 -->
                <div v-if="idleList.length === 0" class="empty-state">
                    <el-empty :description="emptyDescription">
                        <el-button
                            v-if="labelName === 'recommend' && !isLogin"
                            type="primary"
                            @click="$router.push('/login')">
                            立即登录
                        </el-button>
                        <el-button
                            v-else-if="labelName === 'recommend' && isLogin"
                            type="primary"
                            @click="browseMoreItems">
                            去浏览更多商品
                        </el-button>
                    </el-empty>
                </div>
            </div>
            <div class="fenye" v-if="totalItem > 0">
                <el-pagination
                        background
                        @current-change="handleCurrentChange"
                        :current-page.sync="currentPage"
                        :page-size="8"
                        layout="prev, pager, next, jumper"
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
    .idle-card {
        height: 300px;
        border: #eeeeee solid 1px;
        margin-bottom: 15px;
        cursor: pointer;
        transition: all 0.3s ease;
    }

    .idle-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    }

    .fenye {
        display: flex;
        justify-content: center;
        height: 60px;
        align-items: center;
    }

    .idle-title {
        font-size: 18px;
        font-weight: 600;
        overflow: hidden;
        white-space: nowrap;
        text-overflow: ellipsis;
        margin: 10px;
    }

    .idle-prive {
        font-size: 16px;
        color: red;
    }

    .idle-place {
        font-size: 13px;
        color: #666666;
        float: right;
        padding-right: 20px;
    }

    .user-nickname {
        color: #999999;
        font-size: 12px;
        display: flex;
        align-items: center;
        height: 30px;
        padding-left: 10px;
    }

    .user-info {
        margin-top: 10px;
        float: right;
        padding: 5px 10px;
        height: 30px;
        display: flex;
    }

    .empty-state {
        display: flex;
        justify-content: center;
        align-items: center;
        height: 300px;
    }
</style>