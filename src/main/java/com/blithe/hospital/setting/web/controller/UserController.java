package com.blithe.hospital.setting.web.controller;

import com.blithe.hospital.setting.domain.User;
import com.blithe.hospital.setting.service.UserService;
import com.blithe.hospital.utils.MD5Util;
import com.blithe.hospital.utils.PrintJson;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Author:  blithe.xwj
 * Date:    2022/6/21 17:00
 * Description:
 */

@Controller
@RequestMapping("settings/user")
public class UserController {

   @Resource
   private UserService userService;


   @RequestMapping("/login.do")
   public void login(String loginAct, String loginPwd, HttpServletRequest request, HttpServletResponse response){
      // 将前端的密码转换为md5加密之后的密文
      loginPwd = MD5Util.getMD5(loginPwd);
      // 接收ip地址
      String ip = request.getRemoteAddr();
      System.out.println("ip:" + ip);

      try{
         User user = userService.login(loginAct,loginPwd,ip);

         request.getSession().setAttribute("user",user);
         PrintJson.printJsonFlag(response,true);
      }catch (Exception e){
         e.printStackTrace();

         String msg =e.getMessage();

         Map<String,Object> map = new HashMap<>();
         map.put("success",false);
         map.put("msg",msg);
         PrintJson.printJsonObj(response,map);
      }
   }
}
