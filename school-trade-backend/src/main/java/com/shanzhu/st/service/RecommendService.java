// 在 RecommendService.java 中添加方法
package com.shanzhu.st.service;

import com.shanzhu.st.entity.IdleItem;
import com.shanzhu.st.vo.PageVo;

import java.util.List;

/**
 * 商品推荐服务
 */
public interface RecommendService {

    /**
     * 为用户推荐商品
     */
    PageVo<IdleItem> recommendForUser(Long userId, int page, int nums);

    /**
     * 检查用户是否存在且有足够数据用于推荐
     */
    boolean hasSufficientDataForRecommendation(Long userId);

    /**
     * 基于物品的协同过滤推荐
     */
    List<IdleItem> itemBasedCFRecommend(Long userId, int limit);

    /**
     * 基于内容的推荐
     */
    List<IdleItem> contentBasedRecommend(Long userId, int limit);

    /**
     * 热门商品推荐
     */
    List<IdleItem> hotRecommend(int limit);

    /**
     * 记录用户浏览历史
     */
    void recordBrowseHistory(Long userId, Long idleId);

    /**
     * 记录用户搜索历史
     */
    void recordSearchHistory(Long userId, String keyword);
}