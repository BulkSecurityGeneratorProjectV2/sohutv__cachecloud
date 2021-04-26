package com.sohu.cache.client.service;

import com.sohu.cache.entity.AppClientVersion;

import java.util.List;
import java.util.Map;

/**
 * 客户端版本信息
 *
 * @author leifu
 * @Date 2015年2月2日
 * @Time 上午10:19:59
 */
public interface ClientVersionService {

    /**
     * 保存客户端版本信息
     *
     * @param appId
     * @param appClientIp
     * @param clientVersion
     */
    void saveOrUpdateClientVersion(long appId, String appClientIp, String clientVersion);

    /**
     * 获取应用的所有客户端版本信息
     *
     * @param appId
     * @return
     */
    List<AppClientVersion> getAppAllClientVersion(long appId);

    /**
     * 获取应用客户端最大版本
     *
     * @param appId
     * @return
     */
    public String getAppMaxClientVersion(long appId);

    /**
     * 获取应用所有客户端最大版本
     *
     * @return
     */
    public List<Map<String, Object>> getAllMaxClientVersion();

    /**
     * 获取所有客户端版本
     *
     * @return
     */
    List<AppClientVersion> getAll(long appId);

}
