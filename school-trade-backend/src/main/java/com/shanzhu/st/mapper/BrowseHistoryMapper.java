// 文件: BrowseHistoryMapper.java
package com.shanzhu.st.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface BrowseHistoryMapper {
    int insertBrowseHistory(@Param("userId") Long userId, @Param("idleId") Long idleId);
}