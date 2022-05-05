package com.markerhub.common.lang;/**
 * @Author Tianshuo
 * @ClassName Result
 * @Description class function:
 * @Date 2022/4/28 20:17:41
 **/

import lombok.Data;

import java.io.Serializable;

/**
 * @Author sc
 * @ClassName Result
 * @Description class function:
 * @Date 2022/4/28 20:17:41
 **/

@Data
public class Result implements Serializable {
    private int code;
    private String msg;
    private Object data;


    public static Result  succ(Object data) {
        return succ(100, "操作成功", data);
    }

    public static Result succ(int code, String msg, Object data) {
        Result r = new Result();
        r.setCode(code);
        r.setMsg(msg);
        r.setData(data);
        return r;
    }


    public static Result fail(String msg) {
        return succ(400, msg, null );
    }

    public static Result fail(int code, String msg, Object data) {
        Result r = new Result();
        r.setCode(code);
        r.setMsg(msg);
        r.setData(data);
        return r;
    }
}
