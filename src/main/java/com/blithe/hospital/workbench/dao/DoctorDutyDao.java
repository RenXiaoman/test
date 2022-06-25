package com.blithe.hospital.workbench.dao;

import com.blithe.hospital.workbench.domain.DoctorDuty;

import java.util.List;

/**
 * Author:  blithe.xwj
 * Date:    2022/6/24 11:06
 * Description:
 */

public interface DoctorDutyDao {
    int getTotal(DoctorDuty doctorDuty);

    List<DoctorDuty> getDutyListByCondition(DoctorDuty doctorDuty);
}
