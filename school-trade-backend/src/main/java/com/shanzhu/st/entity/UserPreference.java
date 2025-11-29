// 文件: UserPreference.java
package com.shanzhu.st.entity;

import lombok.Data;
import java.util.Date;

@Data
public class UserPreference {
    private Long id;
    private Long userId;
    private Integer labelId;
    private Double preferenceScore;
    private Date updateTime;
}