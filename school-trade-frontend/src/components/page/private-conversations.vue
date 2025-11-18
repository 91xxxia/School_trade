<template>
    <div>
        <app-head></app-head>
        <app-body>
            <div class="conversation-container">
                <div class="conversation-title">私信会话</div>

                <!-- 会话列表 -->
                <div v-for="(conversation, index) in conversations"
                     :key="index"
                     class="conversation-item"
                     @click="enterConversation(conversation)">

                    <el-image
                        class="avatar"
                        :src="getOtherUser(conversation).avatar"
                        fit="cover">
                    </el-image>

                    <div class="conversation-info">
                        <div class="user-info">
                            <span class="nickname">{{ getOtherUser(conversation).nickname }}</span>
                            <span class="time">{{ formatTime(conversation.sendTime) }}</span>
                        </div>
                        <div class="last-message">
                            <span>{{ conversation.content }}</span>
                            <span v-if="!conversation.isRead" class="unread-badge">新</span>
                        </div>
                    </div>
                </div>

                <!-- 空状态 -->
                <div v-if="conversations.length === 0" class="empty-state">
                    暂无私信会话
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
    padding: 20px;
}

.conversation-title {
    font-size: 20px;
    font-weight: 600;
    margin-bottom: 20px;
    padding-bottom: 10px;
    border-bottom: 1px solid #eee;
}

.conversation-item {
    display: flex;
    align-items: center;
    padding: 15px 0;
    border-bottom: 1px solid #eee;
    cursor: pointer;
}

.conversation-item:hover {
    background-color: #f9f9f9;
}

.avatar {
    width: 60px;
    height: 60px;
    border-radius: 50%;
    margin-right: 15px;
}

.conversation-info {
    flex: 1;
    overflow: hidden;
}

.user-info {
    display: flex;
    justify-content: space-between;
    margin-bottom: 5px;
}

.nickname {
    font-weight: 600;
    font-size: 16px;
}

.time {
    font-size: 12px;
    color: #999;
}

.last-message {
    display: flex;
    justify-content: space-between;
    align-items: center;
    font-size: 14px;
    color: #666;
}

.unread-badge {
    background-color: #ff4d4f;
    color: white;
    border-radius: 10px;
    padding: 2px 6px;
    font-size: 12px;
    margin-left: 10px;
}

.empty-state {
    text-align: center;
    padding: 50px 0;
    color: #999;
    font-size: 16px;
}
</style>