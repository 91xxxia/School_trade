<template>
    <div>
        <app-head></app-head>
        <app-body>
            <div class="message-container">
                <!-- 头部信息 - 固定在顶部 -->
                <div class="message-header fixed-header">
                    <el-button type="text" @click="goBack">
                        <i class="el-icon-arrow-left"></i> 返回
                    </el-button>
                    <div class="user-info">
                        <el-image
                            class="avatar"
                            :src="targetUser.avatar"
                            fit="cover">
                        </el-image>
                        <span class="nickname">{{ targetUser.nickname }}</span>
                    </div>
                </div>

                <!-- 消息列表 - 可滚动区域 -->
                <div class="message-list-wrapper">
                    <div class="message-list" ref="messageList">
                        <div v-for="(msg, index) in messages" :key="index"
                             :class="['message-item', msg.senderId == userId ? 'sent' : 'received']">

                            <el-image
                                class="avatar"
                                :src="msg.senderId == userId ? myAvatar : targetUser.avatar"
                                fit="cover">
                            </el-image>

                            <div class="message-content">
                                <div class="text">{{ msg.content }}</div>
                                <div class="time">{{ formatTime(msg.sendTime) }}</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 消息输入框 - 固定在底部 -->
                <div class="message-input-area fixed-footer">
                    <el-input
                        type="textarea"
                        autosize
                        placeholder="输入消息..."
                        v-model="messageContent"
                        maxlength="500"
                        show-word-limit
                        @keyup.enter.native="sendMessage">
                    </el-input>
                    <el-button type="primary" @click="sendMessage">发送</el-button>
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
    name: "private-message",
    components: {
        AppHead,
        AppBody,
        AppFoot
    },
    data() {
        return {
            messages: [],
            messageContent: '',
            targetUserId: '',
            userId: '',
            targetUser: {
                nickname: '',
                avatar: ''
            },
            myAvatar: '',

            pollingInterval: null,
            isScrolling: false, // 防止滚动冲突
            lastMessageCount: 0, // 记录上次消息数量
            autoScroll: true // 是否自动滚动到底部
        };
    },
    created() {
        this.userId = this.getCookie('shUserId');
        this.targetUserId = this.$route.query.targetUserId;

        if (!this.targetUserId) {
            this.$message.error('参数错误');
            this.goBack();
            return;
        }

        this.loadMessages();
        this.startPolling(); // 开始轮询
    },
    beforeDestroy() {
        this.stopPolling(); // 组件销毁时停止轮询
    },
    methods: {
        // 获取Cookie
        getCookie(cname) {
            const name = cname + "=";
            const ca = document.cookie.split(';');
            for(let i = 0; i < ca.length; i++) {
                const c = ca[i].trim();
                if (c.indexOf(name) === 0) return c.substring(name.length, c.length);
            }
            return "";
        },

        // 返回上一页
        goBack() {
            this.$router.go(-1);
        },

        // 加载消息记录
        loadMessages() {
            // 如果正在滚动，跳过本次轮询
            if (this.isScrolling) {
                return;
            }

            this.$api.getPrivateMessageRecords({
                targetUserId: this.targetUserId
            }).then(res => {
                if (res.status_code === 1) {
                    const newMessageCount = res.data.length;
                    const hasNewMessages = newMessageCount > this.lastMessageCount;

                    this.messages = res.data;
                    this.lastMessageCount = newMessageCount;

                    // 如果有新消息并且启用了自动滚动，滚动到底部
                    if (hasNewMessages && this.autoScroll) {
                        this.$nextTick(() => {
                            this.scrollToBottom();
                        });
                    }

                    // 标记未读消息为已读
                    const unreadIds = res.data
                        .filter(msg => !msg.isRead && msg.receiverId == this.userId)
                        .map(msg => msg.id);
                    if (unreadIds.length > 0) {
                        this.markAsRead(unreadIds);
                    }

                    // 加载用户信息
                    this.loadUserInfo();
                } else {
                    this.$message.error(res.msg || '获取消息失败');
                }
            }).catch(() => {
                // 网络错误时不提示，避免频繁弹窗
                console.warn('轮询获取消息失败');
            });
        },

        // 加载用户信息
        loadUserInfo() {
            // 这里可以通过用户ID获取用户详细信息
            // 为简化，从消息中获取对方信息
            if (this.messages.length > 0) {
                const firstMsg = this.messages[0];
                this.targetUser = firstMsg.senderId == this.userId ?
                    firstMsg.receiverUser : firstMsg.senderUser;
                this.myAvatar = firstMsg.senderId == this.userId ?
                    firstMsg.senderUser.avatar : firstMsg.receiverUser.avatar;
            }
        },

        // 发送消息
        sendMessage() {
            const content = this.messageContent.trim();
            if (!content) {
                this.$message.warning('消息内容不能为空');
                return;
            }

            this.$api.sendPrivateMessage({
                receiverId: this.targetUserId,
                content: content
            }).then(res => {
                if (res.status_code === 1) {
                    this.messages.push(res.data);
                    this.messageContent = '';
                    this.lastMessageCount = this.messages.length;

                    // 发送后启用自动滚动并滚动到底部
                    this.autoScroll = true;
                    this.$nextTick(() => {
                        this.scrollToBottom();
                    });

                    // 发送后立即触发一次轮询，确保消息同步
                    setTimeout(() => {
                        this.loadMessages();
                    }, 500);
                } else {
                    this.$message.error(res.msg || '发送失败');
                }
            }).catch(() => {
                this.$message.error('网络异常');
            });
        },

        // 开始轮询
        startPolling() {
            this.loadMessages();
            this.pollingInterval = setInterval(() => {
                this.loadMessages();
            }, 2000); // 每2秒轮询一次
        },

        // 停止轮询
        stopPolling() {
            if (this.pollingInterval) {
                clearInterval(this.pollingInterval);
                this.pollingInterval = null;
            }
        },

        // 标记消息为已读
        markAsRead(ids) {
            this.$api.markMessagesAsRead(ids).then(res => {
                if (res.status_code !== 1) {
                    console.error('标记已读失败');
                }
            }).catch(() => {
                console.error('标记已读网络异常');
            });
        },

        // 滚动到底部
        scrollToBottom() {
            this.isScrolling = true;

            const container = this.$refs.messageList;
            if (!container) {
                this.isScrolling = false;
                return;
            }

            // 直接滚动到底部
            container.scrollTop = container.scrollHeight;

            // 简单延时后重置标志
            setTimeout(() => {
                this.isScrolling = false;
            }, 100);
        },

        // 格式化时间
        formatTime(timeStr) {
            if (!timeStr) return '';
            const date = new Date(timeStr);
            const now = new Date();
            const today = new Date(now.getFullYear(), now.getMonth(), now.getDate());
            const yesterday = new Date(today);
            yesterday.setDate(yesterday.getDate() - 1);
            const messageDate = new Date(date.getFullYear(), date.getMonth(), date.getDate());

            let dateStr = '';

            if (messageDate.getTime() === today.getTime()) {
                // 今天：显示时间
                dateStr = `${this.padZero(date.getHours())}:${this.padZero(date.getMinutes())}`;
            } else if (messageDate.getTime() === yesterday.getTime()) {
                // 昨天：显示昨天 + 时间
                dateStr = `昨天 ${this.padZero(date.getHours())}:${this.padZero(date.getMinutes())}`;
            } else if (now.getFullYear() === date.getFullYear()) {
                // 今年：显示月日 + 时间
                dateStr = `${date.getMonth() + 1}月${date.getDate()}日 ${this.padZero(date.getHours())}:${this.padZero(date.getMinutes())}`;
            } else {
                // 往年：显示年月日 + 时间
                dateStr = `${date.getFullYear()}年${date.getMonth() + 1}月${date.getDate()}日 ${this.padZero(date.getHours())}:${this.padZero(date.getMinutes())}`;
            }

            return dateStr;
        },

        // 补零
        padZero(num) {
            return num < 10 ? '0' + num : num;
        }
    },
    mounted() {
        // 监听消息列表的滚动事件
        const messageList = this.$refs.messageList;
        if (messageList) {
            messageList.addEventListener('scroll', () => {
                // 如果用户手动向上滚动查看历史消息，则禁用自动滚动
                const threshold = 50; // 距离底部的阈值
                const isNearBottom = messageList.scrollHeight - messageList.scrollTop - messageList.clientHeight < threshold;

                this.autoScroll = isNearBottom;
            });
        }
    }
};
</script>

<style scoped>
.message-container {
    height: calc(100vh - 120px); /* 减去头部和底部的高度 */
    display: flex;
    flex-direction: column;
    position: relative;
}

/* 固定头部 */
.fixed-header {
    position: sticky;
    top: 0;
    z-index: 100;
    background: white;
    flex-shrink: 0;
}

.message-header {
    padding: 15px 20px;
    border-bottom: 1px solid #eee;
    display: flex;
    align-items: center;
}

.user-info {
    display: flex;
    align-items: center;
    flex: 1;
    justify-content: center;
}

.message-header .avatar {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    margin-right: 10px;
}

.nickname {
    font-size: 16px;
    font-weight: 600;
}

/* 消息列表容器 - 可滚动区域 */
.message-list-wrapper {
    flex: 1;
    overflow: hidden;
    position: relative;
}

.message-list {
    height: 100%;
    padding: 20px;
    overflow-y: auto;
    background-color: #f5f5f5;
    box-sizing: border-box;
}

.message-item {
    display: flex;
    margin-bottom: 20px;
    max-width: 80%;
}

.message-item.sent {
    flex-direction: row-reverse;
    margin-left: auto;
}

.message-item .avatar {
    width: 40px;
    height: 40px;
    border-radius: 50%;
}

.message-item.received .avatar {
    margin-right: 10px;
}

.message-item.sent .avatar {
    margin-left: 10px;
}

.message-content {
    max-width: calc(100% - 50px);
}

.message-item.received .text {
    background-color: white;
    padding: 10px 15px;
    border-radius: 18px 18px 18px 0;
}

.message-item.sent .text {
    background-color: #409eff;
    color: white;
    padding: 10px 15px;
    border-radius: 18px 18px 0 18px;
}

.time {
    font-size: 12px;
    color: #999;
    margin-top: 5px;
    text-align: right;
}

/* 固定底部输入框 */
.fixed-footer {
    position: sticky;
    bottom: 0;
    z-index: 100;
    background: white;
    flex-shrink: 0;
}

.message-input-area {
    padding: 15px 20px;
    border-top: 1px solid #eee;
    display: flex;
    gap: 10px;
}

.message-input-area .el-input {
    flex: 1;
}

.message-input-area .el-button {
    align-self: flex-end;
}
</style>