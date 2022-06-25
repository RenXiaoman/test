package com.blithe.hospital.workbench.service.impl;

import com.blithe.hospital.vo.PaginationVo;
import com.blithe.hospital.workbench.dao.DoctorDutyDao;
import com.blithe.hospital.workbench.domain.DoctorDuty;
import com.blithe.hospital.workbench.service.DoctorDutyService;
import com.github.pagehelper.PageHelper;

import org.springframework.stereotype.Service;

import java.util.List;

import javax.annotation.Resource;

/**
 * Author:  blithe.xwj
 * Date:    2022/6/24 18:25
 * Description:
 */

@Service
public class DoctorDutyServiceImpl implements DoctorDutyService {

    @Resource
    DoctorDutyDao doctorDutyDao;

    @Override
    public PaginationVo<DoctorDuty> pageList(Integer pageNo, Integer pageSize, DoctorDuty doctorDuty){
        PaginationVo<DoctorDuty> vo = new PaginationVo<>();
        vo.setTotal(doctorDutyDao.getTotal(doctorDuty));
        PageHelper.startPage(pageNo,pageSize);
        List<DoctorDuty> doctorDutyList = doctorDutyDao.getDutyListByCondition(doctorDuty);
        vo.setDataList(doctorDutyList);
        return vo;
    }
}
