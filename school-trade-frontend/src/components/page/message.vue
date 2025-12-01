<template>
    <div>
        <app-head></app-head>
        <app-body>
            <div class="message-container app-container">
                <div class="page-header">
                    <h1 class="message-title">我的留言</h1>
                </div>
                
                <div class="message-list">
                    <div v-for="(mes,index) in meslist" :key="index" class="message-card" @click="toDetails(mes.idle.id)">
                        <div class="card-left">
                            <el-avatar 
                                :size="56" 
                                :src="mes.fromU.avatar" 
                                class="user-avatar">
                            </el-avatar>
                            <div class="message-info">
                                <div class="user-row">
                                    <span class="nickname">{{mes.fromU.nickname}}</span>
                                    <span class="time">{{mes.createTime}}</span>
                                </div>
                                <div class="content-text">{{mes.content}}</div>
                            </div>
                        </div>
                        <div class="card-right">
                            <el-image
                                class="idle-image"
                                :src="mes.idle.imgUrl"
                                fit="cover">
                            </el-image>
                        </div>
                    </div>
                </div>

                <div v-if="meslist.length === 0" class="empty-state">
                    <el-empty description="暂无留言消息"></el-empty>
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
        name: "message",
        components: {
            AppHead,
            AppBody,
            AppFoot
        },
        data(){
            return{
                meslist:[]
            };
        },
        created(){
            this.$api.getAllMyMessage().then(res=>{
                console.log(res);
                if(res.status_code===1){
                    for(let i=0;i<res.data.length;i++){
                        let imgList=JSON.parse(res.data[i].idle.pictureList);
                        res.data[i].idle.imgUrl=imgList?imgList[0]:'';
                        let contentList=res.data[i].content.split('<br>');
                        let contenHtml=contentList[0];
                        for(let i=1;i<contentList.length;i++){
                            contenHtml+='  '+contentList[i];
                        }
                        res.data[i].content=contenHtml;
                    }
                    this.meslist=res.data;
                }
            })
        },
        methods:{
            toDetails(id){
                this.$router.push({path: '/details',query:{id:id}});
            }
        }
    }
</script>

<style scoped>
.message-container {
    min-height: 85vh;
    padding-top: 40px;
    padding-bottom: 40px;
    max-width: 800px;
    margin: 0 auto;
}

.page-header {
    margin-bottom: 32px;
}

.message-title {
    font-size: 28px;
    font-weight: 700;
    color: var(--color-text-primary);
    margin: 0;
}

.message-list {
    display: flex;
    flex-direction: column;
    gap: 16px;
}

.message-card {
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

.message-card:hover {
    transform: translateY(-2px);
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
    border-color: rgba(0, 0, 0, 0.05);
}

.card-left {
    display: flex;
    align-items: center;
    flex: 1;
    overflow: hidden;
    margin-right: 20px;
}

.user-avatar {
    flex-shrink: 0;
    margin-right: 16px;
    border: 1px solid rgba(0,0,0,0.05);
}

.message-info {
    flex: 1;
    min-width: 0;
    display: flex;
    flex-direction: column;
    gap: 4px;
}

.user-row {
    display: flex;
    align-items: center;
    gap: 12px;
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
}

.content-text {
    font-size: 15px;
    color: var(--color-text-secondary);
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

.card-right {
    flex-shrink: 0;
}

.idle-image {
    width: 80px;
    height: 80px;
    border-radius: 8px;
    border: 1px solid rgba(0,0,0,0.05);
}

.empty-state {
    padding: 60px 0;
    text-align: center;
}
</style>