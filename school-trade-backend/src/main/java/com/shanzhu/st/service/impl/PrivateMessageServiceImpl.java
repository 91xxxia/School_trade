package com.shanzhu.st.service.impl;

import com.shanzhu.st.entity.PrivateMessage;
import com.shanzhu.st.entity.User;
import com.shanzhu.st.mapper.PrivateMessageMapper;
import com.shanzhu.st.mapper.UserMapper;
import com.shanzhu.st.service.PrivateMessageService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 私信服务实现类
 * @author: ShanZhu
 * @date: 2024-01-05
 */
@Service
public class PrivateMessageServiceImpl implements PrivateMessageService {

    @Resource
    private PrivateMessageMapper privateMessageMapper;

    @Resource
    private UserMapper userMapper;

    @Override
    public boolean sendMessage(PrivateMessage message) {
        return privateMessageMapper.insert(message) == 1;
    }

    @Override
    public List<PrivateMessage> getMessageRecords(Long senderId, Long receiverId) {
        List<PrivateMessage> messages = privateMessageMapper.getMessageRecords(senderId, receiverId);
        if (!messages.isEmpty()) {
            // 封装用户信息
            List<Long> userIds = new ArrayList<>();
            userIds.add(senderId);
            userIds.add(receiverId);

            List<User> users = userMapper.findUserByList(userIds);
            Map<Long, User> userMap = new HashMap<>();
            for (User user : users) {
                userMap.put(user.getId(), user);
            }

            for (PrivateMessage msg : messages) {
                msg.setSenderUser(userMap.get(msg.getSenderId()));
                msg.setReceiverUser(userMap.get(msg.getReceiverId()));
            }
        }
        return messages;
    }

    @Override
    public int getUnreadCount(Long userId) {
        List<PrivateMessage> unread = privateMessageMapper.getUnreadMessages(userId);
        return unread.size();
    }

    @Override
    public boolean markAsRead(List<Long> ids) {
        if (ids.isEmpty()) {
            return true;
        }
        return privateMessageMapper.markAsRead(ids) > 0;
    }

    @Override
    public List<PrivateMessage> getConversationList(Long userId) {
        List<PrivateMessage> conversations = privateMessageMapper.getConversationList(userId);
        if (!conversations.isEmpty()) {
            List<Long> userIds = new ArrayList<>();
            for (PrivateMessage msg : conversations) {
                userIds.add(msg.getSenderId().equals(userId) ? msg.getReceiverId() : msg.getSenderId());
            }

            List<User> users = userMapper.findUserByList(userIds);
            Map<Long, User> userMap = new HashMap<>();
            for (User user : users) {
                userMap.put(user.getId(), user);
            }

            for (PrivateMessage msg : conversations) {
                if (msg.getSenderId().equals(userId)) {
                    msg.setReceiverUser(userMap.get(msg.getReceiverId()));
                } else {
                    msg.setSenderUser(userMap.get(msg.getSenderId()));
                }
            }
        }
        return conversations;
    }
}