// 文件: UserPreferenceMapper.java
package com.shanzhu.st.mapper;

import com.shanzhu.st.entity.UserPreference;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface UserPreferenceMapper {

    int insertOrUpdate(UserPreference userPreference);

    List<UserPreference> selectByUserId(@Param("userId") Long userId);

    int deleteByUserId(@Param("userId") Long userId);
}