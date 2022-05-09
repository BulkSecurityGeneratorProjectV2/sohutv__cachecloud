package com.sohu.cache.dao;

import com.sohu.cache.entity.AppAlertRecord;

import java.util.List;

/**
 * @Author: zengyizhao
 * @DateTime: 2021/9/3 13:38
 * @Description: ������¼
 */
public interface AppAlertRecordDao {

    /**
     * ���汨����Ϣ
     *
     * @param appAlertRecord
     * @return
     */
    public int save(AppAlertRecord appAlertRecord);

    /**
     * �������汨����Ϣ
     *
     * @param appAlertRecordList
     * @return
     */
    public int batchSave(List<AppAlertRecord> appAlertRecordList);

}
