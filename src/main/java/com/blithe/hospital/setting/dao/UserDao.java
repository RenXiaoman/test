package com.blithe.hospital.setting.dao;

import com.blithe.hospital.setting.domain.User;

import org.apache.ibatis.annotations.Param;

/**
 * Author:  blithe.xwj
 * Date:    2022/6/21 10:36
 * Description:
 */

public interface UserDao {
    User login(@Param("loginAct") String loginAct,@Param("loginPwd") String loginPwd);
}
