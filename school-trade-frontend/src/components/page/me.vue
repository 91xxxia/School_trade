<template>
    <div>
        <app-head :nickname-value="userInfo.nickname"
                  :avatarValue="userInfo.avatar"></app-head>
        <app-body>
            <div class="me-container app-container">
                <div v-show="!eidtAddress">
                    <div class="user-profile-card apple-card">
                        <div class="user-info-section">
                            <el-upload
                                    class="avatar-uploader"
                                    action="/api/file"
                                    :on-success="fileHandleSuccess"
                                    :file-list="imgFileList"
                                    accept="image/*"
                                    :show-file-list="false">
                                <div class="avatar-wrapper">
                                    <el-image
                                            class="user-avatar"
                                            :src="userInfo.avatar"
                                            fit="cover">
                                        <div slot="error" class="image-slot">
                                            <i class="el-icon-user-solid"></i>
                                        </div>
                                    </el-image>
                                    <div class="avatar-overlay">
                                        <i class="el-icon-camera"></i>
                                    </div>
                                </div>
                            </el-upload>
                            <div class="user-details">
                                <div class="user-nickname text-h2">{{userInfo.nickname}}</div>
                                <div class="user-meta text-small">{{userInfo.signInTime}} 加入平台</div>
                                <el-button type="text" class="edit-profile-btn" @click="userInfoDialogVisible = true">编辑个人信息</el-button>
                            </div>
                        </div>
                        <div class="user-actions">
                            <el-button type="primary" plain class="apple-btn-secondary" @click="eidtAddress=true">管理收货地址</el-button>
                        </div>
                    </div>

                    <el-dialog
                            @close="finishEdit"
                            title="编辑个人信息"
                            :visible.sync="userInfoDialogVisible"
                            width="400px"
                            custom-class="apple-dialog">
                        <div class="edit-form">
                            <div class="form-item">
                                <div class="form-label">昵称</div>
                                <el-input
                                        v-model="userInfo.nickname"
                                        :disabled="notUserNicknameEdit"
                                        class="apple-input-group">
                                    <el-button slot="append" icon="el-icon-edit" @click="notUserNicknameEdit = false"></el-button>
                                </el-input>
                            </div>

                            <div v-if="userPasswordEdit" class="password-edit-area">
                                <div class="form-item">
                                    <div class="form-label">原密码</div>
                                    <el-input v-model="userPassword1" show-password class="apple-input"></el-input>
                                </div>
                                <div class="form-item">
                                    <div class="form-label">新密码</div>
                                    <el-input v-model="userPassword2" show-password class="apple-input"></el-input>
                                </div>
                                <div class="form-item">
                                    <div class="form-label">确认新密码</div>
                                    <el-input v-model="userPassword3" show-password class="apple-input"></el-input>
                                </div>
                                <el-button type="primary" class="apple-btn-primary full-width" @click="savePassword">确认修改</el-button>
                            </div>
                            <div v-else class="form-item">
                                <div class="form-label">密码</div>
                                <el-input
                                        value="******"
                                        :disabled="true"
                                        class="apple-input-group">
                                    <el-button slot="append" icon="el-icon-edit" @click="userPasswordEdit = true">修改</el-button>
                                </el-input>
                            </div>
                        </div>
                        <span slot="footer" class="dialog-footer">
                            <el-button type="primary" class="apple-btn-primary" @click="userInfoDialogVisible=false">完成</el-button>
                        </span>
                    </el-dialog>

                    <div class="content-tabs-container">
                        <el-tabs v-model="activeName" @tab-click="handleClick" class="apple-tabs">
                            <el-tab-pane label="我发布的" name="1"></el-tab-pane>
                            <el-tab-pane label="我下架的" name="2"></el-tab-pane>
                            <el-tab-pane label="我收藏的" name="3"></el-tab-pane>
                            <el-tab-pane label="我卖出的" name="4"></el-tab-pane>
                            <el-tab-pane label="我买到的" name="5"></el-tab-pane>
                        </el-tabs>
                        
                        <div class="item-list">
                            <div v-for="(item,index) in dataList[activeName-1]" :key="index" class="item-card apple-card" @click="toDetails(activeName,item)">
                                <div class="item-image-wrapper">
                                    <el-image
                                            class="item-image"
                                            :src="item.imgUrl"
                                            fit="cover">
                                        <div slot="error" class="image-slot">
                                            <i class="el-icon-picture-outline"></i>
                                        </div>
                                    </el-image>
                                </div>
                                <div class="item-content">
                                    <div class="item-header">
                                        <div class="item-title text-h3">{{item.idleName}}</div>
                                        <div class="item-price">￥{{item.idlePrice}}</div>
                                    </div>
                                    <div class="item-desc text-small">{{item.idleDetails}}</div>
                                    <div class="item-footer">
                                        <div class="item-time text-small">{{item.timeStr}}</div>
                                        <div class="item-status" v-if="activeName==='4'||activeName==='5'">
                                            <el-tag size="small" effect="plain">{{orderStatus[item.orderStatus]}}</el-tag>
                                        </div>
                                        <div class="item-actions" v-if="activeName!=='4'&&activeName!=='5'">
                                            <el-button type="danger" plain size="small" class="apple-btn-danger-plain" @click.stop="handle(activeName,item,index)">
                                                {{handleName[activeName-1]}}
                                            </el-button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <el-empty v-if="dataList[activeName-1].length === 0" description="暂无数据"></el-empty>
                        </div>
                    </div>
                </div>

                <div v-show="eidtAddress" class="address-edit-container">
                    <div class="page-header-wrapper">
                        <el-page-header @back="eidtAddress=false" content="收货地址管理"></el-page-header>
                    </div>
                    
                    <div class="address-content-wrapper">
                        <div class="address-form apple-card">
                            <div class="card-title text-h3">新增地址</div>
                            <div class="form-grid">
                                <div class="form-item">
                                    <div class="form-label">收货人</div>
                                    <el-input v-model="addressInfo.consigneeName" maxlength="10" show-word-limit class="apple-input"></el-input>
                                </div>
                                <div class="form-item">
                                    <div class="form-label">手机号</div>
                                    <el-input v-model="addressInfo.consigneePhone" maxlength="11" show-word-limit class="apple-input"></el-input>
                                </div>
                                <div class="form-item full-width">
                                    <div class="form-label">地区</div>
                                    <el-cascader
                                            :options="options"
                                            v-model="selectedOptions"
                                            @change="handleAddressChange"
                                            :separator="' / '"
                                            class="full-width-cascader"
                                    >
                                    </el-cascader>
                                </div>
                                <div class="form-item full-width">
                                    <div class="form-label">详细地址</div>
                                    <el-input v-model="addressInfo.detailAddress" maxlength="50" show-word-limit class="apple-input"></el-input>
                                </div>
                            </div>
                            <div class="form-actions">
                                <el-checkbox v-model="addressInfo.defaultFlag">设为默认</el-checkbox>
                                <el-button type="primary" class="apple-btn-primary" @click="saveAddress">保存地址</el-button>
                            </div>
                        </div>

                        <div class="address-list apple-card">
                            <div class="card-title text-h3">已保存地址</div>
                            <el-table :data="addressData" style="width: 100%" :header-cell-style="{background:'#f5f5f7',color:'#1d1d1f'}">
                                <el-table-column prop="consigneeName" label="收货人" width="100"></el-table-column>
                                <el-table-column prop="consigneePhone" label="手机号" width="120"></el-table-column>
                                <el-table-column prop="detailAddressText" label="地址"></el-table-column>
                                <el-table-column label="状态" width="100">
                                    <template slot-scope="scope">
                                        <el-tag v-if="scope.row.defaultFlag" type="success" size="mini">默认</el-tag>
                                    </template>
                                </el-table-column>
                                <el-table-column label="操作" width="200" align="right">
                                    <template slot-scope="scope">
                                        <el-button type="text" size="small" @click="handleEdit(scope.$index, scope.row)">编辑</el-button>
                                        <el-button type="text" size="small" class="text-danger" @click="handleDelete(scope.$index, scope.row)">删除</el-button>
                                        <el-button v-if="!scope.row.defaultFlag" type="text" size="small" @click="handleSetDefault(scope.$index, scope.row)">设为默认</el-button>
                                    </template>
                                </el-table-column>
                            </el-table>
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

    export default {
        name: "me",
        components: {
            AppHead,
            AppBody,
            AppFoot
        },
        data() {
            return {
                imgFileList: [],
                addressInfo: {
                    consigneeName: '',
                    consigneePhone: '',
                    provinceName: '',
                    cityName: '',
                    regionName: '',
                    detailAddress: '',
                    defaultFlag: false
                },
                activeName: '1',
                handleName: ['下架', '删除', '取消收藏', '', ''],
                dataList: [
                    [],
                    [],
                    [],
                    [],
                    [],
                    [],
                    [],
                    [],
                ],
                orderStatus: ['待付款', '待发货', '待收货', '已完成', '已取消'],
                userInfoDialogVisible: false,
                notUserNicknameEdit: true,
                userPasswordEdit: false,
                userPassword1: '',
                userPassword2: '',
                userPassword3: '',
                eidtAddress: false,
                selectedOptions: [],//存放默认值
                options: options,   //存放城市数据,
                userInfo: {
                    accountNumber: "",
                    avatar: "",
                    nickname: "",
                    signInTime: "",
                },
                addressData: []
            };
        },
        created() {
            if (!this.$globalData.userInfo.nickname) {
                this.$api.getUserInfo().then(res => {
                    if (res.status_code === 1) {
                        res.data.signInTime = res.data.signInTime.substring(0, 10);
                        console.log(res.data);
                        this.$globalData.userInfo = res.data;
                        this.userInfo = this.$globalData.userInfo;
                    }
                })
            } else {
                this.userInfo = this.$globalData.userInfo;
                console.log(this.userInfo);
            }
            this.getAddressData();
            this.getIdleItemData();
            this.getMyOrder();
            this.getMySoldIdle();
            this.getMyFavorite();
        },
        methods: {
            getMyFavorite(){
                this.$api.getMyFavorite().then(res=>{
                    console.log('getMyFavorite',res);
                    if (res.status_code === 1){
                        for (let i = 0; i < res.data.length; i++) {
                            let pictureList = JSON.parse(res.data[i].idleItem.pictureList);
                            this.dataList[2].push({
                                favoriteId:res.data[i].id,
                                id:res.data[i].idleItem.id,
                                imgUrl:pictureList.length > 0 ? pictureList[0] : '',
                                idleName:res.data[i].idleItem.idleName,
                                idleDetails:res.data[i].idleItem.idleDetails,
                                timeStr:res.data[i].createTime.substring(0, 10) + " " + res.data[i].createTime.substring(11, 19),
                                idlePrice:res.data[i].idleItem.idlePrice
                            });
                        }
                    }
                })
            },
            getMySoldIdle(){
                this.$api.getMySoldIdle().then(res=>{
                    if (res.status_code === 1){
                        console.log('getMySoldIdle',res.data);
                        for (let i = 0; i < res.data.length; i++) {
                            let pictureList = JSON.parse(res.data[i].idleItem.pictureList);
                            this.dataList[3].push({
                                id:res.data[i].id,
                                imgUrl:pictureList.length > 0 ? pictureList[0] : '',
                                idleName:res.data[i].idleItem.idleName,
                                idleDetails:res.data[i].idleItem.idleDetails,
                                timeStr:res.data[i].createTime.substring(0, 10) + " " + res.data[i].createTime.substring(11, 19),
                                idlePrice:res.data[i].orderPrice,
                                orderStatus:res.data[i].orderStatus
                            });
                        }
                    }
                })
            },
            getMyOrder(){
                this.$api.getMyOrder().then(res=>{
                    if (res.status_code === 1){
                        console.log('getMyOrder',res.data);
                        for (let i = 0; i < res.data.length; i++) {
                            let pictureList = JSON.parse(res.data[i].idleItem.pictureList);
                            this.dataList[4].push({
                                id:res.data[i].id,
                                imgUrl:pictureList.length > 0 ? pictureList[0] : '',
                                idleName:res.data[i].idleItem.idleName,
                                idleDetails:res.data[i].idleItem.idleDetails,
                                timeStr:res.data[i].createTime.substring(0, 10) + " " + res.data[i].createTime.substring(11, 19),
                                idlePrice:res.data[i].orderPrice,
                                orderStatus:res.data[i].orderStatus
                            });
                        }
                    }
                })
            },
            getIdleItemData() {
                this.$api.getAllIdleItem().then(res => {
                    console.log(res);
                    if (res.status_code === 1) {
                        for (let i = 0; i < res.data.length; i++) {
                            res.data[i].timeStr = res.data[i].releaseTime.substring(0, 10) + " " + res.data[i].releaseTime.substring(11, 19);
                            let pictureList = JSON.parse(res.data[i].pictureList);
                            res.data[i].imgUrl = pictureList.length > 0 ? pictureList[0] : '';
                            if (res.data[i].idleStatus === 1) {
                                this.dataList[0].push(res.data[i]);
                            } else if (res.data[i].idleStatus === 2) {
                                this.dataList[1].push(res.data[i]);
                            }
                        }
                    }
                })
            },
            getAddressData() {
                this.$api.getAddress().then(res => {
                    if (res.status_code === 1) {
                        let data = res.data;
                        for (let i = 0; i < data.length; i++) {
                            data[i].detailAddressText = data[i].provinceName + data[i].cityName + data[i].regionName + data[i].detailAddress;
                            data[i].defaultAddress = data[i].defaultFlag ? '默认地址' : '设为默认';
                        }
                        console.log(data);
                        this.addressData = data;
                    }
                })
            },
            handleClick(tab, event) {
                // console.log(tab, event);
                console.log(this.activeName);
            },
            saveUserNickname() {
                this.notUserNicknameEdit = true;
                this.$api.updateUserPublicInfo({
                    nickname: this.userInfo.nickname
                }).then(res => {
                    console.log(res);
                    this.$globalData.userInfo.nickname = this.userInfo.nickname;
                })

            },
            savePassword() {
                if (!this.userPassword1 || !this.userPassword2) {
                    this.$message.error('密码为空！');
                } else if (this.userPassword2 === this.userPassword3) {
                    this.$api.updatePassword({
                        oldPassword: this.userPassword1,
                        newPassword: this.userPassword2
                    }).then(res => {
                        if (res.status_code === 1) {
                            this.userPasswordEdit = false;
                            this.$message({
                                message: '修改成功！',
                                type: 'success'
                            });
                            this.userPassword1 = '';
                            this.userPassword2 = '';
                            this.userPassword3 = '';
                        } else {
                            this.$message.error('旧密码错误，修改失败！');
                        }
                    })
                } else {
                    this.$message.error('两次输入的密码不一致！');
                }

            },
            finishEdit() {
                this.notUserNicknameEdit = true;
                this.userInfoDialogVisible = false;
                this.userPasswordEdit = false;
            },
            handleAddressChange(value) {
                console.log(value);
                this.addressInfo.provinceName = value[0];
                this.addressInfo.cityName = value[1];
                this.addressInfo.regionName = value[2];
            },
            handleEdit(index, row) {
                console.log(index, row);
                this.addressInfo = JSON.parse(JSON.stringify(row));
                this.selectedOptions = ['', '', ''];
                this.selectedOptions[0] = row.provinceName;
                this.selectedOptions[1] = row.cityName;
                this.selectedOptions[2] = row.regionName;
            },
            handleDelete(index, row) {
                console.log(index, row);
                this.$confirm('是否确定删除该地址?', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(() => {
                    this.$api.deleteAddress(row).then(res => {
                        if (res.status_code === 1) {
                            this.$message({
                                message: '删除成功！',
                                type: 'success'
                            });
                            this.addressData.splice(index, 1);
                            if (row.defaultFlag && this.addressData.length > 0) {
                                this.addressData[0].defaultFlag = true;
                                this.addressData[0].defaultAddress = '默认地址';
                                this.update({
                                    id: this.addressData[0].id,
                                    defaultFlag: true
                                });
                            }
                        } else {
                            this.$message.error('系统异常，删除失败！')
                        }
                    }).catch(() => {
                        this.$message.error('网络异常！')
                    });
                }).catch(() => {
                });

            },
            handleSetDefault(index, row) {
                console.log(index, row);
                row.defaultFlag = true;
                this.update(row);
            },
            toDetails(activeName, item) {
                if (activeName === '4'||activeName === '5') {
                    this.$router.push({path: '/order', query: {id: item.id}});
                } else {
                    this.$router.push({path: '/details', query: {id: item.id}});
                }
            },
            handle(activeName,item,index) {
                console.log(activeName,item,index);
                this.$confirm('是否确认？', '提示', {
                    confirmButtonText: '确认',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(() => {
                    if(activeName==='1'){
                        this.$api.updateIdleItem({
                            id:item.id,
                            idleStatus:2
                        }).then(res=>{
                            console.log(res);
                            if(res.status_code===1){
                                this.dataList[0].splice(index,1);
                                item.idleStatus=2;
                                this.dataList[1].unshift(item);
                            }else {
                                this.$message.error(res.msg)
                            }
                        });
                    }else if(activeName==='2'){
                        this.$api.updateIdleItem({
                            id:item.id,
                            idleStatus:0
                        }).then(res=>{
                            console.log(res);
                            if(res.status_code===1){
                                this.dataList[1].splice(index,1);
                            }else {
                                this.$message.error(res.msg)
                            }
                        });
                    }else if(activeName==='3'){
                        this.$api.deleteFavorite({
                            id: item.favoriteId
                        }).then(res=>{
                            console.log(res);
                            if(res.status_code===1){
                                this.$message({
                                    message: '已取消收藏！',
                                    type: 'success'
                                });
                                this.dataList[2].splice(index,1);
                            }else {
                                this.$message.error(res.msg)
                            }
                        }).catch(e=>{
                        })
                    }
                }).catch(() => {
                });

            },
            fileHandleSuccess(response, file, fileList) {
                console.log("file:", response, file, fileList);
                let imgUrl = response.data;
                this.imgFileList = [];
                this.$api.updateUserPublicInfo({
                    avatar: imgUrl
                }).then(res => {
                    console.log(res);
                    this.userInfo.avatar = imgUrl;
                    this.$globalData.userInfo.avatar = imgUrl;
                })
            },
            update(data) {
                this.$api.updateAddress(data).then(res => {
                    if (res.status_code === 1) {
                        this.getAddressData();
                        this.$message({
                            message: '修改成功！',
                            type: 'success'
                        });
                    } else {
                        this.$message.error('系统异常，修改失败！')
                    }
                }).catch(() => {
                    this.$message.error('网络异常！')
                })
            },
            saveAddress() {
                if (this.addressInfo.id) {
                    console.log('update:', this.addressInfo);
                    this.update(this.addressInfo);
                    this.addressInfo = {
                        consigneeName: '',
                        consigneePhone: '',
                        provinceName: '',
                        cityName: '',
                        regionName: '',
                        detailAddress: '',
                        defaultFlag: false
                    };
                    this.selectedOptions = [];
                } else {
                    if (this.addressData.length >= 5) {
                        this.$message.error('已达到最大地址数量！')
                    } else {
                        console.log(this.addressInfo);
                        this.$api.addAddress(this.addressInfo).then(res => {
                            if (res.status_code === 1) {
                                this.getAddressData();
                                this.$message({
                                    message: '新增成功！',
                                    type: 'success'
                                });
                                this.selectedOptions = [];
                                this.addressInfo = {
                                    consigneeName: '',
                                    consigneePhone: '',
                                    provinceName: '',
                                    cityName: '',
                                    regionName: '',
                                    detailAddress: '',
                                    defaultFlag: false
                                };
                            } else {
                                this.$message.error('系统异常，新增失败！')
                            }
                        }).catch(e => {
                            this.$message.error('网络异常！')
                        })
                    }
                }
            }
        }
    }
</script>

<style scoped>
    .me-container {
        padding-top: 40px;
        padding-bottom: 40px;
        min-height: 85vh;
    }

    .user-profile-card {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 40px;
        margin-bottom: 32px;
    }

    .user-info-section {
        display: flex;
        align-items: center;
    }

    .avatar-wrapper {
        position: relative;
        width: 100px;
        height: 100px;
        border-radius: 50%;
        overflow: hidden;
        cursor: pointer;
        box-shadow: var(--shadow-glow);
        border: 2px solid #fff;
    }

    .user-avatar {
        width: 100%;
        height: 100%;
        transition: transform 0.3s ease;
    }

    .avatar-overlay {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0,0,0,0.3);
        display: flex;
        justify-content: center;
        align-items: center;
        opacity: 0;
        transition: opacity 0.3s ease;
    }

    .avatar-overlay i {
        color: #fff;
        font-size: 24px;
    }

    .avatar-wrapper:hover .avatar-overlay {
        opacity: 1;
    }

    .avatar-wrapper:hover .user-avatar {
        transform: scale(1.1);
    }

    .user-details {
        margin-left: 24px;
    }

    .user-nickname {
        margin-bottom: 8px;
    }

    .user-meta {
        color: var(--color-text-secondary);
        margin-bottom: 8px;
    }

    .edit-profile-btn {
        padding: 0;
        font-size: 14px;
        color: var(--color-brand-highlight);
    }

    /* Tabs */
    .content-tabs-container {
        margin-top: 32px;
    }

    ::v-deep .el-tabs__header {
        margin-bottom: 24px;
    }

    ::v-deep .el-tabs__nav-wrap::after {
        display: none;
    }

    ::v-deep .el-tabs__active-bar {
        background-color: var(--color-brand-highlight);
        height: 2px;
        border-radius: 2px;
    }

    ::v-deep .el-tabs__item {
        font-size: 16px;
        color: var(--color-text-secondary);
        font-weight: 500;
    }

    ::v-deep .el-tabs__item.is-active {
        color: var(--color-text-primary);
        font-weight: 600;
    }

    /* Item List */
    .item-list {
        display: flex;
        flex-direction: column;
        gap: 24px;
    }

    .item-card {
        display: flex;
        padding: 24px;
        cursor: pointer;
        transition: var(--transition-fast);
    }

    .item-card:hover {
        transform: translateY(-2px);
        box-shadow: var(--shadow-hover);
    }

    .item-image-wrapper {
        width: 120px;
        height: 120px;
        border-radius: var(--radius-md);
        overflow: hidden;
        flex-shrink: 0;
        margin-right: 24px;
    }

    .item-image {
        width: 100%;
        height: 100%;
        transition: transform 0.5s ease;
    }

    .item-card:hover .item-image {
        transform: scale(1.05);
    }

    .item-content {
        flex: 1;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
    }

    .item-header {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        margin-bottom: 8px;
    }

    .item-title {
        font-weight: 600;
        color: var(--color-text-primary);
        margin-right: 16px;
    }

    .item-price {
        font-size: 18px;
        font-weight: 600;
        color: var(--color-brand-highlight);
    }

    .item-desc {
        color: var(--color-text-secondary);
        margin-bottom: 16px;
        display: -webkit-box;
        -webkit-box-orient: vertical;
        -webkit-line-clamp: 2;
        overflow: hidden;
        line-height: 1.5;
    }

    .item-footer {
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .item-time {
        color: var(--color-text-tertiary);
    }

    /* Address Edit */
    .address-edit-container {
        max-width: 800px;
        margin: 0 auto;
    }

    .page-header-wrapper {
        margin-bottom: 32px;
    }

    .address-content-wrapper {
        display: flex;
        flex-direction: column;
        gap: 32px;
    }

    .address-form, .address-list {
        padding: 32px;
    }

    .card-title {
        margin-bottom: 24px;
        padding-bottom: 16px;
        border-bottom: 1px solid var(--color-bg-secondary);
    }

    .form-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 24px;
        margin-bottom: 24px;
    }

    .form-item {
        display: flex;
        flex-direction: column;
    }

    .form-item.full-width {
        grid-column: span 2;
    }

    .form-label {
        font-size: 14px;
        font-weight: 500;
        margin-bottom: 8px;
        color: var(--color-text-secondary);
    }

    .full-width-cascader {
        width: 100%;
    }

    .form-actions {
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    /* Dialog */
    .edit-form {
        display: flex;
        flex-direction: column;
        gap: 20px;
    }

    .password-edit-area {
        display: flex;
        flex-direction: column;
        gap: 20px;
        padding-top: 20px;
        border-top: 1px solid var(--color-bg-secondary);
    }

    ::v-deep .apple-dialog {
        border-radius: var(--radius-lg);
        overflow: hidden;
    }

    ::v-deep .apple-dialog .el-dialog__header {
        padding: 20px;
        border-bottom: 1px solid var(--color-bg-secondary);
    }

    ::v-deep .apple-dialog .el-dialog__body {
        padding: 30px;
    }

    ::v-deep .apple-dialog .el-dialog__footer {
        padding: 20px;
        border-top: 1px solid var(--color-bg-secondary);
    }
</style>
