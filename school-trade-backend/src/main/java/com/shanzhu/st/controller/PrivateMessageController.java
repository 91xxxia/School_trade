package com.shanzhu.st.controller;

import com.shanzhu.st.entity.PrivateMessage;
import com.shanzhu.st.enums.ErrorMsg;
import com.shanzhu.st.service.PrivateMessageService;
import com.shanzhu.st.vo.R;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import java.util.Date;
import java.util.List;

/**
 * 私信控制器
 * @author: ShanZhu
 * @date: 2024-01-05
 */
@CrossOrigin
@RestController
@RequestMapping("/private-message")
public class PrivateMessageController {

    @Resource
    private PrivateMessageService privateMessageService;

    /**
     * 发送私信
     */
    @PostMapping("/send")
    public R sendMessage(
            @CookieValue("shUserId")
            @NotNull(message = "登录异常 请重新登录")
            @NotEmpty(message = "登录异常 请重新登录") String shUserId,
            @RequestBody PrivateMessage message
    ) {
        message.setSenderId(Long.valueOf(shUserId));
        message.setSendTime(new Date());
        message.setIsRead(false);

        if (privateMessageService.sendMessage(message)) {
            return R.success(message);
        }
        return R.fail(ErrorMsg.SYSTEM_ERROR);
    }

    /**
     * 获取私信记录
     */
    @GetMapping("/records")
    public R getMessageRecords(
            @CookieValue("shUserId")
            @NotNull(message = "登录异常 请重新登录")
            @NotEmpty(message = "登录异常 请重新登录") String shUserId,
            @RequestParam Long targetUserId
    ) {
        return R.success(privateMessageService.getMessageRecords(
                Long.valueOf(shUserId), targetUserId));
    }

    /**
     * 获取未读消息数量
     */
    @GetMapping("/unread/count")
    public R getUnreadCount(
            @CookieValue("shUserId")
            @NotNull(message = "登录异常 请重新登录")
            @NotEmpty(message = "登录异常 请重新登录") String shUserId
    ) {
        return R.success(privateMessageService.getUnreadCount(Long.valueOf(shUserId)));
    }

    /**
     * 标记消息为已读
     */
    @PostMapping("/mark-read")
    public R markAsRead(
            @CookieValue("shUserId")
            @NotNull(message = "登录异常 请重新登录")
            @NotEmpty(message = "登录异常 请重新登录") String shUserId,
            @RequestBody List<Long> messageIds
    ) {
        if (privateMessageService.markAsRead(messageIds)) {
            return R.success();
        }
        return R.fail(ErrorMsg.SYSTEM_ERROR);
    }

    /**
     * 获取会话列表
     */
    @GetMapping("/conversations")
    public R getConversationList(
            @CookieValue("shUserId")
            @NotNull(message = "登录异常 请重新登录")
            @NotEmpty(message = "登录异常 请重新登录") String shUserId
    ) {
        return R.success(privateMessageService.getConversationList(Long.valueOf(shUserId)));
    }
}