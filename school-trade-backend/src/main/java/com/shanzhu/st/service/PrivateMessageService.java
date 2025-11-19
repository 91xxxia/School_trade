package com.shanzhu.st.service;

import com.shanzhu.st.entity.PrivateMessage;
import java.util.List;

/**
 * 私信服务接口
 * @author: ShanZhu
 * @date: 2024-01-05
 */
public interface PrivateMessageService {

    /** 发送私信 */
    boolean sendMessage(PrivateMessage message);

    /** 获取两人之间的私信记录 */
    List<PrivateMessage> getMessageRecords(Long senderId, Long receiverId);

    /** 获取用户的未读私信数量 */
    int getUnreadCount(Long userId);

    /** 标记私信为已读 */
    boolean markAsRead(List<Long> ids);

    /** 获取用户的私信会话列表 */
    List<PrivateMessage> getConversationList(Long userId);
}