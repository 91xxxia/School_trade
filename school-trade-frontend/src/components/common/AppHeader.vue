<template>
    <div class="header glass-effect">
        <div class="header-container app-container">
            <div class="app-name">
                <router-link to="/" class="logo-link">
                    <img src="../../assets/logo.png" class="logo-img">
                    <span class="logo-text">校园二手交易平台</span>
                </router-link>
            </div>
            <div class="search-container">
                <el-input placeholder="搜索好物..." v-model="searchValue" @keyup.enter.native="searchIdle" class="apple-search-input">
                    <el-button slot="append" icon="el-icon-search" @click="searchIdle"></el-button>
                </el-input>
            </div>
            
            <div class="header-actions">
                <el-button 
                    circle 
                    :icon="isDarkMode ? 'el-icon-sunny' : 'el-icon-moon'" 
                    class="apple-btn-secondary action-item" 
                    @click="toggleTheme"
                    :title="isDarkMode ? '切换浅色模式' : '切换深色模式'">
                </el-button>

                <el-button type="primary" icon="el-icon-plus" class="apple-btn-primary action-item" @click="toRelease" round>发布</el-button>
                
                <el-button plain icon="el-icon-chat-dot-round" class="apple-btn-secondary action-item" @click="toMessage" round>留言</el-button>
                
                <div class="action-item relative-container">
                    <el-button plain icon="el-icon-chat-line-round" class="apple-btn-secondary" @click="toPrivateMessage" round>私信</el-button>
                    <span v-if="unreadCount > 0" class="unread-badge-btn">{{ unreadCount }}</span>
                </div>

                <el-button v-if="!isLogin" plain class="apple-btn-secondary action-item" @click="$router.push('/login')" round>登录</el-button>

                <el-dropdown trigger="click" v-else class="user-dropdown">
                    <div class="user-profile">
                        <span class="user-name">{{nicknameValue?nicknameValue:nickname}}</span>
                        <el-avatar :src="avatarValue?avatarValue:avatar" size="small"></el-avatar>
                    </div>
                    <el-dropdown-menu slot="dropdown">
                        <el-dropdown-item><div @click="toMe">个人中心</div></el-dropdown-item>
                        <el-dropdown-item divided><div @click="loginOut" style="color: var(--color-danger);">退出登录</div></el-dropdown-item>
                    </el-dropdown-menu>
                </el-dropdown>
            </div>
        </div>
    </div>
</template>
<script>

    export default {
        name: 'Header',
        props: ['searchInput','nicknameValue','avatarValue'],
        data() {
            return {
                searchValue: this.searchInput,
                nickname:'登录',
                avatar:'https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png',
                isLogin:false,
                unreadCount: 0,
                unreadPollingInterval: null, // 添加轮询定时器
                isDarkMode: false
            };
        },
        created(){
            // Initialize Theme
            const savedTheme = localStorage.getItem('theme');
            if (savedTheme === 'dark' || (!savedTheme && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
                this.isDarkMode = true;
                document.documentElement.setAttribute('data-theme', 'dark');
            } else {
                this.isDarkMode = false;
                document.documentElement.setAttribute('data-theme', 'light');
            }

            if(! this.$globalData.userInfo.nickname){
                this.$api.getUserInfo().then(res=>{
                    console.log('Header getUserInfo:',res);
                    if(res.status_code===1){
                        this.nickname=res.data.nickname;
                        this.avatar=res.data.avatar;
                        res.data.signInTime=res.data.signInTime.substring(0,10);
                        this.$globalData.userInfo=res.data;
                        this.isLogin=true;
                        // 登录成功后开始轮询
                        this.startUnreadPolling();
                    }
                })
            }else {
                this.nickname=this.$globalData.userInfo.nickname;
                this.avatar=this.$globalData.userInfo.avatar;
                this.isLogin=true;
                // 已登录状态开始轮询
                this.startUnreadPolling();
            }
        },
        beforeDestroy() {
            // 组件销毁时停止轮询
            this.stopUnreadPolling();
        },
        methods: {
            searchIdle() {
                if ('/search' !== this.$route.path) {
                    this.$router.push({path: '/search', query: {searchValue: this.searchValue}});
                } else {
                    this.$router.replace({path: '/search', query: {searchValue: this.searchValue}});
                    this.$router.go(0);
                }

            },
            toMe() {
                if ('/me' !== this.$route.path) {
                    this.$router.push({path: '/me'});
                }
            },
            toMessage(){
                if ('/message' !== this.$route.path) {
                    this.$router.push({path: '/message'});
                }
            },
            toRelease(){
                if ('/release' !== this.$route.path) {
                    this.$router.push({path: '/release'});
                }
            },
            toPrivateMessage(){
                if ('/private-conversations' !== this.$route.path) {
                    this.$router.push({path: '/private-conversations'});
                }
            },
            loginOut(){
                this.$api.logout().then(res=>{
                    if(res.status_code===1){
                        this.$globalData.userInfo={};
                        console.log("login out");
                        // 退出登录时停止轮询
                        this.stopUnreadPolling();
                        if ('/index' === this.$route.path) {
                            this.$router.go(0);
                        }else {
                            this.$router.push({path: '/index'});
                        }
                    }else {
                        this.$message.error('网络或系统异常，退出登录失败！');
                    }
                });

            },

            // 加载未读消息数量
            loadUnreadCount() {
                const userId = this.getCookie('shUserId');
                if (userId) {
                    this.$api.getUnreadMessageCount().then(res => {
                        if (res.status_code === 1) {
                            this.unreadCount = res.data;
                        }
                    }).catch(() => {
                        console.error('获取未读消息数量失败');
                    });
                }
            },

            // 开始未读消息轮询
            startUnreadPolling() {
                // 先立即加载一次
                this.loadUnreadCount();

                // 设置每1秒轮询一次
                this.unreadPollingInterval = setInterval(() => {
                    this.loadUnreadCount();
                }, 1000);
            },

            // 停止未读消息轮询
            stopUnreadPolling() {
                if (this.unreadPollingInterval) {
                    clearInterval(this.unreadPollingInterval);
                    this.unreadPollingInterval = null;
                }
            },

            // 处理下拉菜单命令
            handleDropdownCommand(command) {
                if (command === 'messages') {
                    this.$router.push('/private-conversations');
                }
            },

            // 获取Cookie方法
            getCookie(cname) {
                const name = cname + "=";
                const ca = document.cookie.split(';');
                for(let i = 0; i < ca.length; i++) {
                    const c = ca[i].trim();
                    if (c.indexOf(name) === 0) return c.substring(name.length, c.length);
                }
                return "";
            },
            
            toggleTheme() {
                this.isDarkMode = !this.isDarkMode;
                const theme = this.isDarkMode ? 'dark' : 'light';
                document.documentElement.setAttribute('data-theme', theme);
                localStorage.setItem('theme', theme);
            }
        }
    };
</script>
<style scoped>
    .header {
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        width: 100%;
        height: 64px; /* Slightly taller for better breathing room */
        background: rgba(255, 255, 255, 0.8); /* Fallback */
        z-index: 1000;
        transition: var(--transition-base);
    }

    [data-theme='dark'] .header {
        background: rgba(28, 28, 30, 0.8);
    }

    .header-container {
        height: 100%;
        display: flex;
        align-items: center;
        justify-content: space-between;
        max-width: 1200px;
        margin: 0 auto;
    }

    .logo-link {
        display: flex;
        align-items: center;
        text-decoration: none;
    }

    .logo-img {
        width: 32px;
        height: 32px;
        margin-right: 8px;
    }

    .logo-text {
        font-size: 20px;
        font-weight: 600;
        color: var(--color-text-primary);
        letter-spacing: -0.5px;
    }

    .search-container {
        width: 360px;
        transition: var(--transition-fast);
    }
    
    .search-container:focus-within {
        width: 400px;
    }

    .header-actions {
        display: flex;
        align-items: center;
        gap: 16px;
    }

    .action-item {
        margin-left: 0 !important; /* Override Element UI margins if any */
    }

    .header-icon-btn {
        position: relative;
        font-size: 24px;
        color: var(--color-text-primary);
        cursor: pointer;
        padding: 8px;
        border-radius: 50%;
        transition: var(--transition-fast);
    }

    .header-icon-btn:hover {
        background-color: var(--color-bg-secondary);
    }

    .unread-badge {
        position: absolute;
        top: 4px;
        right: 4px;
        background-color: var(--color-danger);
        color: white;
        border-radius: 10px;
        min-width: 16px;
        height: 16px;
        font-size: 10px;
        text-align: center;
        line-height: 16px;
        padding: 0 4px;
        border: 2px solid #fff;
    }

    .login-link {
        font-size: 15px;
        font-weight: 500;
        color: var(--color-brand-highlight);
        padding: 8px 16px;
        border-radius: 20px;
        transition: var(--transition-fast);
    }

    .login-link:hover {
        background-color: var(--color-bg-secondary);
    }

    .user-profile {
        display: flex;
        align-items: center;
        cursor: pointer;
        padding: 4px 8px 4px 12px;
        border-radius: 20px;
        transition: var(--transition-fast);
    }

    .user-profile:hover {
        background-color: var(--color-bg-secondary);
    }

    .user-name {
        font-size: 14px;
        color: var(--color-text-primary);
        margin-right: 8px;
        font-weight: 500;
    }
    
    /* Element UI Overrides for Header */
    ::v-deep .el-input-group__append {
        background-color: transparent;
        border: none;
        padding: 0 10px;
    }
    
    ::v-deep .el-input__inner {
        background-color: var(--color-bg-secondary) !important;
        border: none !important;
        border-radius: 20px !important; /* Capsule shape */
    }
    
    ::v-deep .el-input__inner:focus {
        background-color: #fff !important;
        box-shadow: 0 0 0 2px var(--color-brand-highlight) !important;
    }

    .relative-container {
        position: relative;
    }

    .unread-badge-btn {
        position: absolute;
        top: -5px;
        right: -5px;
        background-color: var(--color-danger);
        color: white;
        border-radius: 10px;
        min-width: 18px;
        height: 18px;
        font-size: 11px;
        text-align: center;
        line-height: 18px;
        padding: 0 4px;
        border: 2px solid #fff;
        z-index: 10;
    }
</style>