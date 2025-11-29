// 文件: RecommendController.java (修正版)
package com.shanzhu.st.controller;

import com.shanzhu.st.enums.ErrorMsg;
import com.shanzhu.st.service.RecommendService;
import com.shanzhu.st.vo.R;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.Enumeration;

/**
 * 商品推荐控制器
 */
@CrossOrigin
@RestController
@RequestMapping("recommend")
public class RecommendController {

    @Resource
    private RecommendService recommendService;

    /**
     * 获取个性化推荐（修正版）
     */
    @GetMapping("personal")
    public R getPersonalRecommend(
            HttpServletRequest request,
            @CookieValue(value = "shUserId", required = false) String shUserIdCookie,
            @RequestParam(value = "shUserId", required = false) String shUserIdParam,
            @RequestParam(value = "page", required = false, defaultValue = "1") Integer page,
            @RequestParam(value = "nums", required = false, defaultValue = "10") Integer nums
    ) {
        // 记录请求详情用于调试
        logRequestDetails(request, shUserIdCookie, shUserIdParam);

        // 修正：优先使用Cookie中的用户ID，如果没有则使用查询参数
        String shUserId = shUserIdCookie != null ? shUserIdCookie : shUserIdParam;

        // 检查用户ID是否存在
        if (shUserId == null || shUserId.trim().isEmpty()) {
            System.out.println("❌ 错误：未提供用户ID");
            return R.fail(ErrorMsg.valueOf("用户未登录，请先登录"));
        }

        try {
            Long userId = Long.valueOf(shUserId);
            System.out.println("✅ 开始为用户 " + userId + " 生成推荐");

            // 调用推荐服务
            return R.success(recommendService.recommendForUser(userId, page, nums));

        } catch (NumberFormatException e) {
            System.err.println("❌ 用户ID格式错误: " + shUserId);
            return R.fail(ErrorMsg.valueOf("用户ID格式错误"));
        } catch (Exception e) {
            System.err.println("❌ 推荐服务异常: " + e.getMessage());
            e.printStackTrace();
            return R.fail(ErrorMsg.valueOf("推荐服务暂时不可用，请稍后重试"));
        }
    }

    /**
     * 记录请求详细信息
     */
    private void logRequestDetails(HttpServletRequest request, String cookieUserId, String paramUserId) {
        System.out.println("=== 请求详情 ===");
        System.out.println("请求URL: " + request.getRequestURL());
        System.out.println("查询字符串: " + request.getQueryString());
        System.out.println("Cookie中的shUserId: " + (cookieUserId != null ? cookieUserId : "null"));
        System.out.println("参数中的shUserId: " + (paramUserId != null ? paramUserId : "null"));
        System.out.println("最终使用的shUserId: " + (cookieUserId != null ? cookieUserId : paramUserId));
        System.out.println("================\n");
    }

    /**
     * 检查用户是否有推荐数据
     */
    @GetMapping("check")
    public R checkUserRecommendationStatus(
            HttpServletRequest request,
            @CookieValue(value = "shUserId", required = false) String shUserIdCookie,
            @RequestParam(value = "shUserId", required = false) String shUserIdParam
    ) {
        logRequestDetails(request, shUserIdCookie, shUserIdParam);

        // 修正：优先使用Cookie，如果没有则使用查询参数
        String shUserId = shUserIdCookie != null ? shUserIdCookie : shUserIdParam;

        if (shUserId == null || shUserId.trim().isEmpty()) {
            return R.fail(ErrorMsg.valueOf("用户未登录"));
        }

        try {
            Long userId = Long.valueOf(shUserId);
            boolean hasData = recommendService.hasSufficientDataForRecommendation(userId);

            if (hasData) {
                return R.success("用户有足够的推荐数据");
            } else {
                return R.success("新用户，推荐数据不足，请先浏览一些商品");
            }

        } catch (Exception e) {
            return R.fail(ErrorMsg.valueOf("检查用户数据失败"));
        }
    }

    /**
     * 记录用户浏览历史
     */
    @PostMapping("record/browse")
    public R recordBrowseHistory(
            HttpServletRequest request,
            @CookieValue(value = "shUserId", required = false) String shUserIdCookie,
            @RequestParam(value = "shUserId", required = false) String shUserIdParam,
            @RequestParam Long idleId
    ) {
        logRequestDetails(request, shUserIdCookie, shUserIdParam);

        // 修正：优先使用Cookie，如果没有则使用查询参数
        String shUserId = shUserIdCookie != null ? shUserIdCookie : shUserIdParam;

        if (shUserId == null || shUserId.trim().isEmpty()) {
            return R.fail(ErrorMsg.valueOf("用户未登录"));
        }

        try {
            recommendService.recordBrowseHistory(Long.valueOf(shUserId), idleId);
            return R.success("浏览记录已保存");
        } catch (Exception e) {
            return R.fail(ErrorMsg.valueOf("记录浏览历史失败"));
        }
    }

    /**
     * 热门推荐（非个性化，无需登录）
     */
    @GetMapping("hot")
    public R getHotRecommend(
            @RequestParam(value = "page", required = false, defaultValue = "1") Integer page,
            @RequestParam(value = "nums", required = false, defaultValue = "10") Integer nums
    ) {
        try {
            return R.success(recommendService.hotRecommend(nums));
        } catch (Exception e) {
            return R.fail(ErrorMsg.valueOf("热门推荐服务暂时不可用"));
        }
    }
}