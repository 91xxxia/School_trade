<template>
    <div>
        <app-head></app-head>
        <app-body>
            <div class="conversation-container app-container">
                <div class="page-header">
                    <h1 class="conversation-title">私信会话</h1>
                </div>

                <!-- 会话列表 -->
                <div class="conversation-list">
                    <div v-for="(conversation, index) in conversations"
                         :key="index"
                         class="conversation-card"
                         @click="enterConversation(conversation)">

                        <div class="card-left">
                            <el-avatar 
                                :size="56" 
                                :src="getOtherUser(conversation).avatar" 
                                class="user-avatar">
                            </el-avatar>
                            <div class="conversation-info">
                                <div class="user-row">
                                    <span class="nickname">{{ getOtherUser(conversation).nickname }}</span>
                                    <span class="time">{{ formatTime(conversation.sendTime) }}</span>
                                </div>
                                <div class="message-preview">
                                    <span class="content-text">{{ conversation.content }}</span>
                                    <span v-if="!conversation.isRead" class="unread-dot"></span>
                                </div>
                            </div>
                        </div>
                        
                        <div class="card-right">
                            <i class="el-icon-arrow-right arrow-icon"></i>
                        </div>
                    </div>
                </div>

                <!-- 空状态 -->
                <div v-if="conversations.length === 0" class="empty-state">
                    <el-empty description="暂无私信会话"></el-empty>
                </div>
            </div>
            <app-foot></app-foot>
        </app-body>
    </div>
</template>

<script>
import AppHead from '../common/AppHeader.vue';
import AppBody from '../common/AppPageBody.vue';
import AppFoot from '../common/AppFoot.vue';

export default {
    name: "private-conversations",
    components: {
        AppHead,
        AppBody,
        AppFoot
    },
    data() {
        return {
            conversations: [],
            userId: ''
        };
    },
    created() {
        this.userId = this.getCookie('shUserId');
        this.loadConversations();
    },
    methods: {
        // 获取当前登录用户ID
        getCookie(cname) {
            const name = cname + "=";
            const ca = document.cookie.split(';');
            for(let i = 0; i < ca.length; i++) {
                const c = ca[i].trim();
                if (c.indexOf(name) === 0) return c.substring(name.length, c.length);
            }
            return "";
        },

        // 加载会话列表
        loadConversations() {
            this.$api.getPrivateConversations().then(res => {
                if (res.status_code === 1) {
                    this.conversations = res.data;
                } else {
                    this.$message.error(res.msg || '获取会话失败');
                }
            }).catch(() => {
                this.$message.error('网络异常');
            });
        },

        // 进入会话详情
        enterConversation(conversation) {
            const targetUserId = this.getOtherUserId(conversation);
            this.$router.push({
                path: '/private-message',
                query: { targetUserId: targetUserId }
            });
        },

        // 获取对方用户信息
        getOtherUser(conversation) {
            return conversation.senderId == this.userId ?
                conversation.receiverUser : conversation.senderUser;
        },

        // 获取对方用户ID
        getOtherUserId(conversation) {
            return conversation.senderId == this.userId ?
                conversation.receiverId : conversation.senderId;
        },

        // 格式化时间
        formatTime(timeStr) {
            if (!timeStr) return '';
            const date = new Date(timeStr);
            return `${date.getFullYear()}-${this.padZero(date.getMonth() + 1)}-${this.padZero(date.getDate())} ${this.padZero(date.getHours())}:${this.padZero(date.getMinutes())}`;
        },

        // 补零
        padZero(num) {
            return num < 10 ? '0' + num : num;
        }
    }
};
</script>

<style scoped>
.conversation-container {
    min-height: 85vh;
    padding-top: 40px;
    padding-bottom: 40px;
    max-width: 800px;
    margin: 0 auto;
}

.page-header {
    margin-bottom: 32px;
}

.conversation-title {
    font-size: 28px;
    font-weight: 700;
    color: var(--color-text-primary);
    margin: 0;
}

.conversation-list {
    display: flex;
    flex-direction: column;
    gap: 16px;
}

.conversation-card {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 20px;
    background: #fff;
    border-radius: 16px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
    cursor: pointer;
    transition: all 0.3s ease;
    border: 1px solid transparent;
}

.conversation-card:hover {
    transform: translateY(-2px);
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
    border-color: rgba(0, 0, 0, 0.05);
}

.card-left {
    display: flex;
    align-items: center;
    flex: 1;
    overflow: hidden;
}

.user-avatar {
    flex-shrink: 0;
    margin-right: 16px;
    border: 1px solid rgba(0,0,0,0.05);
}

.conversation-info {
    flex: 1;
    min-width: 0;
    display: flex;
    flex-direction: column;
    gap: 4px;
}

.user-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 2px;
}

.nickname {
    font-size: 17px;
    font-weight: 600;
    color: var(--color-text-primary);
}

.time {
    font-size: 13px;
    color: var(--color-text-tertiary);
    margin-right: 16px;
}

.message-preview {
    display: flex;
    align-items: center;
    justify-content: space-between;
}

.content-text {
    font-size: 15px;
    color: var(--color-text-secondary);
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    max-width: 90%;
}

.unread-dot {
    width: 8px;
    height: 8px;
    background-color: var(--color-danger);
    border-radius: 50%;
    margin-right: 16px;
}

.card-right {
    padding-left: 16px;
}

.arrow-icon {
    color: var(--color-text-tertiary);
    font-size: 18px;
}

.empty-state {
    padding: 60px 0;
    text-align: center;
}
</style>