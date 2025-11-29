// 文件: RecommendServiceImpl.java (增强版)
package com.shanzhu.st.service.impl;

import com.shanzhu.st.entity.IdleItem;
import com.shanzhu.st.entity.User;
import com.shanzhu.st.entity.UserPreference;
import com.shanzhu.st.mapper.*;
import com.shanzhu.st.service.RecommendService;
import com.shanzhu.st.vo.PageVo;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class RecommendServiceImpl implements RecommendService {

    @Resource
    private IdleItemMapper idleItemMapper;

    @Resource
    private UserMapper userMapper;

    @Resource
    private UserPreferenceMapper userPreferenceMapper;

    @Resource
    private BrowseHistoryMapper browseHistoryMapper;

    @Override
    public PageVo<IdleItem> recommendForUser(Long userId, int page, int nums) {
        System.out.println("=== 为用户 " + userId + " 生成推荐 ===");

        // 1. 检查用户是否存在
        if (!isUserExists(userId)) {
            System.out.println("用户 " + userId + " 不存在");
            return createEmptyResult("用户不存在");
        }

        // 2. 检查用户是否有足够数据用于推荐
        if (!hasSufficientDataForRecommendation(userId)) {
            System.out.println("用户 " + userId + " 数据不足，返回热门推荐");
            List<IdleItem> hotItems = hotRecommend(nums);
            return new PageVo<>(hotItems, hotItems.size(), "新用户推荐：热门商品");
        }

        // 3. 执行个性化推荐算法
        try {
            // 获取用户偏好
            Map<Integer, Double> userPreferences = getUserPreferences(userId);
            System.out.println("用户 " + userId + " 的偏好: " + userPreferences);

            // 获取所有可用商品
            List<IdleItem> allItems = getAllActiveItems();
            System.out.println("可用商品数量: " + allItems.size());

            // 根据偏好计算推荐
            List<IdleItem> recommendations = calculateRecommendations(allItems, userPreferences, nums);

            // 如果推荐不足，补充热门商品
            if (recommendations.size() < nums) {
                List<IdleItem> hotItems = getHotItems(nums - recommendations.size());
                recommendations.addAll(hotItems);
            }

            setUserInfoForItems(recommendations);

            System.out.println("最终推荐数量: " + recommendations.size());
            return new PageVo<>(recommendations, recommendations.size(), "个性化推荐");



        } catch (Exception e) {
            System.err.println("推荐失败: " + e.getMessage());
            e.printStackTrace();
            List<IdleItem> hotItems = getHotItems(nums);
            // 新增：为降级返回的热门商品设置用户信息
            setUserInfoForItems(hotItems);
            return new PageVo<>(hotItems, nums, "系统推荐：热门商品");
        }
    }

    @Override
    public boolean hasSufficientDataForRecommendation(Long userId) {
        // 检查用户是否有足够的行为数据
        int totalActions = getUserTotalActions(userId);
        System.out.println("用户 " + userId + " 的行为数据量: " + totalActions);

        // 如果用户行为数据少于2次，认为是新用户
        return totalActions >= 2;
    }

    // 检查用户是否存在
    private boolean isUserExists(Long userId) {
        try {
            User user = userMapper.selectByPrimaryKey(userId);
            return user != null;
        } catch (Exception e) {
            System.err.println("检查用户存在性失败: " + e.getMessage());
            return false;
        }
    }

    // 获取用户总行为次数
    private int getUserTotalActions(Long userId) {
        try {
            List<Long> browseItems = idleItemMapper.selectBrowseHistoryByUserId(userId);
            List<Long> favoriteItems = idleItemMapper.selectFavoriteItemsByUserId(userId);
            return (browseItems != null ? browseItems.size() : 0) +
                    (favoriteItems != null ? favoriteItems.size() : 0);
        } catch (Exception e) {
            System.err.println("获取用户行为数据失败: " + e.getMessage());
            return 0;
        }
    }

    // 创建空结果
    private PageVo<IdleItem> createEmptyResult(String message) {
        System.out.println("返回空结果: " + message);
        return new PageVo<>(new ArrayList<>(), 0, message);
    }

    // 获取用户偏好
    private Map<Integer, Double> getUserPreferences(Long userId) {
        Map<Integer, Double> preferences = new HashMap<>();

        try {
            // 首先从偏好表获取
            List<UserPreference> dbPreferences = userPreferenceMapper.selectByUserId(userId);
            for (UserPreference pref : dbPreferences) {
                preferences.put(pref.getLabelId(), pref.getPreferenceScore());
            }

            // 如果偏好表为空，从行为数据计算
            if (preferences.isEmpty()) {
                System.out.println("偏好表为空，从行为数据计算");
                preferences = calculatePreferencesFromBehavior(userId);
            }

        } catch (Exception e) {
            System.err.println("获取用户偏好失败: " + e.getMessage());
        }

        return preferences;
    }

    // 从行为数据计算偏好
    private Map<Integer, Double> calculatePreferencesFromBehavior(Long userId) {
        Map<Integer, Integer> labelCounts = new HashMap<>();

        try {
            // 浏览历史
            List<Long> browseItems = idleItemMapper.selectBrowseHistoryByUserId(userId);
            if (browseItems != null) {
                for (Long itemId : browseItems) {
                    IdleItem item = idleItemMapper.selectByPrimaryKey(itemId);
                    if (item != null) {
                        labelCounts.merge(item.getIdleLabel(), 1, Integer::sum);
                    }
                }
            }

            // 收藏记录（权重更高）
            List<Long> favoriteItems = idleItemMapper.selectFavoriteItemsByUserId(userId);
            if (favoriteItems != null) {
                for (Long itemId : favoriteItems) {
                    IdleItem item = idleItemMapper.selectByPrimaryKey(itemId);
                    if (item != null) {
                        labelCounts.merge(item.getIdleLabel(), 3, Integer::sum);
                    }
                }
            }

        } catch (Exception e) {
            System.err.println("计算行为偏好失败: " + e.getMessage());
        }

        // 转换为偏好分数并归一化
        Map<Integer, Double> preferences = new HashMap<>();
        int total = labelCounts.values().stream().mapToInt(Integer::intValue).sum();

        if (total > 0) {
            for (Map.Entry<Integer, Integer> entry : labelCounts.entrySet()) {
                preferences.put(entry.getKey(), (double) entry.getValue() / total);
            }
        }

        System.out.println("从行为计算的偏好: " + preferences);
        return preferences;
    }

    // 获取所有活跃商品
    private List<IdleItem> getAllActiveItems() {
        try {
            // 获取足够多的商品用于推荐计算
            return idleItemMapper.findIdleItem("", 0, 100);
        } catch (Exception e) {
            System.err.println("获取商品失败: " + e.getMessage());
            return new ArrayList<>();
        }
    }

    // 计算推荐
    private List<IdleItem> calculateRecommendations(List<IdleItem> allItems,
                                                    Map<Integer, Double> userPreferences,
                                                    int limit) {
        if (userPreferences.isEmpty()) {
            System.out.println("用户无偏好，返回热门商品");
            return getHotItems(limit);
        }

        // 计算每个商品的推荐分数
        Map<IdleItem, Double> itemScores = new HashMap<>();

        for (IdleItem item : allItems) {
            if (item.getIdleStatus() != 1) continue;

            double score = calculateItemScore(item, userPreferences);
            itemScores.put(item, score);
        }

        // 按分数排序并返回
        return itemScores.entrySet().stream()
                .sorted(Map.Entry.<IdleItem, Double>comparingByValue().reversed())
                .limit(limit)
                .map(Map.Entry::getKey)
                .collect(Collectors.toList());
    }

    // 计算商品分数
    private double calculateItemScore(IdleItem item, Map<Integer, Double> userPreferences) {
        double score = 0.0;

        // 1. 标签匹配（主要因素）
        Double preference = userPreferences.get(item.getIdleLabel());
        if (preference != null) {
            score += preference * 0.7; // 70%权重
        }

        // 2. 价格因素（中等价位偏好）
        double price = item.getIdlePrice().doubleValue();
        if (price > 20 && price < 200) {
            score += 0.2; // 20%权重
        }

        // 3. 新鲜度（新商品有优势）
        long daysOld = (System.currentTimeMillis() - item.getReleaseTime().getTime()) / (1000 * 60 * 60 * 24);
        double freshness = Math.max(0, 1.0 - (daysOld / 60.0)); // 60天衰减
        score += freshness * 0.1; // 10%权重

        return score;
    }

    // 获取热门商品
    private List<IdleItem> getHotItems(int limit) {
        try {
            return idleItemMapper.findIdleItem("", 0, limit).stream()
                    .filter(item -> item.getIdleStatus() == 1)
                    .sorted((a, b) -> b.getReleaseTime().compareTo(a.getReleaseTime()))
                    .limit(limit)
                    .collect(Collectors.toList());
        } catch (Exception e) {
            System.err.println("获取热门商品失败: " + e.getMessage());
            return new ArrayList<>();
        }
    }

    // 其他接口方法实现
    @Override
    public List<IdleItem> itemBasedCFRecommend(Long userId, int limit) {
        return recommendForUser(userId, 1, limit).getList();
    }

    @Override
    public List<IdleItem> contentBasedRecommend(Long userId, int limit) {
        return recommendForUser(userId, 1, limit).getList();
    }

    @Override
    public List<IdleItem> hotRecommend(int limit) {

        List<IdleItem> hotItems = getHotItems(limit);
        // 新增：为热门商品设置用户信息
        setUserInfoForItems(hotItems);
        return hotItems;
    }

    @Override
    public void recordBrowseHistory(Long userId, Long idleId) {
        try {
            browseHistoryMapper.insertBrowseHistory(userId, idleId);

            // 更新用户偏好
            IdleItem item = idleItemMapper.selectByPrimaryKey(idleId);
            if (item != null) {
                UserPreference preference = new UserPreference();
                preference.setUserId(userId);
                preference.setLabelId(item.getIdleLabel());
                preference.setPreferenceScore(1.0);
                preference.setUpdateTime(new Date());
                userPreferenceMapper.insertOrUpdate(preference);
            }

            System.out.println("成功记录用户 " + userId + " 浏览商品 " + idleId);
        } catch (Exception e) {
            System.err.println("记录浏览历史失败: " + e.getMessage());
        }
    }

    @Override
    public void recordSearchHistory(Long userId, String keyword) {
        // 暂不实现
    }

    /**
     * 为商品列表设置用户信息
     */
    private void setUserInfoForItems(List<IdleItem> items) {
        if (items.isEmpty()) {
            return;
        }
        // 收集所有商品的userId
        List<Long> userIds = new ArrayList<>();
        for (IdleItem item : items) {
            userIds.add(item.getUserId());
        }
        // 批量查询用户信息
        List<User> users = userMapper.findUserByList(userIds);
        // 建立userId到User的映射
        Map<Long, User> userMap = new HashMap<>();
        for (User user : users) {
            userMap.put(user.getId(), user);
        }
        // 为每个商品设置user
        for (IdleItem item : items) {
            item.setUser(userMap.get(item.getUserId()));
        }
    }
}