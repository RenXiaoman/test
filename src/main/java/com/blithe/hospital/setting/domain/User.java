package com.blithe.hospital.setting.domain;

/**
 * Author:  blithe.xwj
 * Date:    2022/6/21 10:31
 * Description:
 */

public class User {
    /*
        关于字符串中表现的日期及时间
        我们在市场上常用的有两种方式
        日期：年月日
            yyyy-MM-dd 10位字符串
        日期 + 时间 ： 年月日时分秒
            yyyy-MM-dd HH:mm:ss 19位字符串
     */


    private String id; // 编号 主键
    private String loginAct; //  登陆账号
    private String name; // 用户的真实姓名
    private String loginPwd; // 登陆密码
    private String lockState; // 锁定状态 0表示锁定，1表示启用
    private String allowIps; // 允许访问的ip地址

    public User() {
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getLoginAct() {
        return loginAct;
    }

    public void setLoginAct(String loginAct) {
        this.loginAct = loginAct;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLoginPwd() {
        return loginPwd;
    }

    public void setLoginPwd(String loginPwd) {
        this.loginPwd = loginPwd;
    }

    public String getLockState() {
        return lockState;
    }

    public void setLockState(String lockState) {
        this.lockState = lockState;
    }

    public String getAllowIps() {
        return allowIps;
    }

    public void setAllowIps(String allowIps) {
        this.allowIps = allowIps;
    }
}
