package com.blithe.hospital.workbench.web.controller;

import com.blithe.hospital.vo.PaginationVo;
import com.blithe.hospital.workbench.domain.DoctorDuty;
import com.blithe.hospital.workbench.service.DoctorDutyService;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;

/**
 * Author:  blithe.xwj
 * Date:    2022/6/24 11:07
 * Description:
 */

@Controller
@RequestMapping("workbench/schedule")
public class DoctorDutyController {

    @Resource
    DoctorDutyService doctorDutyService;

    @RequestMapping("pageList.do")
    @ResponseBody
    public PaginationVo<DoctorDuty> getPageList(Integer pageNo, Integer pageSize, String project,
                                    String doctor, String techRoom) {
        DoctorDuty doctorDuty = new DoctorDuty();
        doctorDuty.setDoctorName(doctor);
        doctorDuty.setTechOfficeName(techRoom);
        doctorDuty.setMainClassName(project);
        PaginationVo<DoctorDuty> paginationVo = doctorDutyService.pageList(pageNo,pageSize,doctorDuty);
        return paginationVo;
    }
}
