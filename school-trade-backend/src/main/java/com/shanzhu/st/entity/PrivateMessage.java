package com.shanzhu.st.entity;

import lombok.Data;

import java.io.Serializable;
import java.util.Date;

/**
 * 私信实体类
 */
@Data
public class PrivateMessage implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 自增主键 */
    private Long id;

    /** 发送者用户ID */
    private Long senderId;

    /** 接收者用户ID */
    private Long receiverId;

    /** 私信内容 */
    private String content;

    /** 发送时间 */
    private Date sendTime;

    /** 是否已读 */
    private Boolean isRead;

    /** 关联的发送者信息 */
    private User senderUser;

    /** 关联的接收者信息 */
    private User receiverUser;
}