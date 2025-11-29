// 文件: PageVo.java (增强版)
package com.shanzhu.st.vo;

import lombok.Data;
import java.util.List;

@Data
public class PageVo<T> {
    private List<T> list;
    private Integer count;
    private String message; // 新增：推荐消息

    public PageVo(List<T> list, Integer count) {
        this.list = list;
        this.count = count;
        this.message = "推荐成功";
    }

    public PageVo(List<T> list, Integer count, String message) {
        this.list = list;
        this.count = count;
        this.message = message;
    }
}