package com.shanzhu.st.mapper;

import com.shanzhu.st.entity.PrivateMessage;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 私信数据访问层
 * @author: ShanZhu
 * @date: 2024-01-05
 */
@Mapper
public interface PrivateMessageMapper {

    /** 发送私信 */
    int insert(PrivateMessage record);

    /** 获取两人之间的私信记录 */
    List<PrivateMessage> getMessageRecords(
            @Param("senderId") Long senderId,
            @Param("receiverId") Long receiverId);

    /** 获取用户的未读私信列表 */
    List<PrivateMessage> getUnreadMessages(@Param("receiverId") Long receiverId);

    /** 标记私信为已读 */
    int markAsRead(@Param("ids") List<Long> ids);

    /** 获取用户的私信会话列表 */
    List<PrivateMessage> getConversationList(@Param("userId") Long userId);
}