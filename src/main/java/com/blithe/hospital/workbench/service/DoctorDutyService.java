package com.blithe.hospital.workbench.service;

import com.blithe.hospital.vo.PaginationVo;
import com.blithe.hospital.workbench.domain.DoctorDuty;

/**
 * Author:  blithe.xwj
 * Date:    2022/6/24 18:25
 * Description:
 */

public interface DoctorDutyService {

    PaginationVo<DoctorDuty> pageList(Integer pageNo, Integer pageSize, DoctorDuty doctorDuty);
}
