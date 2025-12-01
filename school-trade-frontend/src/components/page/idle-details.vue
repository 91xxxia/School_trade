<template>
    <div>
        <app-head></app-head>
        <app-body>
            <div class="idle-details-container app-container">
                <div class="details-card apple-card">
                    <div class="details-header">
                        <div class="user-info-section">
                            <el-avatar :size="64" :src="idleItemInfo.user.avatar" class="user-avatar"></el-avatar>
                            <div class="user-text">
                                <div class="user-nickname text-h3">{{idleItemInfo.user.nickname}}</div>
                                <div class="user-meta text-small">{{idleItemInfo.user.signInTime.substring(0,10)}} 加入平台</div>
                            </div>
                            <el-button
                                type="primary"
                                plain
                                class="apple-btn-secondary contact-btn"
                                icon="el-icon-chat-dot-round"
                                @click="sendPrivateMessage(idleItemInfo.userId)">
                                私信卖家
                            </el-button>
                        </div>
                        
                        <div class="action-section">
                            <div class="price-tag">
                                <span class="currency">￥</span>
                                <span class="amount">{{idleItemInfo.idlePrice}}</span>
                            </div>
                            
                            <div class="action-buttons">
                                <div v-if="!isMaster&&idleItemInfo.idleStatus!==1" class="status-tag">已下架或删除</div>
                                
                                <template v-if="!isMaster&&idleItemInfo.idleStatus===1">
                                    <el-button type="danger" class="apple-btn-primary buy-btn" @click="buyButton(idleItemInfo)">立即购买</el-button>
                                    <el-button class="apple-btn-secondary fav-btn" @click="favoriteButton(idleItemInfo)">
                                        <i :class="isFavorite ? 'el-icon-star-on' : 'el-icon-star-off'"></i>
                                        {{isFavorite?'已收藏':'收藏'}}
                                    </el-button>
                                </template>
                                
                                <template v-if="isMaster">
                                    <el-button v-if="idleItemInfo.idleStatus===1" type="danger" plain class="apple-btn-secondary" @click="changeStatus(idleItemInfo,2)">下架</el-button>
                                    <el-button v-if="idleItemInfo.idleStatus===2" type="primary" plain class="apple-btn-secondary" @click="changeStatus(idleItemInfo,1)">重新上架</el-button>
                                </template>
                            </div>
                        </div>
                    </div>

                    <div class="details-content">
                        <h1 class="item-title text-h2">{{idleItemInfo.idleName}}</h1>
                        
                        <div class="image-carousel-container" v-if="idleItemInfo.pictureList && idleItemInfo.pictureList.length > 0">
                            <el-carousel trigger="click" height="500px" :autoplay="false" indicator-position="none" @change="handleCarouselChange" ref="carousel">
                                <el-carousel-item v-for="(imgUrl,i) in idleItemInfo.pictureList" :key="i">
                                    <el-image
                                        style="width: 100%; height: 100%"
                                        :src="imgUrl"
                                        fit="contain"
                                        :preview-src-list="idleItemInfo.pictureList">
                                    </el-image>
                                </el-carousel-item>
                            </el-carousel>
                            <div class="carousel-progress">
                                <div class="progress-bar" :style="{width: ((currentImageIndex + 1) / idleItemInfo.pictureList.length * 100) + '%'}"></div>
                            </div>
                        </div>

                        <div class="item-description text-body" v-html="idleItemInfo.idleDetails"></div>
                    </div>
                </div>

                <div class="comments-card apple-card" id="replyMessageLocation">
                    <div class="section-title text-h3">全部留言 ({{messageList.length}})</div>
                    
                    <div class="message-send-area">
                        <div v-if="isReply" class="reply-tag">
                            <el-tag closable @close="cancelReply" type="info">
                                回复：{{replyData.toUserNickname}}
                            </el-tag>
                        </div>
                        <div class="input-wrapper">
                            <el-input
                                    type="textarea"
                                    :rows="3"
                                    placeholder="写下你的留言..."
                                    v-model="messageContent"
                                    maxlength="200"
                                    show-word-limit
                                    class="apple-textarea">
                            </el-input>
                            <el-button type="primary" class="apple-btn-primary send-btn" @click="sendMessage">发送</el-button>
                        </div>
                    </div>

                    <div class="message-list">
                        <div v-for="(mes,index) in messageList" :key="index" class="message-item">
                            <el-avatar :size="40" :src="mes.fromU.avatar" class="message-avatar"></el-avatar>
                            <div class="message-body">
                                <div class="message-header">
                                    <span class="message-author">{{mes.fromU.nickname}}</span>
                                    <span class="message-time">{{mes.createTime}}</span>
                                </div>
                                <div class="message-content">
                                    <span v-if="mes.toU.nickname" class="reply-target">@{{mes.toU.nickname}} </span>
                                    <span v-html="mes.content"></span>
                                </div>
                                <div class="message-actions">
                                    <el-button type="text" size="small" @click="replyMessage(index)">回复</el-button>
                                </div>
                            </div>
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
    import $ from 'jquery';

    export default {
        name: "idle-details",
        components: {
            AppHead,
            AppBody,
            AppFoot
        },
        data() {
            return {
                messageContent:'',
                toUser:null,
                toMessage:null,
                isReply:false,
                replyData:{
                    toUserNickname:'',
                    toMessage:''
                },
                messageList:[],
                idleItemInfo:{
                    id:'',
                    idleName:'',
                    idleDetails:'',
                    pictureList:[],
                    idlePrice:0,
                    idlePlace:'',
                    idleLabel:'',
                    idleStatus:-1,
                    userId:'',
                    user:{
                        avatar:'',
                        nickname:'',
                        signInTime:''
                    },
                },
                isMaster:false,
                isFavorite:true,
                favoriteId:0,
                currentImageIndex: 0
            };
        },
        created(){
            let id=this.$route.query.id;
            this.$api.getIdleItem({
                id:id
            }).then(res=>{
                console.log(res);
                if(res.data){
                    let list=res.data.idleDetails.split(/\r?\n/);
                    let str='';
                    for(let i=0;i<list.length;i++){
                        str+='<p>'+list[i]+'</p>';
                    }
                    res.data.idleDetails=str;
                    res.data.pictureList=JSON.parse(res.data.pictureList);
                    this.idleItemInfo=res.data;
                    console.log(this.idleItemInfo);
                    let userId=this.getCookie('shUserId');
                    console.log('userid',userId)
                    if(userId == this.idleItemInfo.userId){
                        console.log('isMaster');
                        this.isMaster=true;
                    }
                    this.checkFavorite();
                    this.getAllIdleMessage();
                }
                $('html,body').animate({
                    scrollTop: 0
                }, {duration: 500, easing: "swing"});
            });
        },
        methods: {
            handleCarouselChange(index) {
                this.currentImageIndex = index;
            },
            getAllIdleMessage(){
                this.$api.getAllIdleMessage({
                    idleId:this.idleItemInfo.id
                }).then(res=>{
                    console.log('getAllIdleMessage',res.data);
                    if(res.status_code===1){
                        this.messageList=res.data;
                    }
                }).catch(()=>{
                })
            },
            checkFavorite(){
                this.$api.checkFavorite({
                    idleId:this.idleItemInfo.id
                }).then(res=>{
                    if(!res.data){
                        this.isFavorite=false;
                    }else {
                        this.favoriteId=res.data;
                    }
                })
            },
            getCookie(cname){
                var name = cname + "=";
                var ca = document.cookie.split(';');
                for(var i=0; i<ca.length; i++)
                {
                    var c = ca[i].trim();
                    if (c.indexOf(name)===0) return c.substring(name.length,c.length);
                }
                return "";
            },
            replyMessage(index){
                $('html,body').animate({
                    scrollTop: $("#replyMessageLocation").offset().top-100
                }, {duration: 500, easing: "swing"});
                this.isReply=true;
                this.replyData.toUserNickname=this.messageList[index].fromU.nickname;
                this.replyData.toMessage=this.messageList[index].content.substring(0,10)+(this.messageList[index].content.length>10?'...':'');
                this.toUser=this.messageList[index].userId;
                this.toMessage=this.messageList[index].id;
            },
            changeStatus(idle,status){
                this.$api.updateIdleItem({
                    id:idle.id,
                    idleStatus:status
                }).then(res=>{
                    console.log(res);
                    if(res.status_code===1){
                        this.idleItemInfo.idleStatus=status;
                    }else {
                        this.$message.error(res.msg)
                    }
                });
            },
            buyButton(idleItemInfo){
                this.$api.addOrder({
                    idleId:idleItemInfo.id,
                    orderPrice:idleItemInfo.idlePrice,
                }).then(res=>{
                    console.log(res);
                    if(res.status_code===1){
                        this.$router.push({path: '/order', query: {id: res.data.id}});
                    }else {
                        this.$message.error(res.msg)
                    }
                }).catch(e=>{

                })
            },
            favoriteButton(idleItemInfo){
                if(this.isFavorite){
                    this.$api.deleteFavorite({
                        id: this.favoriteId
                    }).then(res=>{
                        console.log(res);
                        if(res.status_code===1){
                            this.$message({
                                message: '已取消收藏！',
                                type: 'success'
                            });
                            this.isFavorite=false;
                        }else {
                            this.$message.error(res.msg)
                        }
                    }).catch(e=>{
                    })
                }else {
                    this.$api.addFavorite({
                        idleId:idleItemInfo.id
                    }).then(res=>{
                        console.log(res);
                        if(res.status_code===1){
                            this.$message({
                                message: '已收藏！',
                                type: 'success'
                            });
                            this.isFavorite=true;
                            this.favoriteId=res.data;
                        }else {
                            this.$message.error(res.msg)
                        }
                    }).catch(e=>{
                    })
                }
            },
            cancelReply(){
                this.isReply=false;
                this.toUser=this.idleItemInfo.userId;
                this.toMessage=null;
                this.replyData.toUserNickname='';
                this.replyData.toMessage='';
            },
            sendMessage(){
                let content=this.messageContent.trim();
                if(this.toUser==null){
                    this.toUser=this.idleItemInfo.userId;
                }
                if(content){
                    let contentList=content.split(/\r?\n/);
                    let contenHtml=contentList[0];
                    for(let i=1;i<contentList.length;i++){
                        contenHtml+='<br>'+contentList[i];
                    }
                    this.$api.sendMessage({
                        idleId:this.idleItemInfo.id,
                        content:contenHtml,
                        toUser:this.toUser,
                        toMessage:this.toMessage
                    }).then(res=>{
                        if(res.status_code===1){
                            this.$message({
                                message: '留言成功！',
                                type: 'success'
                            });
                            this.messageContent='';
                            this.cancelReply();
                            this.getAllIdleMessage();
                        }else {
                            this.$message.error("留言失败！"+res.msg);
                        }
                    }).catch(()=>{
                        this.$message.error("留言失败！");
                    });

                }else{
                    this.$message.error("留言为空！");
                }
            },

            // 发送私信给卖家
            sendPrivateMessage(targetUserId) {
                this.$router.push({
                    path: '/private-message',
                    query: { targetUserId: targetUserId }
                });
            }
        },
    }
</script>

<style scoped>
    .idle-details-container {
        padding-top: 40px;
        padding-bottom: 40px;
    }

    .details-card {
        margin-bottom: 32px;
        padding: 40px;
    }

    .details-header {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        margin-bottom: 40px;
        padding-bottom: 32px;
        border-bottom: 1px solid var(--color-bg-secondary);
    }

    .user-info-section {
        display: flex;
        align-items: center;
    }

    .user-avatar {
        border: 1px solid var(--color-bg-secondary);
        box-shadow: var(--shadow-glow);
    }

    .user-text {
        margin-left: 16px;
        margin-right: 24px;
    }

    .user-nickname {
        margin-bottom: 4px;
    }

    .contact-btn {
        margin-left: 16px;
    }

    .action-section {
        text-align: right;
    }

    .price-tag {
        color: var(--color-brand-highlight);
        font-weight: 600;
        margin-bottom: 16px;
    }

    .currency {
        font-size: 24px;
    }

    .amount {
        font-size: 36px; /* Requested 36px */
    }

    .action-buttons {
        display: flex;
        gap: 12px;
        justify-content: flex-end;
    }

    .status-tag {
        color: var(--color-danger);
        font-size: 16px;
        font-weight: 500;
        margin-right: 16px;
        align-self: center;
    }

    .details-content {
        max-width: 800px;
        margin: 0 auto;
    }

    .item-title {
        margin-bottom: 24px;
        text-align: center;
    }

    .image-carousel-container {
        margin: 32px 0;
        position: relative;
        border-radius: var(--radius-lg);
        overflow: hidden;
        background-color: #f9f9f9;
    }

    .carousel-progress {
        position: absolute;
        bottom: 0;
        left: 0;
        height: 2px;
        background-color: rgba(0,0,0,0.1);
        width: 100%;
        z-index: 10;
    }

    .progress-bar {
        height: 100%;
        background-color: var(--color-brand-highlight);
        transition: width 0.3s ease;
    }

    .item-description {
        line-height: 1.8;
        color: var(--color-text-primary);
        margin-top: 32px;
    }

    .comments-card {
        padding: 40px;
    }

    .section-title {
        margin-bottom: 24px;
    }

    .message-send-area {
        margin-bottom: 40px;
        background-color: var(--color-bg-secondary);
        padding: 24px;
        border-radius: var(--radius-lg);
    }

    .reply-tag {
        margin-bottom: 12px;
    }

    .input-wrapper {
        display: flex;
        flex-direction: column;
        align-items: flex-end;
    }

    .apple-textarea {
        margin-bottom: 16px;
    }
    
    ::v-deep .apple-textarea .el-textarea__inner {
        border: none;
        background-color: #fff;
        border-radius: var(--radius-md);
        padding: 16px;
        font-family: inherit;
    }

    .message-list {
        display: flex;
        flex-direction: column;
        gap: 24px;
    }

    .message-item {
        display: flex;
        padding-bottom: 24px;
        border-bottom: 1px solid var(--color-bg-secondary);
    }

    .message-item:last-child {
        border-bottom: none;
    }

    .message-avatar {
        margin-right: 16px;
        flex-shrink: 0;
    }

    .message-body {
        flex: 1;
    }

    .message-header {
        display: flex;
        justify-content: space-between;
        margin-bottom: 8px;
    }

    .message-author {
        font-weight: 600;
        font-size: 15px;
    }

    .message-time {
        font-size: 13px;
        color: var(--color-text-secondary);
    }

    .message-content {
        font-size: 15px;
        line-height: 1.5;
        color: var(--color-text-primary);
        margin-bottom: 8px;
    }

    .reply-target {
        color: var(--color-brand-highlight);
        font-weight: 500;
    }

    .message-actions {
        text-align: right;
    }
</style>

<script>
    import AppHead from '../common/AppHeader.vue';
    import AppBody from '../common/AppPageBody.vue'
    import AppFoot from '../common/AppFoot.vue'

    export default {
        name: "idle-details",
        components: {
            AppHead,
            AppBody,
            AppFoot
        },
        data() {
            return {
                messageContent:'',
                toUser:null,
                toMessage:null,
                isReply:false,
                replyData:{
                    toUserNickname:'',
                    toMessage:''
                },
                messageList:[],
                idleItemInfo:{
                    id:'',
                    idleName:'',
                    idleDetails:'',
                    pictureList:[],
                    idlePrice:0,
                    idlePlace:'',
                    idleLabel:'',
                    idleStatus:-1,
                    userId:'',
                    user:{
                        avatar:'',
                        nickname:'',
                        signInTime:''
                    },
                },
                isMaster:false,
                isFavorite:true,
                favoriteId:0
            };
        },
        created(){
            let id=this.$route.query.id;
            this.$api.getIdleItem({
                id:id
            }).then(res=>{
                console.log(res);
                if(res.data){
                    let list=res.data.idleDetails.split(/\r?\n/);
                    let str='';
                    for(let i=0;i<list.length;i++){
                        str+='<p>'+list[i]+'</p>';
                    }
                    res.data.idleDetails=str;
                    res.data.pictureList=JSON.parse(res.data.pictureList);
                    this.idleItemInfo=res.data;
                    console.log(this.idleItemInfo);
                    let userId=this.getCookie('shUserId');
                    console.log('userid',userId)
                    if(userId == this.idleItemInfo.userId){
                        console.log('isMaster');
                        this.isMaster=true;
                    }
                    this.checkFavorite();
                    this.getAllIdleMessage();
                }
                $('html,body').animate({
                    scrollTop: 0
                }, {duration: 500, easing: "swing"});
            });
        },
        methods: {
            getAllIdleMessage(){
                this.$api.getAllIdleMessage({
                    idleId:this.idleItemInfo.id
                }).then(res=>{
                    console.log('getAllIdleMessage',res.data);
                    if(res.status_code===1){
                        this.messageList=res.data;
                    }
                }).catch(()=>{
                })
            },
            checkFavorite(){
                this.$api.checkFavorite({
                    idleId:this.idleItemInfo.id
                }).then(res=>{
                    if(!res.data){
                        this.isFavorite=false;
                    }else {
                        this.favoriteId=res.data;
                    }
                })
            },
            getCookie(cname){
                var name = cname + "=";
                var ca = document.cookie.split(';');
                for(var i=0; i<ca.length; i++)
                {
                    var c = ca[i].trim();
                    if (c.indexOf(name)===0) return c.substring(name.length,c.length);
                }
                return "";
            },
            replyMessage(index){
                $('html,body').animate({
                    scrollTop: $("#replyMessageLocation").offset().top-600
                }, {duration: 500, easing: "swing"});
                this.isReply=true;
                this.replyData.toUserNickname=this.messageList[index].fromU.nickname;
                this.replyData.toMessage=this.messageList[index].content.substring(0,10)+(this.messageList[index].content.length>10?'...':'');
                this.toUser=this.messageList[index].userId;
                this.toMessage=this.messageList[index].id;
            },
            changeStatus(idle,status){
                this.$api.updateIdleItem({
                    id:idle.id,
                    idleStatus:status
                }).then(res=>{
                    console.log(res);
                    if(res.status_code===1){
                        this.idleItemInfo.idleStatus=status;
                    }else {
                        this.$message.error(res.msg)
                    }
                });
            },
            buyButton(idleItemInfo){
                this.$api.addOrder({
                    idleId:idleItemInfo.id,
                    orderPrice:idleItemInfo.idlePrice,
                }).then(res=>{
                    console.log(res);
                    if(res.status_code===1){
                        this.$router.push({path: '/order', query: {id: res.data.id}});
                    }else {
                        this.$message.error(res.msg)
                    }
                }).catch(e=>{

                })
            },
            favoriteButton(idleItemInfo){
                if(this.isFavorite){
                    this.$api.deleteFavorite({
                        id: this.favoriteId
                    }).then(res=>{
                        console.log(res);
                        if(res.status_code===1){
                            this.$message({
                                message: '已取消收藏！',
                                type: 'success'
                            });
                            this.isFavorite=false;
                        }else {
                            this.$message.error(res.msg)
                        }
                    }).catch(e=>{
                    })
                }else {
                    this.$api.addFavorite({
                        idleId:idleItemInfo.id
                    }).then(res=>{
                        console.log(res);
                        if(res.status_code===1){
                            this.$message({
                                message: '已收藏！',
                                type: 'success'
                            });
                            this.isFavorite=true;
                            this.favoriteId=res.data;
                        }else {
                            this.$message.error(res.msg)
                        }
                    }).catch(e=>{
                    })
                }
            },
            cancelReply(){
                this.isReply=false;
                this.toUser=this.idleItemInfo.userId;
                this.toMessage=null;
                this.replyData.toUserNickname='';
                this.replyData.toMessage='';
            },
            sendMessage(){
                let content=this.messageContent.trim();
                if(this.toUser==null){
                    this.toUser=this.idleItemInfo.userId;
                }
                if(content){
                    let contentList=content.split(/\r?\n/);
                    let contenHtml=contentList[0];
                    for(let i=1;i<contentList.length;i++){
                        contenHtml+='<br>'+contentList[i];
                    }
                    this.$api.sendMessage({
                        idleId:this.idleItemInfo.id,
                        content:contenHtml,
                        toUser:this.toUser,
                        toMessage:this.toMessage
                    }).then(res=>{
                        if(res.status_code===1){
                            this.$message({
                                message: '留言成功！',
                                type: 'success'
                            });
                            this.messageContent='';
                            this.cancelReply();
                            this.getAllIdleMessage();
                        }else {
                            this.$message.error("留言失败！"+res.msg);
                        }
                    }).catch(()=>{
                        this.$message.error("留言失败！");
                    });

                }else{
                    this.$message.error("留言为空！");
                }
            },

            // 发送私信给卖家
                    sendPrivateMessage(targetUserId) {
                        this.$router.push({
                            path: '/private-message',
                            query: { targetUserId: targetUserId }
                        });
                    }
        },
    }
</script>

<style scoped>
    .idle-details-container {
        min-height: 85vh;
    }

    .details-header {
        height: 80px;
        border-bottom: 10px solid #f6f6f6;
        display: flex;
        justify-content: space-between;
        padding: 20px;
        align-items: center;
    }

    .details-header-user-info {
        display: flex;
    }

    .details-header-user-info-nickname {
        font-weight: 600;
        font-size: 18px;
        margin-bottom: 10px;
    }


    .details-header-user-info-actions {
        margin-top: 10px;
    }

    .details-header-user-info-time {
        font-size: 12px;
        color: #555555;
    }

    .details-header-buy {
        display: flex;
        align-items: center;
        justify-content: space-between;
        height: 50px;
        width: 280px;
    }

    .details-info {
        padding: 20px 50px;
    }

    .details-info-title {
        font-size: 22px;
        font-weight: 600;
        margin-bottom: 20px;

    }

    .details-info-main {
        font-size: 17px;
        color: #121212;
        line-height: 160%;
    }

    .details-picture {
        margin: 20px 0;
        display: flex;
        flex-direction: column;
        align-items: center;
    }

    .message-container {
        min-height: 100px;
        border-top: 10px solid #f6f6f6;
        padding: 20px;
    }

    .message-title {
        font-size: 20px;
        font-weight: 600;
        margin-bottom: 20px;
    }
    .message-send{
        min-height: 60px;
    }
    .message-send-button{
        margin-top: 10px;
        display: flex;
        justify-content: flex-end;
    }
    .message-container-list{
        min-height: 60px;
        border-top: 1px solid #eeeeee;
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 15px 0;
    }
    .message-container-list:first-child{
        border-top:none;
    }
    .message-container-list-left{
        width: 850px;
        display: flex;
    }
    .message-container-list-right{
        width: 100px;
    }
    .message-container-list-text{
        margin-left: 10px;
    }
    .message-nickname{
        font-weight: 600;
        font-size: 18px;
        padding-bottom: 5px;
    }
    .message-content{
        font-size: 16px;
        padding-bottom: 15px;
        color: #555555;
        width: 770px;
    }
    .message-time{
        font-size: 13px;
        color: #555555;
    }
</style>