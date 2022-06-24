package com.blithe.hospital.setting.service.impl;

import com.blithe.hospital.setting.dao.UserDao;
import com.blithe.hospital.setting.domain.User;
import com.blithe.hospital.setting.service.UserService;

import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.security.auth.login.LoginException;

/**
 * Author:  blithe.xwj
 * Date:    2022/6/21 16:48
 * Description:
 */

@Service
public class UserServiceImpl implements UserService {
    @Resource
    private UserDao dao;

    @Override
    public User login(String loginAct, String loginPwd, String ip) throws LoginException {
        User user = dao.login(loginAct,loginPwd);
        System.out.println("hahaha");
        if(user == null){
            throw new LoginException("账号密码错误！");
        }
        if("0".equals(user.getLockState())){
            throw new LoginException("账号已被锁定，请联系管理员解锁状态！");
        }
        if(!user.getAllowIps().contains(ip)){
            throw new LoginException("ip地址受限");
        }
        return user;
    }
}
