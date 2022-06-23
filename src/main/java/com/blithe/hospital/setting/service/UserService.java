package com.blithe.hospital.setting.service;

import com.blithe.hospital.setting.domain.User;

import javax.security.auth.login.LoginException;

/**
 * Author:  blithe.xwj
 * Date:    2022/6/21 16:48
 * Description:
 */

public interface UserService {
    User login(String loginAct, String loginPwd, String ip) throws LoginException;
}
