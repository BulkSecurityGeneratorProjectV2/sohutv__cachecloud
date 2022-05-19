-- MySQL dump 10.15  Distrib 10.0.16-MariaDB, for Linux (x86_64)
--
-- Host: localhost    Database: cachecloud_open
-- ------------------------------------------------------
-- Server version	10.0.16-MariaDB-log

SET NAMES utf8;
SET FOREIGN_KEY_CHECKS = 0;

--
-- Table structure for table `app_audit`
--

DROP TABLE IF EXISTS `app_audit`;
CREATE TABLE `app_audit` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `app_id` bigint(20) NOT NULL COMMENT 'Ӧ��id',
  `user_id` bigint(20) NOT NULL COMMENT '�����˵�id',
  `user_name` varchar(64) NOT NULL COMMENT '�û���',
  `type` tinyint(4) NOT NULL COMMENT '��������:0:����Ӧ��,1:Ӧ������,2:�޸�����',
  `param1` varchar(600) DEFAULT NULL COMMENT 'Ԥ������1',
  `param2` varchar(600) DEFAULT NULL COMMENT 'Ԥ������2',
  `param3` varchar(600) DEFAULT NULL COMMENT 'Ԥ������3',
  `info` varchar(360) NOT NULL COMMENT '��������',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0:�ȴ�����; 1:����ͨ��; -1:����',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modify_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `refuse_reason` varchar(360) DEFAULT NULL COMMENT '��������',
  `task_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '����id',
  `operate_id` bigint(20) DEFAULT NULL COMMENT '����������',
  PRIMARY KEY (`id`),
  KEY `idx_appid` (`app_id`),
  KEY `idx_create_time` (`create_time`),
  KEY `idx_status_create_time` (`status`,`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Ӧ����˱�' /* `compression`='tokudb_zlib' */;

--
-- Table structure for table `app_audit_log`
--

DROP TABLE IF EXISTS `app_audit_log`;
CREATE TABLE `app_audit_log` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `app_id` bigint(20) NOT NULL COMMENT 'Ӧ��id',
  `user_id` bigint(20) NOT NULL COMMENT '����������id',
  `info` longtext NOT NULL COMMENT 'app��������ϸ��Ϣ',
  `type` tinyint(4) NOT NULL,
  `create_time` datetime NOT NULL,
  `app_audit_id` bigint(20) NOT NULL COMMENT '����id',
  PRIMARY KEY (`id`),
  KEY `idx_audit_appid` (`app_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='app�����־��' /* `compression`='tokudb_zlib' */;

--
-- Table structure for table `app_client_command_minute_statistics`
--

DROP TABLE IF EXISTS `app_client_command_minute_statistics`;
CREATE TABLE `app_client_command_minute_statistics` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `current_min` bigint(20) NOT NULL COMMENT 'ͳ��ʱ��',
  `client_ip` varchar(20) NOT NULL COMMENT '�ͻ���ip',
  `app_id` bigint(20) NOT NULL COMMENT 'Ӧ��id',
  `command` varchar(20) NOT NULL COMMENT '��������',
  `cost` bigint(20) DEFAULT NULL COMMENT '�����ۼƺ����ʱ',
  `bytes_in` bigint(20) DEFAULT NULL COMMENT '��������',
  `bytes_out` bigint(20) DEFAULT NULL COMMENT '�������',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '����ʱ��',
  `count` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx__appid_client_command_currentMin` (`app_id`,`client_ip`,`command`,`current_min`),
  KEY `idx_currentmin_appid_count_cost` (`current_min`,`app_id`,`count`,`cost`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='�ͻ���ÿ������������ϱ�����';

--
-- Table structure for table `app_client_exception_minute_statistics`
--

DROP TABLE IF EXISTS `app_client_exception_minute_statistics`;
CREATE TABLE `app_client_exception_minute_statistics` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `current_min` bigint(20) NOT NULL COMMENT 'ͳ��ʱ��',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '����ʱ��',
  `client_ip` varchar(20) NOT NULL COMMENT '�ͻ���ip',
  `type` tinyint(4) NOT NULL COMMENT '0:connect exception;1:command exception',
  `app_id` bigint(20) DEFAULT NULL COMMENT 'Ӧ��id',
  `node` varchar(30) NOT NULL COMMENT '�ڵ���Ϣhost:port',
  `count` bigint(20) DEFAULT NULL COMMENT '�ۼ�����ʧ�ܴ���',
  `cost` bigint(20) DEFAULT NULL COMMENT '�ۼ�����ʧ�ܺ����ʱ',
  `latency_commands` varchar(255) DEFAULT NULL COMMENT 'ͳ������topN id,���ŷָ�',
  `redis_pool_config` varchar(255) DEFAULT NULL COMMENT 'redis���ӳ�������Ϣ',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx__client_node_type_currentMin` (`client_ip`,`node`,`type`,`current_min`),
  KEY `idx_appid_current_min` (`app_id`,`current_min`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='�ͻ���ÿ�����쳣�ϱ�����';

--
-- Table structure for table `app_client_latency_command`
--

DROP TABLE IF EXISTS `app_client_latency_command`;
CREATE TABLE `app_client_latency_command` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `command` varchar(255) NOT NULL COMMENT '��������',
  `size` bigint(20) DEFAULT NULL COMMENT '��������',
  `args` varchar(255) DEFAULT NULL COMMENT '�ü����������',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '����ʱ��',
  `invoke_time` bigint(20) DEFAULT NULL COMMENT '�������ʱ���',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='�ͻ����쳣�����������';

--
-- Table structure for table `app_client_statistic_gather`
--

DROP TABLE IF EXISTS `app_client_statistic_gather`;
CREATE TABLE `app_client_statistic_gather` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '����ʱ��',
  `gather_time` varchar(20) NOT NULL COMMENT 'ͳ��ʱ�䣬��ʽyyyy-mm-dd',
  `app_id` bigint(20) NOT NULL COMMENT 'Ӧ��id',
  `cmd_count` bigint(20) DEFAULT '0' COMMENT '������ô���',
  `conn_exp_count` bigint(20) DEFAULT '0' COMMENT '�����쳣����',
  `avg_cmd_cost` double DEFAULT '0' COMMENT '�������ƽ����ʱ����λ����',
  `avg_cmd_exp_cost` double DEFAULT '0' COMMENT '���ʱƽ����ʱ����λ����',
  `avg_conn_exp_cost` double DEFAULT '0' COMMENT '�����쳣ƽ����ʱ����λ����',
  `cmd_exp_count` bigint(20) DEFAULT '0' COMMENT '���ʱ����',
  `instance_count` int(11) DEFAULT NULL COMMENT 'Ӧ��ʵ����',
  `avg_mem_frag_ratio` double DEFAULT NULL COMMENT 'ƽ����Ƭ��',
  `mem_used_ratio` double DEFAULT NULL COMMENT '�ڴ�ʹ����',
  `exception_count` bigint(20) DEFAULT '0' COMMENT '�쳣�����ɣ������ߣ�',
  `slow_log_count` bigint(20) DEFAULT '0' COMMENT '����ѯ����',
  `latency_count` bigint(20) DEFAULT '0' COMMENT '�ӳ��¼�����',
  `object_size` bigint(20) DEFAULT '0' COMMENT '�洢������',
  `used_memory` bigint(20) DEFAULT '0' COMMENT '�ڴ�ռ�� byte',
  `used_memory_rss` bigint(20) DEFAULT '0' COMMENT '�����ڴ�ռ�� byte',
  `max_cpu_sys` bigint(20) DEFAULT '0' COMMENT '����ϵͳ̬����(��λ:��)',
  `max_cpu_user` bigint(20) DEFAULT '0' COMMENT '�����û�̬����(��λ:��)',
  `connected_clients` bigint(20) DEFAULT '0' COMMENT 'Ӧ�ÿͻ���������',
  `topology_exam_result` tinyint(4) DEFAULT NULL COMMENT '������Ͻ����0��������1���쳣',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_appid_gathertime` (`app_id`,`gather_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='�ͻ����ϱ�����ȫ��ͳ��';

--
-- Table structure for table `app_client_value_minute_stat`
--

DROP TABLE IF EXISTS `app_client_value_minute_stat`;
CREATE TABLE `app_client_value_minute_stat` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `app_id` bigint(20) NOT NULL COMMENT 'Ӧ��appid',
  `collect_time` bigint(20) NOT NULL COMMENT '�����ռ�ʱ��yyyyMMddHHmm00',
  `update_time` datetime NOT NULL COMMENT '����ʱ��',
  `command` varchar(20) NOT NULL COMMENT 'ִ������',
  `distribute_type` tinyint(4) NOT NULL COMMENT 'ֵ�ֲ�',
  `count` int(11) NOT NULL COMMENT '����ִ�д���',
  PRIMARY KEY (`id`),
  UNIQUE KEY `app_collect_command_dis` (`app_id`,`collect_time`,`command`,`distribute_type`),
  KEY `idx_collect_time` (`collect_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='�ͻ���ÿ����ֵ�ֲ��ϱ�����ͳ��';

--
-- Table structure for table `app_client_version_statistic`
--

DROP TABLE IF EXISTS `app_client_version_statistic`;
CREATE TABLE `app_client_version_statistic` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `app_id` bigint(20) NOT NULL COMMENT 'Ӧ��id',
  `client_ip` varchar(20) NOT NULL COMMENT '�ͻ���ip��ַ',
  `client_version` varchar(20) NOT NULL COMMENT '�ͻ��˰汾',
  `report_time` datetime DEFAULT NULL COMMENT '�ϱ�ʱ��',
  PRIMARY KEY (`id`),
  UNIQUE KEY `app_client_ip` (`app_id`,`client_ip`),
  KEY `app_id` (`app_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='�ͻ����ϱ��汾��Ϣͳ��' /* `compression`='tokudb_zlib' */;

--
-- Table structure for table `app_daily`
--

DROP TABLE IF EXISTS `app_daily`;
CREATE TABLE `app_daily` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '����id',
  `app_id` bigint(20) NOT NULL COMMENT 'Ӧ��id',
  `date` date NOT NULL COMMENT '����',
  `create_time` datetime NOT NULL,
  `slow_log_count` bigint(20) NOT NULL COMMENT '����ѯ����',
  `client_exception_count` bigint(20) NOT NULL COMMENT '�ͻ����쳣����',
  `max_minute_client_count` bigint(20) NOT NULL COMMENT 'ÿ�������ͻ���������',
  `avg_minute_client_count` bigint(20) NOT NULL COMMENT 'ÿ����ƽ���ͻ���������',
  `max_minute_command_count` bigint(20) NOT NULL COMMENT 'ÿ�������������',
  `avg_minute_command_count` bigint(20) NOT NULL COMMENT 'ÿ����ƽ��������',
  `avg_hit_ratio` double NOT NULL COMMENT 'ƽ��������',
  `min_minute_hit_ratio` double NOT NULL COMMENT 'ÿ������С������',
  `max_minute_hit_ratio` double NOT NULL COMMENT 'ÿ�������������',
  `avg_used_memory` bigint(20) NOT NULL COMMENT '����ڴ�ʹ����',
  `max_used_memory` bigint(20) NOT NULL COMMENT 'ƽ���ڴ�ʹ����',
  `expired_keys_count` bigint(20) NOT NULL COMMENT '���ڼ�����',
  `evicted_keys_count` bigint(20) NOT NULL COMMENT '�޳�������',
  `avg_minute_net_input_byte` double NOT NULL COMMENT 'ÿ����ƽ������input��',
  `max_minute_net_input_byte` double NOT NULL COMMENT 'ÿ�����������input��',
  `avg_minute_net_output_byte` double NOT NULL COMMENT 'ÿ����ƽ������output��',
  `max_minute_net_output_byte` double NOT NULL COMMENT 'ÿ�����������output��',
  `avg_object_size` bigint(20) NOT NULL COMMENT '������ƽ��ֵ',
  `max_object_size` bigint(20) NOT NULL COMMENT '���������ֵ',
  `big_key_times` bigint(20) NOT NULL COMMENT 'bigkey����',
  `big_key_info` varchar(512) COLLATE utf8_bin NOT NULL COMMENT 'bigkey����',
  `client_cmd_count` bigint(20) NOT NULL COMMENT '�ۼ�������ô���',
  `client_avg_cmd_cost` double NOT NULL COMMENT 'ƽ��������ú�ʱ',
  `client_conn_exp_count` bigint(20) NOT NULL COMMENT '�ۼ������쳣�¼�����',
  `client_avg_conn_exp_cost` double NOT NULL COMMENT 'ƽ�������쳣�¼���ʱ',
  `client_cmd_exp_count` bigint(20) NOT NULL COMMENT '�ۼ����ʱ�¼�����',
  `client_avg_cmd_exp_cost` double NOT NULL COMMENT 'ƽ�����ʱ�¼���ʱ',
  PRIMARY KEY (`id`),
  KEY `idx_appid_date` (`app_id`,`date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='app�ձ�';

--
-- Table structure for table `app_data_migrate_status`
--

DROP TABLE IF EXISTS `app_data_migrate_status`;
CREATE TABLE `app_data_migrate_status` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '����id',
  `migrate_machine_ip` varchar(255) NOT NULL COMMENT 'Ǩ�ƹ������ڻ���ip',
  `migrate_machine_port` int(11) NOT NULL COMMENT 'Ǩ�ƹ�����ռport',
  `source_migrate_type` tinyint(4) NOT NULL COMMENT 'ԴǨ������,0:single,1:redis cluster,2:rdb file,3:twemproxy',
  `source_servers` varchar(2048) NOT NULL COMMENT 'Դʵ���б�',
  `target_migrate_type` tinyint(4) NOT NULL COMMENT 'Ŀ��Ǩ������,0:single,1:redis cluster,2:rdb file,3:twemproxy',
  `target_servers` varchar(2048) NOT NULL COMMENT 'Ŀ��ʵ���б�',
  `source_app_id` bigint(20) NOT NULL DEFAULT '0' COMMENT 'ԴӦ��id',
  `target_app_id` bigint(20) NOT NULL DEFAULT '0' COMMENT 'Ŀ��Ӧ��id',
  `user_id` bigint(20) NOT NULL COMMENT '������',
  `status` tinyint(4) NOT NULL COMMENT 'Ǩ��ִ��״̬,0:��ʼ,1:����,2:�쳣',
  `start_time` datetime NOT NULL COMMENT 'Ǩ�ƿ�ʼִ��ʱ��',
  `end_time` datetime DEFAULT NULL COMMENT 'Ǩ�ƽ���ִ��ʱ��',
  `log_path` varchar(255) NOT NULL COMMENT '��־�ļ�·��',
  `config_path` varchar(255) NOT NULL COMMENT '�����ļ�·��',
  `migrate_id` varchar(50) DEFAULT NULL COMMENT 'migrate id',
  `migrate_tool` tinyint(4) DEFAULT NULL COMMENT 'migrate_tool, 0:redis-shake,1:redis-migrate-tool',
  `redis_source_version` varchar(20) DEFAULT NULL,
  `redis_target_version` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Ӧ��Ǩ�Ƽ�¼����';

--
-- Table structure for table `app_desc`
--

DROP TABLE IF EXISTS `app_desc`;
CREATE TABLE `app_desc` (
  `app_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'Ӧ��id',
  `name` varchar(36) NOT NULL COMMENT 'Ӧ����',
  `user_id` bigint(20) NOT NULL COMMENT '������id',
  `status` tinyint(4) NOT NULL COMMENT 'Ӧ��״̬, 0δ���䣬1����δ������2���������� 3:Ӧ������',
  `intro` varchar(255) NOT NULL COMMENT 'Ӧ������',
  `create_time` datetime NOT NULL COMMENT '����ʱ��',
  `passed_time` datetime NOT NULL COMMENT '����ͨ��ʱ��',
  `type` int(10) NOT NULL DEFAULT '0' COMMENT 'cache���ͣ�1. memcached, 2. redis-cluster, 3. memcacheq, 4. ��cache-cloud ,5. redis-sentinel ,6.redis-standalone ',
  `officer` varchar(32) NOT NULL COMMENT '�����ˣ�����',
  `ver_id` int(11) NOT NULL COMMENT '�汾',
  `is_test` tinyint(4) DEFAULT '0' COMMENT '�Ƿ���ԣ�1��0��',
  `need_persistence` tinyint(4) DEFAULT '1' COMMENT '�Ƿ���Ҫ�־û�: 1��0��',
  `need_hot_back_up` tinyint(4) DEFAULT '1' COMMENT '�Ƿ���Ҫ�ȱ�: 1��0��',
  `has_back_store` tinyint(4) DEFAULT '1' COMMENT '�Ƿ��к������Դ: 1��0��',
  `forecase_qps` int(11) DEFAULT NULL COMMENT 'Ԥ��qps',
  `forecast_obj_num` int(11) DEFAULT NULL COMMENT 'Ԥ����Ŀ��',
  `mem_alert_value` int(11) DEFAULT NULL COMMENT '�ڴ汨����ֵ',
  `client_machine_room` varchar(36) DEFAULT NULL COMMENT '�ͻ��˻�����Ϣ',
  `client_conn_alert_value` int(11) DEFAULT '2000' COMMENT '�ͻ������ӱ�����ֵ',
  `app_key` varchar(255) DEFAULT NULL COMMENT 'Ӧ����Կ',
  `important_level` tinyint(4) NOT NULL DEFAULT '2' COMMENT 'Ӧ�ü���1:����Ҫ��2:һ����Ҫ��3:һ��',
  `password` varchar(255) DEFAULT '' COMMENT 'redis����',
  `hit_precent_alert_value` int(11) DEFAULT '0' COMMENT '�����ʱ�����ֵ 0:������ ',
  `is_access_monitor` int(11) DEFAULT '0' COMMENT '�Ƿ����ȫ�ּ�ر��� Ĭ��0,0:�������� 1:������',
  `app_fsync_value` int(11) DEFAULT '1' COMMENT 'Ӧ��ˢ�̲��� 1:���ӽڵ�appdendfsync=everysec 2:���ӽڵ� appdendfsync=no',
  `version_id` int(11) NOT NULL DEFAULT '1' COMMENT 'Redis�汾������id',
  PRIMARY KEY (`app_id`),
  UNIQUE KEY `uidx_app_name` (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='appӦ������' /* `compression`='tokudb_zlib' */;

--
-- Table structure for table `app_hour_command_statistics`
--

DROP TABLE IF EXISTS `app_hour_command_statistics`;
CREATE TABLE `app_hour_command_statistics` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `app_id` bigint(20) NOT NULL COMMENT 'Ӧ��id',
  `collect_time` bigint(20) NOT NULL COMMENT 'ͳ��ʱ��:��ʽyyyyMMddHH',
  `command_name` varchar(60) NOT NULL COMMENT '��������',
  `command_count` bigint(20) NOT NULL COMMENT '����ִ�д���',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '����ʱ��',
  `modify_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '�޸�ʱ��',
  PRIMARY KEY (`id`),
  UNIQUE KEY `app_id` (`app_id`,`command_name`,`collect_time`),
  KEY `idx_create_time` (`create_time`),
  KEY `idx_modify_time` (`modify_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Ӧ�õ�ÿСʱ����ͳ��' /* `compression`='tokudb_zlib' */;

--
-- Table structure for table `app_hour_statistics`
--

DROP TABLE IF EXISTS `app_hour_statistics`;
CREATE TABLE `app_hour_statistics` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `app_id` bigint(20) NOT NULL COMMENT 'Ӧ��id',
  `collect_time` bigint(20) NOT NULL COMMENT '�ռ�ʱ��:��ʽyyyyMMddHH',
  `hits` bigint(20) NOT NULL COMMENT 'ÿСʱ����������',
  `misses` bigint(20) NOT NULL COMMENT 'ÿСʱδ����������',
  `command_count` bigint(20) DEFAULT '0' COMMENT '��������',
  `used_memory` bigint(20) NOT NULL COMMENT 'ÿСʱ�ڴ�ռ�����ֵ',
  `used_memory_rss` bigint(20) NOT NULL DEFAULT '0' COMMENT '�����ڴ�ռ��',
  `expired_keys` bigint(20) NOT NULL COMMENT 'ÿСʱ����key������',
  `evicted_keys` bigint(20) NOT NULL COMMENT 'ÿСʱ����key������',
  `net_input_byte` bigint(20) DEFAULT '0' COMMENT '���������ֽ�',
  `net_output_byte` bigint(20) DEFAULT '0' COMMENT '��������ֽ�',
  `connected_clients` int(10) NOT NULL COMMENT 'ÿСʱ�ͻ������������ֵ',
  `object_size` bigint(20) NOT NULL COMMENT 'ÿСʱ�洢���������ֵ',
  `cpu_sys` bigint(20) DEFAULT '0' COMMENT '����ϵͳ̬����',
  `cpu_user` bigint(20) DEFAULT '0' COMMENT '�����û�̬����',
  `cpu_sys_children` bigint(20) DEFAULT '0' COMMENT '�ӽ���ϵͳ̬����',
  `cpu_user_children` bigint(20) DEFAULT '0' COMMENT '�ӽ����û�̬����',
  `accumulation` int(10) NOT NULL DEFAULT '0' COMMENT 'ÿСʱ�����ۼ�ʵ������Сֵ',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '����ʱ��',
  `modify_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'ÿСʱ�޸�ʱ�����ֵ',
  PRIMARY KEY (`id`),
  UNIQUE KEY `app_id` (`app_id`,`collect_time`),
  KEY `idx_create_time` (`create_time`) USING BTREE,
  KEY `idx_modify_time` (`modify_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Ӧ��ͳ������ÿСʱͳ��' /* `compression`='tokudb_zlib' */;

--
-- Table structure for table `app_minute_command_statistics`
--

DROP TABLE IF EXISTS `app_minute_command_statistics`;
CREATE TABLE `app_minute_command_statistics` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `app_id` bigint(20) NOT NULL COMMENT 'Ӧ��id',
  `collect_time` bigint(20) NOT NULL COMMENT 'ͳ��ʱ��:��ʽyyyyMMddHHmm',
  `command_name` varchar(60) NOT NULL COMMENT '��������',
  `command_count` bigint(20) NOT NULL COMMENT '����ִ�д���',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '����ʱ��',
  `modify_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '�޸�ʱ��',
  PRIMARY KEY (`id`),
  UNIQUE KEY `app_id` (`app_id`,`collect_time`,`command_name`),
  KEY `idx_create_time` (`create_time`),
  KEY `idx_modify_time` (`modify_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Ӧ�õ�ÿ��������ͳ��' /* `compression`='tokudb_zlib' */;

--
-- Table structure for table `app_minute_statistics`
--

DROP TABLE IF EXISTS `app_minute_statistics`;
CREATE TABLE `app_minute_statistics` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `app_id` bigint(20) NOT NULL COMMENT 'Ӧ��id',
  `collect_time` bigint(20) NOT NULL COMMENT '�ռ�ʱ��:��ʽyyyyMMddHHmm',
  `hits` bigint(20) NOT NULL COMMENT '��������',
  `misses` bigint(20) NOT NULL COMMENT 'δ��������',
  `command_count` bigint(20) DEFAULT '0' COMMENT '��������',
  `used_memory` bigint(20) NOT NULL COMMENT '�ڴ�ռ��',
  `used_memory_rss` bigint(20) NOT NULL DEFAULT '0' COMMENT '�����ڴ�ռ��',
  `expired_keys` bigint(20) NOT NULL COMMENT '����key����',
  `evicted_keys` bigint(20) NOT NULL COMMENT '����key����',
  `net_input_byte` bigint(20) DEFAULT '0' COMMENT '���������ֽ�',
  `net_output_byte` bigint(20) DEFAULT '0' COMMENT '��������ֽ�',
  `connected_clients` int(10) NOT NULL COMMENT '�ͻ���������',
  `object_size` bigint(20) NOT NULL COMMENT 'ÿ���Ӵ洢���������ֵ',
  `cpu_sys` bigint(20) DEFAULT '0' COMMENT '����ϵͳ̬����',
  `cpu_user` bigint(20) DEFAULT '0' COMMENT '�����û�̬����',
  `cpu_sys_children` bigint(20) DEFAULT '0' COMMENT '�ӽ���ϵͳ̬����',
  `cpu_user_children` bigint(20) DEFAULT '0' COMMENT '�ӽ����û�̬����',
  `accumulation` int(10) NOT NULL DEFAULT '0' COMMENT '�����ۼ�ʵ����',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '����ʱ��',
  `modify_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '�޸�ʱ��',
  PRIMARY KEY (`id`),
  UNIQUE KEY `app_id` (`app_id`,`collect_time`),
  KEY `idx_create_time` (`create_time`) USING BTREE,
  KEY `idx_modify_time` (`modify_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

--
-- Table structure for table `app_to_user`
--

DROP TABLE IF EXISTS `app_to_user`;
CREATE TABLE `app_to_user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL COMMENT '�û�id',
  `app_id` bigint(20) NOT NULL COMMENT 'Ӧ��id',
  PRIMARY KEY (`id`),
  KEY `app_id` (`app_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin /* `compression`='tokudb_zlib' */;

--
-- Table structure for table `app_user`
--

DROP TABLE IF EXISTS `app_user`;
CREATE TABLE `app_user` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL COMMENT '�û���',
  `ch_name` varchar(255) NOT NULL COMMENT '������',
  `email` varchar(64) NOT NULL COMMENT '����',
  `mobile` varchar(16) NOT NULL COMMENT '�ֻ�',
  `type` int(4) NOT NULL DEFAULT '2' COMMENT '0����Ա��1Ԥ����2��ͨ�û���-1��Ч',
  `weChat` varchar(32) DEFAULT NULL COMMENT '΢�ź�',
  `isAlert` tinyint(4) NOT NULL DEFAULT '1' COMMENT '�û��Ƿ���ձ��� 0:������ 1:����',
  `password` varchar(64) DEFAULT NULL COMMENT '����',
  `register_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'ע��ʱ��',
  `purpose` varchar(255) DEFAULT NULL COMMENT 'ʹ��Ŀ��',
  `company` varchar(255) DEFAULT NULL COMMENT '��˾����',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uidx_user_name` (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='�û���' /* `compression`='tokudb_zlib' */;

-- ----------------------------
--  Records of `app_user`
-- ----------------------------
BEGIN;
INSERT INTO `app_user` VALUES ('1', 'admin', 'admin', 'admin@xxx.com', '13500000000', '0', null, '1', NULL, current_timestamp(), NULL, NULL);
COMMIT;

--
-- Table structure for table `brevity_schedule_resources`
--

DROP TABLE IF EXISTS `brevity_schedule_resources`;
CREATE TABLE `brevity_schedule_resources` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `type` tinyint(4) NOT NULL COMMENT '����,��:BrevityScheduleType',
  `version` bigint(20) NOT NULL DEFAULT '0' COMMENT 'ʱ��汾',
  `host` varchar(16) NOT NULL COMMENT '��Դip',
  `port` int(11) NOT NULL DEFAULT '0' COMMENT '�˿�',
  `create_time` datetime NOT NULL COMMENT '����ʱ��',
  PRIMARY KEY (`id`),
  KEY `idx_type_host_port` (`type`,`host`,`port`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='��Ƶ�����';

--
-- Table structure for table `diagnostic_task_record`
--

DROP TABLE IF EXISTS `diagnostic_task_record`;
CREATE TABLE `diagnostic_task_record` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `app_id` bigint(20) DEFAULT NULL COMMENT 'Ӧ��id',
  `type` int(11) DEFAULT NULL COMMENT '������ͣ�0scan 1bigkey 2idle key 3hotkey 4del key 5slot analysis 6topology exam',
  `task_id` bigint(20) DEFAULT NULL COMMENT '������id',
  `audit_id` bigint(20) DEFAULT NULL COMMENT '����id',
  `status` int(11) DEFAULT NULL COMMENT '���״̬��0��ʼ 1���� 2�쳣',
  `cost` bigint(20) DEFAULT NULL COMMENT '��ʱ������',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `modify_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `redis_key` varchar(100) DEFAULT NULL COMMENT '�����key',
  `node` varchar(100) DEFAULT NULL COMMENT 'ʵ����host:port',
  `parent_task_id` bigint(20) DEFAULT NULL COMMENT '������id',
  `diagnostic_condition` varchar(100) DEFAULT NULL COMMENT '�������',
  `param1` varchar(100) DEFAULT NULL COMMENT '���ò���1',
  `param2` varchar(100) DEFAULT NULL COMMENT '���ò���2',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Ӧ����ϼ�¼';

--
-- Table structure for table `instance_alert_configs`
--

DROP TABLE IF EXISTS `instance_alert_configs`;
CREATE TABLE `instance_alert_configs` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '����id',
  `alert_config` varchar(255) NOT NULL COMMENT '��������',
  `alert_value` varchar(512) NOT NULL COMMENT '������ֵ',
  `config_info` varchar(255) NOT NULL COMMENT '����˵��',
  `type` tinyint(4) NOT NULL COMMENT '1:ȫ�ֱ���,2:ʵ������',
  `instance_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '0:ȫ�����ã���������ʵ��id',
  `status` tinyint(4) NOT NULL COMMENT '1:����,0:������',
  `compare_type` tinyint(4) NOT NULL COMMENT '�Ƚ����ͣ�1С��,2����,3����,4������',
  `check_cycle` tinyint(4) NOT NULL COMMENT '1:һ����,2:�����,3:��Сʱ4:һ��Сʱ,5:һ��',
  `update_time` datetime NOT NULL COMMENT '�������ø���ʱ��',
  `last_check_time` datetime NOT NULL COMMENT '�ϴμ��ʱ��',
  `important_level` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '��Ҫ�̶ȣ�0��һ�㣻1����Ҫ��2��������',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_index` (`type`,`instance_id`,`alert_config`,`compare_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='ʵ��������ֵ����';

-- ----------------------------
--  Records of `instance_alert_configs`
-- ----------------------------
BEGIN;
INSERT INTO `instance_alert_configs` VALUES ('9', 'aof_current_size', '6000', 'aof��ǰ�ߴ�(��λ��MB)', '1', '0', '1', '3', '3', '2017-06-19 09:43:22', '2020-09-17 10:52:00', 0), ('10', 'aof_delayed_fsync', '3', '����aof��������', '1', '0', '1', '3', '1', '2017-06-19 10:38:19', '2020-09-17 11:09:00', 1), ('11', 'client_biggest_input_buf', '10', '���뻺�������buffer��С(��λ��MB)', '1', '0', '1', '3', '1', '2017-06-19 10:47:03', '2020-09-17 11:09:00', 1), ('12', 'client_longest_output_list', '50000', '��������������г���', '1', '0', '1', '3', '1', '2017-06-19 10:55:45', '2020-09-17 11:09:00', 1), ('13', 'instantaneous_ops_per_sec', '60000', 'ʵʱops', '1', '0', '1', '3', '1', '2017-06-19 11:02:38', '2020-09-17 11:09:00', 1),('14', 'latest_fork_usec', '400000', '�ϴ�fork����ʱ��(��λ��΢��)', '1', '0', '1', '3', '5', '2017-06-19 11:21:35', '2020-09-16 16:51:00', 1), ('15', 'mem_fragmentation_ratio', '1.5', '�ڴ���Ƭ��(������500MB)', '1', '0', '1', '3', '5', '2017-06-19 12:49:16', '2020-09-16 16:51:00', 0), ('16', 'rdb_last_bgsave_status', 'ok', '��һ��bgsave״̬', '1', '0', '1', '4', '4', '2017-06-19 14:15:21', '2020-09-17 10:19:00', 0), ('17', 'total_net_output_bytes', '5000', '���������������(��λ��MB)', '1', '0', '1', '3', '1', '2017-06-19 16:39:44', '2020-09-17 11:09:00', 0), ('19', 'total_net_input_bytes', '1200', '����������������(��λ��MB)', '1', '0', '1', '3', '1', '2017-06-19 16:45:44', '2020-09-17 11:09:00', 0), ('20', 'sync_partial_err', '0', '���Ӳ��ָ���ʧ�ܴ���', '1', '0', '1', '3', '1', '2017-06-19 18:34:41', '2020-09-17 11:09:00', 1), ('21', 'sync_partial_ok', '0', '���Ӳ��ָ��Ƴɹ�����', '1', '0', '1', '3', '1', '2017-06-19 18:35:01', '2020-09-17 11:09:00', 1), ('22', 'sync_full', '0', '����ȫ������ִ�д���', '1', '0', '1', '3', '1', '2017-06-19 18:35:17', '2020-09-17 11:09:00', 1), ('23', 'rejected_connections', '0', '���Ӿܾ�������', '1', '0', '1', '3', '1', '2017-06-19 18:35:36', '2020-09-17 11:09:00', 2), ('54', 'master_slave_offset_diff', '20000000', '���ӽڵ�ƫ������(��λ���ֽ�)', '1', '0', '1', '3', '2', '2017-06-20 18:58:56', '2020-09-17 11:06:00', 0), ('56', 'cluster_state', 'ok', '��Ⱥ״̬', '1', '0', '1', '4', '1', '2017-06-21 18:01:52', '2020-09-17 11:09:00', 2), ('57', 'cluster_slots_ok', '16384', '��Ⱥ�ɹ�����۸���', '1', '0', '1', '4', '1', '2017-06-21 18:02:04', '2020-09-17 11:09:00', 2);
COMMIT;

--
-- Table structure for table `instance_big_key`
--

DROP TABLE IF EXISTS `instance_big_key`;
CREATE TABLE `instance_big_key` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `instance_id` bigint(20) NOT NULL COMMENT 'ʵ����id',
  `app_id` bigint(20) NOT NULL COMMENT 'app id',
  `audit_id` bigint(20) NOT NULL COMMENT 'audit id',
  `role` tinyint(255) NOT NULL COMMENT '���ӣ�1��2�ӣ����InstanceRoleEnum',
  `ip` varchar(32) NOT NULL COMMENT 'ip',
  `port` int(11) NOT NULL COMMENT 'port',
  `big_key` varchar(255) NOT NULL COMMENT '��',
  `type` varchar(16) NOT NULL COMMENT '����:string,hash,list,set,zset',
  `length` int(11) NOT NULL COMMENT '����',
  `create_time` datetime NOT NULL COMMENT '��¼����ʱ��',
  PRIMARY KEY (`id`),
  KEY `idx_app_audit` (`app_id`,`audit_id`),
  KEY `idx_app_create_time` (`app_id`,`create_time`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='ʵ��bigkey�б�';

--
-- Table structure for table `instance_config`
--

DROP TABLE IF EXISTS `instance_config`;
CREATE TABLE `instance_config` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `config_key` varchar(128) NOT NULL COMMENT '������',
  `config_value` varchar(512) NOT NULL COMMENT '����ֵ',
  `info` varchar(512) NOT NULL COMMENT '����˵��',
  `update_time` datetime NOT NULL COMMENT '����ʱ��',
  `type` mediumint(9) NOT NULL COMMENT '���ͣ�2.cluster�ڵ���������, 5:sentinel�ڵ�����, 6:redis��ͨ�ڵ�',
  `status` tinyint(4) NOT NULL COMMENT '1��Ч,0��Ч',
  `version_id` int(11) NOT NULL COMMENT 'Redis�汾������id',
  `refresh` mediumint(9) DEFAULT '0' COMMENT '�Ƿ�����ã�0���ɣ�1������',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_configkey_type_version_id` (`config_key`,`type`,`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='ʵ������ģ��';

-- ----------------------------
--  Records of `instance_config`
-- ----------------------------
BEGIN;
INSERT INTO `instance_config` VALUES ('1', 'cluster-enabled', 'yes', '�Ƿ�����Ⱥģʽ', '2016-07-05 15:08:30', '2', '1', '29', '0'), ('2', 'cluster-node-timeout', '15000', '��Ⱥ�ڵ㳬ʱʱ��,Ĭ��15��', '2016-07-05 15:08:30', '2', '1', '29', '0'), ('3', 'cluster-slave-validity-factor', '10', '�ӽڵ��ӳ���Ч���ж�����,Ĭ��10��', '2016-07-05 15:08:30', '2', '1', '29', '0'), ('4', 'cluster-migration-barrier', '1', '����Ǩ��������Ҫ�Ĵӽڵ���,Ĭ��1��', '2016-07-05 15:08:30', '2', '1', '29', '0'), ('5', 'cluster-config-file', 'nodes-%d.conf', '��Ⱥ�����ļ�����,��ʽ:nodes-{port}.conf', '2016-07-05 15:08:30', '2', '1', '29', '0'), ('6', 'cluster-require-full-coverage', 'no', '�ڵ㲿��ʧ���ڼ�,�����ڵ��Ƿ��������', '2016-07-05 15:08:31', '2', '1', '29', '0'), ('7', 'port', '%d', 'sentinelʵ���˿�', '2016-07-05 15:08:31', '5', '1', '29', '0'), ('8', 'dir', '%s', '����Ŀ¼', '2016-07-05 15:08:31', '5', '1', '29', '0'), ('9', 'sentinel monitor', '%s %s %d 1', 'master���ƶ�������ٲ����ص�sentinel��,��ʽ:masterName ip port num', '2016-07-05 15:08:31', '5', '1', '29', '0'), ('10', 'sentinel down-after-milliseconds', '%s 20000', 'Sentinel�ж����������ߵĺ�����', '2016-07-05 15:08:31', '5', '1', '29', '0'), ('11', 'sentinel failover-timeout', '%s 180000', '����Ǩ�Ƴ�ʱʱ��,Ĭ��:3����', '2016-07-05 15:08:31', '5', '1', '29', '0'), ('12', 'sentinel parallel-syncs', '%s 1', '��ִ�й���ת��ʱ,����ж��ٸ��ӷ�����ͬʱ���µ�������������ͬ��,Ĭ��:1', '2016-07-05 15:08:31', '5', '1', '29', '0'), ('13', 'daemonize', 'no', '�Ƿ��ػ�����', '2016-07-14 14:00:05', '6', '1', '29', '0'), ('14', 'tcp-backlog', '511', 'TCP������ɶ���', '2016-07-05 15:08:31', '6', '1', '29', '0'), ('15', 'timeout', '0', '�ͻ������ö������ر�����,Ĭ��Ϊ0,�����ر�', '2016-07-05 15:08:31', '6', '1', '29', '0'), ('16', 'tcp-keepalive', '60', '���ͻ����Ƿ񽡿�����,Ĭ�Ϲر�', '2016-12-06 11:40:46', '6', '1', '29', '0'), ('17', 'loglevel', 'notice', '��־����', '2016-07-05 15:08:31', '6', '1', '29', '0'), ('18', 'databases', '16', '���õ����ݿ�����Ĭ��ֵΪ16��,Ĭ�����ݿ�Ϊ0', '2016-07-05 15:08:31', '6', '1', '29', '0'), ('19', 'dir', '%s', 'redis����Ŀ¼', '2016-07-05 15:08:31', '6', '1', '29', '0'), ('20', 'stop-writes-on-bgsave-error', 'no', 'bgsave�����˲�ͣд', '2016-07-05 15:08:31', '6', '1', '29', '0'), ('21', 'repl-timeout', '60', 'master�������ݴ���ʱ�����ping�ظ�ʱ����,Ĭ��:60��', '2016-07-05 15:08:31', '6', '1', '29', '0'), ('22', 'repl-ping-slave-period', '10', 'ָ��slave����ping master������,Ĭ��:10��', '2016-07-05 15:08:31', '6', '1', '29', '0'), ('23', 'repl-disable-tcp-nodelay', 'no', '�Ƿ����socket��NO_DELAY,Ĭ�Ϲرգ�Ӱ�������ӳ�', '2016-07-05 15:08:31', '6', '1', '29', '0'), ('24', 'repl-backlog-size', '10M', '���ƻ�����,Ĭ��:1mb,����Ϊ:10Mb', '2016-07-05 15:08:31', '6', '1', '29', '0'), ('25', 'repl-backlog-ttl', '7200', 'master��û��Slave��������ͷ�BACKLOG��ʱ����:Ĭ��:3600,����Ϊ:7200', '2016-07-05 15:08:31', '6', '1', '29', '0'), ('26', 'slave-serve-stale-data', 'yes', '��slave��������master������ʧȥ���Ӻ󣬻��ߵ��������ڸ��ƴ����ʱ������˲���ֵ���á�yes����slave���������Լ������ܿͻ��˵�����', '2016-07-05 15:08:31', '6', '1', '29', '0'), ('27', 'slave-read-only', 'yes', 'slave�������ڵ��Ƿ�ֻ��,cluster��slave�ڵ�Ĭ�϶�д��������,��Ҫ����readonly�����ɶ�ģʽ', '2016-07-05 15:08:31', '6', '1', '29', '0'), ('28', 'slave-priority', '100', 'slave�����ȼ�,Ӱ��sentinel/cluster����master����,0��Զ������', '2016-07-05 15:08:31', '6', '1', '29', '0'), ('29', 'lua-time-limit', '5000', 'Lua�ű����ִ��ʱ�䣬��λΪ����', '2016-07-05 15:08:31', '6', '1', '29', '0'), ('30', 'slowlog-log-slower-than', '10000', '����ѯ����¼�ķ�ֵ,Ĭ��10����', '2016-07-05 15:08:31', '6', '1', '29', '0'), ('31', 'slowlog-max-len', '128', '����¼����ѯ������', '2016-07-05 15:08:31', '6', '1', '29', '0'), ('32', 'hash-max-ziplist-entries', '512', 'hash���ݽṹ�Ż�����', '2016-07-05 15:08:31', '6', '1', '29', '0'), ('33', 'hash-max-ziplist-value', '64', 'hash���ݽṹ�Ż�����', '2016-07-05 15:08:31', '6', '1', '29', '0'), ('34', 'list-max-ziplist-entries', '512', 'list���ݽṹ�Ż�����', '2016-07-05 15:08:31', '6', '1', '29', '0'), ('35', 'list-max-ziplist-value', '64', 'list���ݽṹ�Ż�����', '2016-07-05 15:08:31', '6', '1', '29', '0'), ('36', 'set-max-intset-entries', '512', 'set���ݽṹ�Ż�����', '2016-07-05 15:08:31', '6', '1', '29', '0'), ('37', 'zset-max-ziplist-entries', '128', 'zset���ݽṹ�Ż�����', '2016-07-05 15:08:31', '6', '1', '29', '0'), ('38', 'zset-max-ziplist-value', '64', 'zset���ݽṹ�Ż�����', '2016-07-05 15:08:31', '6', '1', '29', '0'), ('39', 'activerehashing', 'yes', '�Ƿ񼤻����ù�ϣ,Ĭ��:yes', '2016-07-05 15:08:31', '6', '1', '29', '0'), ('40', 'client-output-buffer-limit normal', '0 0 0', '�ͻ����������������(�ͻ���)', '2016-07-05 15:08:31', '6', '1', '29', '0'), ('41', 'client-output-buffer-limit slave', '512mb 256mb 60', '�ͻ����������������(����)', '2016-11-24 10:24:21', '6', '1', '29', '0'), ('42', 'client-output-buffer-limit pubsub', '32mb 8mb 60', '�ͻ����������������(��������)', '2016-07-05 15:08:31', '6', '1', '29', '0'), ('43', 'hz', '10', 'ִ�к�̨task����,Ĭ��:10', '2016-07-05 15:08:31', '6', '1', '29', '0'), ('44', 'port', '%d', '�˿�', '2016-07-05 15:08:31', '6', '1', '29', '0'), ('45', 'maxmemory', '%dmb', '��ǰʵ���������ڴ�', '2016-07-05 15:08:31', '6', '1', '29', '0'), ('46', 'maxmemory-policy', 'volatile-lru', '�ڴ治��ʱ,��̭����,Ĭ��:volatile-lru', '2016-07-05 15:08:31', '6', '1', '29', '0'), ('47', 'appendonly', 'yes', '����append only�־û�ģʽ', '2016-07-05 15:08:32', '6', '1', '29', '0'), ('48', 'appendfsync', 'everysec', 'Ĭ��:aofÿ��ͬ��һ��', '2016-07-05 15:08:32', '6', '1', '29', '0'), ('49', 'appendfilename', 'appendonly-%d.aof', 'aof�ļ�����,Ĭ��:appendonly-{port}.aof', '2016-07-05 15:08:32', '6', '1', '29', '0'), ('50', 'dbfilename', 'dump-%d.rdb', 'RDB�ļ�Ĭ������,Ĭ��dump-{port}.rdb', '2016-07-05 15:08:32', '6', '1', '29', '0'), ('51', 'aof-rewrite-incremental-fsync', 'yes', 'aof rewrite������,�Ƿ��ȡ�����ļ�ͬ������,Ĭ��:yes', '2016-07-05 15:08:32', '6', '1', '29', '0'), ('52', 'no-appendfsync-on-rewrite', 'yes', '�Ƿ��ں�̨aof�ļ�rewrite�ڼ����fsync,Ĭ�ϵ���,�޸�Ϊyes,��ֹ����fsync����,�����ܶ�ʧrewrite�ڼ������', '2016-07-05 15:08:32', '6', '1', '29', '0'), ('53', 'auto-aof-rewrite-min-size', '64m', '����rewrite��aof�ļ���С��ֵ,Ĭ��64m', '2016-07-05 15:08:32', '6', '1', '29', '0'), ('54', 'auto-aof-rewrite-percentage', '%d', 'Redis��дaof�ļ��ı�������,Ĭ�ϴ�100��ʼ,ͳһ�����²�ͬʵ����4%�ݼ�', '2016-07-05 15:08:32', '6', '1', '29', '0'), ('55', 'maxclients', '10000', '�ͻ������������', '2016-07-05 15:08:32', '6', '1', '29', '0'), ('126', 'cluster-enabled', 'yes', '�Ƿ�����Ⱥģʽ', '2018-09-18 18:23:03', '2', '1', '31', '0'), ('127', 'cluster-node-timeout', '15000', '��Ⱥ�ڵ㳬ʱʱ��,Ĭ��15��', '2018-09-18 18:23:03', '2', '1', '31', '0'), ('128', 'cluster-slave-validity-factor', '10', '�ӽڵ��ӳ���Ч���ж�����,Ĭ��10��', '2018-09-18 18:23:03', '2', '1', '31', '0'), ('129', 'cluster-migration-barrier', '1', '����Ǩ��������Ҫ�Ĵӽڵ���,Ĭ��1��', '2018-09-18 18:23:03', '2', '1', '31', '0'), ('130', 'cluster-config-file', 'nodes-%d.conf', '��Ⱥ�����ļ�����,��ʽ:nodes-{port}.conf', '2018-09-18 18:23:03', '2', '1', '31', '0'), ('131', 'cluster-require-full-coverage', 'no', '�ڵ㲿��ʧ���ڼ�,�����ڵ��Ƿ��������', '2018-09-18 18:23:03', '2', '1', '31', '0'), ('132', 'port', '%d', 'sentinelʵ���˿�', '2018-09-18 18:23:03', '5', '1', '31', '0'), ('133', 'dir', '%s', '����Ŀ¼', '2018-09-18 18:23:03', '5', '1', '31', '0'), ('134', 'sentinel monitor', '%s %s %d 1', 'master���ƶ�������ٲ����ص�sentinel��,��ʽ:masterName ip port num', '2018-09-18 18:23:03', '5', '1', '31', '0'), ('135', 'sentinel down-after-milliseconds', '%s 20000', 'Sentinel�ж����������ߵĺ�����', '2018-09-18 18:23:03', '5', '1', '31', '0'), ('136', 'sentinel failover-timeout', '%s 180000', '����Ǩ�Ƴ�ʱʱ��,Ĭ��:3����', '2018-09-18 18:23:03', '5', '1', '31', '0'), ('137', 'sentinel parallel-syncs', '%s 1', '��ִ�й���ת��ʱ,����ж��ٸ��ӷ�����ͬʱ���µ�������������ͬ��,Ĭ��:1', '2018-09-18 18:23:03', '5', '1', '31', '0'), ('138', 'daemonize', 'no', '�Ƿ��ػ�����', '2018-09-18 18:23:03', '6', '1', '31', '0'), ('139', 'tcp-backlog', '511', 'TCP������ɶ���', '2018-09-18 18:23:03', '6', '1', '31', '0'), ('140', 'timeout', '0', '�ͻ������ö������ر�����,Ĭ��Ϊ0,�����ر�', '2018-09-18 18:23:03', '6', '1', '31', '0'), ('141', 'tcp-keepalive', '60', '���ͻ����Ƿ񽡿�����,Ĭ�Ϲر�', '2018-09-18 18:23:03', '6', '1', '31', '0'), ('142', 'loglevel', 'notice', '��־����', '2018-09-18 18:23:03', '6', '1', '31', '0'), ('143', 'databases', '16', '���õ����ݿ�����Ĭ��ֵΪ16��,Ĭ�����ݿ�Ϊ0', '2018-09-18 18:23:03', '6', '1', '31', '0'), ('144', 'dir', '%s', 'redis����Ŀ¼', '2018-09-18 18:23:03', '6', '1', '31', '0'), ('145', 'stop-writes-on-bgsave-error', 'no', 'bgsave�����˲�ͣд', '2018-09-18 18:23:03', '6', '1', '31', '0'), ('146', 'repl-timeout', '60', 'master�������ݴ���ʱ�����ping�ظ�ʱ����,Ĭ��:60��', '2018-09-18 18:23:03', '6', '1', '31', '0'), ('147', 'repl-ping-slave-period', '10', 'ָ��slave����ping master������,Ĭ��:10��', '2018-09-18 18:23:03', '6', '1', '31', '0'), ('148', 'repl-disable-tcp-nodelay', 'no', '�Ƿ����socket��NO_DELAY,Ĭ�Ϲرգ�Ӱ�������ӳ�', '2018-09-18 18:23:03', '6', '1', '31', '0'), ('149', 'repl-backlog-size', '10M', '���ƻ�����,Ĭ��:1mb,����Ϊ:10Mb', '2018-09-18 18:23:03', '6', '1', '31', '0'), ('150', 'repl-backlog-ttl', '7200', 'master��û��Slave��������ͷ�BACKLOG��ʱ����:Ĭ��:3600,����Ϊ:7200', '2018-09-18 18:23:03', '6', '1', '31', '0'), ('151', 'slave-serve-stale-data', 'yes', '��slave��������master������ʧȥ���Ӻ󣬻��ߵ��������ڸ��ƴ����ʱ������˲���ֵ���á�yes����slave���������Լ������ܿͻ��˵�����', '2018-09-18 18:23:03', '6', '1', '31', '0'), ('152', 'slave-read-only', 'yes', 'slave�������ڵ��Ƿ�ֻ��,cluster��slave�ڵ�Ĭ�϶�д��������,��Ҫ����readonly�����ɶ�ģʽ', '2018-09-18 18:23:03', '6', '1', '31', '0'), ('153', 'slave-priority', '100', 'slave�����ȼ�,Ӱ��sentinel/cluster����master����,0��Զ������', '2018-09-18 18:23:03', '6', '1', '31', '0'), ('154', 'lua-time-limit', '5000', 'Lua�ű����ִ��ʱ�䣬��λΪ����', '2018-09-18 18:23:03', '6', '1', '31', '0'), ('155', 'slowlog-log-slower-than', '10000', '����ѯ����¼�ķ�ֵ,Ĭ��10����', '2018-09-18 18:23:03', '6', '1', '31', '0'), ('156', 'slowlog-max-len', '128', '����¼����ѯ������', '2018-09-18 18:23:03', '6', '1', '31', '0'), ('157', 'hash-max-ziplist-entries', '512', 'hash���ݽṹ�Ż�����', '2018-09-18 18:23:03', '6', '1', '31', '0'), ('158', 'hash-max-ziplist-value', '64', 'hash���ݽṹ�Ż�����', '2018-09-18 18:23:03', '6', '1', '31', '0'), ('159', 'list-max-ziplist-entries', '512', 'list���ݽṹ�Ż�����', '2018-09-18 18:25:32', '6', '0', '31', '0'), ('160', 'list-max-ziplist-value', '64', 'list���ݽṹ�Ż�����', '2018-09-18 18:25:40', '6', '0', '31', '0'), ('161', 'set-max-intset-entries', '512', 'set���ݽṹ�Ż�����', '2018-09-18 18:23:03', '6', '1', '31', '0'), ('162', 'zset-max-ziplist-entries', '128', 'zset���ݽṹ�Ż�����', '2018-09-18 18:23:03', '6', '1', '31', '0'), ('163', 'zset-max-ziplist-value', '64', 'zset���ݽṹ�Ż�����', '2018-09-18 18:23:03', '6', '1', '31', '0'), ('164', 'activerehashing', 'yes', '�Ƿ񼤻����ù�ϣ,Ĭ��:yes', '2018-09-18 18:23:03', '6', '1', '31', '0'), ('165', 'client-output-buffer-limit normal', '0 0 0', '�ͻ����������������(�ͻ���)', '2018-09-18 18:23:03', '6', '1', '31', '0'), ('166', 'client-output-buffer-limit slave', '512mb 256mb 60', '�ͻ����������������(����)', '2018-09-18 18:23:03', '6', '1', '31', '0'), ('167', 'client-output-buffer-limit pubsub', '32mb 8mb 60', '�ͻ����������������(��������)', '2018-09-18 18:23:03', '6', '1', '31', '0'), ('168', 'hz', '10', 'ִ�к�̨task����,Ĭ��:10', '2018-09-18 18:23:03', '6', '1', '31', '0'), ('169', 'port', '%d', '�˿�', '2018-09-18 18:23:03', '6', '1', '31', '0'), ('170', 'maxmemory', '%dmb', '��ǰʵ���������ڴ�', '2018-09-18 18:23:03', '6', '1', '31', '0'), ('171', 'maxmemory-policy', 'volatile-lru', '�ڴ治��ʱ,��̭����,Ĭ��:volatile-lru', '2018-09-18 18:23:03', '6', '1', '31', '0'), ('172', 'appendonly', 'yes', '����append only�־û�ģʽ', '2018-09-18 18:23:03', '6', '1', '31', '0'), ('173', 'appendfsync', 'everysec', 'Ĭ��:aofÿ��ͬ��һ��', '2018-09-18 18:23:03', '6', '1', '31', '0'), ('174', 'appendfilename', 'appendonly-%d.aof', 'aof�ļ�����,Ĭ��:appendonly-{port}.aof', '2018-09-18 18:23:03', '6', '1', '31', '0'), ('175', 'dbfilename', 'dump-%d.rdb', 'RDB�ļ�Ĭ������,Ĭ��dump-{port}.rdb', '2018-09-18 18:23:03', '6', '1', '31', '0'), ('176', 'aof-rewrite-incremental-fsync', 'yes', 'aof rewrite������,�Ƿ��ȡ�����ļ�ͬ������,Ĭ��:yes', '2018-09-18 18:23:03', '6', '1', '31', '0'), ('177', 'no-appendfsync-on-rewrite', 'yes', '�Ƿ��ں�̨aof�ļ�rewrite�ڼ����fsync,Ĭ�ϵ���,�޸�Ϊyes,��ֹ����fsync����,�����ܶ�ʧrewrite�ڼ������', '2018-09-18 18:23:03', '6', '1', '31', '0'), ('178', 'auto-aof-rewrite-min-size', '64m', '����rewrite��aof�ļ���С��ֵ,Ĭ��64m', '2018-09-18 18:23:03', '6', '1', '31', '0'), ('179', 'auto-aof-rewrite-percentage', '%d', 'Redis��дaof�ļ��ı�������,Ĭ�ϴ�100��ʼ,ͳһ�����²�ͬʵ����4%�ݼ�', '2018-09-18 18:23:03', '6', '1', '31', '0'), ('180', 'maxclients', '10000', '�ͻ������������', '2018-09-18 18:23:03', '6', '1', '31', '0'), ('181', 'protected-mode', 'yes', '��������ģʽ', '2018-09-18 18:23:03', '6', '1', '31', '0'), ('182', 'bind', '0.0.0.0', 'Ĭ�Ͽͻ��˶�������', '2018-09-18 18:23:03', '6', '1', '31', '0'), ('185', 'list-max-ziplist-size', '-2', '8Kb�������ڲ���ziplist', '2018-09-18 18:26:32', '6', '1', '31', '0'), ('186', 'list-compress-depth', '0', 'ѹ����ʽ��0:��ѹ��', '2018-09-18 18:27:12', '6', '1', '31', '0'), ('253', 'protected-mode', 'no', '�رձ���ģʽ', '2018-11-01 16:10:59', '5', '1', '31', '0'), ('354', 'cluster-enabled', 'yes', '�Ƿ�����Ⱥģʽ', '2019-10-24 17:33:26', '2', '1', '12', '0'), ('355', 'cluster-node-timeout', '15000', '��Ⱥ�ڵ㳬ʱʱ��,Ĭ��15��', '2019-10-24 17:33:26', '2', '1', '12', '0'), ('356', 'cluster-slave-validity-factor', '10', '�ӽڵ��ӳ���Ч���ж�����,Ĭ��10��', '2019-10-24 17:33:26', '2', '1', '12', '0'), ('357', 'cluster-migration-barrier', '1', '����Ǩ��������Ҫ�Ĵӽڵ���,Ĭ��1��', '2019-10-24 17:33:26', '2', '1', '12', '0'), ('358', 'cluster-config-file', 'nodes-%d.conf', '��Ⱥ�����ļ�����,��ʽ:nodes-{port}.conf', '2019-10-24 17:33:26', '2', '1', '12', '0'), ('359', 'cluster-require-full-coverage', 'no', '�ڵ㲿��ʧ���ڼ�,�����ڵ��Ƿ��������', '2019-10-24 17:33:26', '2', '1', '12', '0'), ('360', 'port', '%d', 'sentinelʵ���˿�', '2019-10-24 17:33:26', '5', '1', '12', '0'), ('361', 'dir', '%s', '����Ŀ¼', '2019-10-24 17:33:26', '5', '1', '12', '0'), ('362', 'sentinel monitor', '%s %s %d 1', 'master���ƶ�������ٲ����ص�sentinel��,��ʽ:masterName ip port num', '2019-10-24 17:33:26', '5', '1', '12', '0'), ('363', 'sentinel down-after-milliseconds', '%s 20000', 'Sentinel�ж����������ߵĺ�����', '2019-10-24 17:33:26', '5', '1', '12', '0'), ('364', 'sentinel failover-timeout', '%s 180000', '����Ǩ�Ƴ�ʱʱ��,Ĭ��:3����', '2019-10-24 17:33:26', '5', '1', '12', '0'), ('365', 'sentinel parallel-syncs', '%s 1', '��ִ�й���ת��ʱ,����ж��ٸ��ӷ�����ͬʱ���µ�������������ͬ��,Ĭ��:1', '2019-10-24 17:33:26', '5', '1', '12', '0'), ('366', 'daemonize', 'no', '�Ƿ��ػ�����', '2019-10-24 17:33:26', '6', '1', '12', '0'), ('367', 'tcp-backlog', '511', 'TCP������ɶ���', '2019-10-24 17:33:26', '6', '1', '12', '0'), ('368', 'timeout', '0', '�ͻ������ö������ر�����,Ĭ��Ϊ0,�����ر�', '2019-10-24 17:33:26', '6', '1', '12', '0'), ('369', 'tcp-keepalive', '60', '���ͻ����Ƿ񽡿�����,Ĭ�Ϲر�', '2019-10-24 17:33:26', '6', '1', '12', '0'), ('370', 'loglevel', 'notice', '��־����', '2019-10-24 17:33:26', '6', '1', '12', '0'), ('371', 'databases', '16', '���õ����ݿ�����Ĭ��ֵΪ16��,Ĭ�����ݿ�Ϊ0', '2019-10-24 17:33:26', '6', '1', '12', '0'), ('372', 'dir', '%s', 'redis����Ŀ¼', '2019-10-24 17:33:26', '6', '1', '12', '0'), ('373', 'stop-writes-on-bgsave-error', 'no', 'bgsave�����˲�ͣд', '2019-10-24 17:33:26', '6', '1', '12', '0'), ('374', 'repl-timeout', '60', 'master�������ݴ���ʱ�����ping�ظ�ʱ����,Ĭ��:60��', '2019-10-24 17:33:26', '6', '1', '12', '0'), ('375', 'repl-ping-slave-period', '10', 'ָ��slave����ping master������,Ĭ��:10��', '2019-10-24 17:33:26', '6', '1', '12', '0'), ('376', 'repl-disable-tcp-nodelay', 'no', '�Ƿ����socket��NO_DELAY,Ĭ�Ϲرգ�Ӱ�������ӳ�', '2019-10-24 17:33:26', '6', '1', '12', '0'), ('377', 'repl-backlog-size', '10M', '���ƻ�����,Ĭ��:1mb,����Ϊ:10Mb', '2019-10-24 17:33:26', '6', '1', '12', '0'), ('378', 'repl-backlog-ttl', '7200', 'master��û��Slave��������ͷ�BACKLOG��ʱ����:Ĭ��:3600,����Ϊ:7200', '2019-10-24 17:33:26', '6', '1', '12', '0'), ('379', 'slave-serve-stale-data', 'yes', '��slave��������master������ʧȥ���Ӻ󣬻��ߵ��������ڸ��ƴ����ʱ������˲���ֵ���á�yes����slave���������Լ������ܿͻ��˵�����', '2019-10-24 17:33:26', '6', '1', '12', '0'), ('380', 'slave-read-only', 'yes', 'slave�������ڵ��Ƿ�ֻ��,cluster��slave�ڵ�Ĭ�϶�д��������,��Ҫ����readonly�����ɶ�ģʽ', '2019-10-24 17:33:26', '6', '1', '12', '0'), ('381', 'slave-priority', '100', 'slave�����ȼ�,Ӱ��sentinel/cluster����master����,0��Զ������', '2019-10-24 17:33:26', '6', '1', '12', '0'), ('382', 'lua-time-limit', '5000', 'Lua�ű����ִ��ʱ�䣬��λΪ����', '2019-10-24 17:33:26', '6', '1', '12', '0'), ('383', 'slowlog-log-slower-than', '10000', '����ѯ����¼�ķ�ֵ,Ĭ��10����', '2019-10-24 17:33:26', '6', '1', '12', '0'), ('384', 'slowlog-max-len', '128', '����¼����ѯ������', '2019-10-24 17:33:26', '6', '1', '12', '0'), ('385', 'hash-max-ziplist-entries', '512', 'hash���ݽṹ�Ż�����', '2019-10-24 17:33:26', '6', '1', '12', '0'), ('386', 'hash-max-ziplist-value', '64', 'hash���ݽṹ�Ż�����', '2019-10-24 17:33:26', '6', '1', '12', '0'), ('387', 'list-max-ziplist-entries', '512', 'list���ݽṹ�Ż�����', '2019-10-24 17:33:26', '6', '0', '12', '0'), ('388', 'list-max-ziplist-value', '64', 'list���ݽṹ�Ż�����', '2019-10-24 17:33:26', '6', '0', '12', '0'), ('389', 'set-max-intset-entries', '512', 'set���ݽṹ�Ż�����', '2019-10-24 17:33:26', '6', '1', '12', '0'), ('390', 'zset-max-ziplist-entries', '128', 'zset���ݽṹ�Ż�����', '2019-10-24 17:33:26', '6', '1', '12', '0'), ('391', 'zset-max-ziplist-value', '64', 'zset���ݽṹ�Ż�����', '2019-10-24 17:33:26', '6', '1', '12', '0'), ('392', 'activerehashing', 'yes', '�Ƿ񼤻����ù�ϣ,Ĭ��:yes', '2019-10-24 17:33:26', '6', '1', '12', '0'), ('393', 'client-output-buffer-limit normal', '0 0 0', '�ͻ����������������(�ͻ���)', '2019-10-24 17:33:26', '6', '1', '12', '0'), ('394', 'client-output-buffer-limit slave', '512mb 256mb 60', '�ͻ����������������(����)', '2019-10-24 17:33:26', '6', '1', '12', '0'), ('395', 'client-output-buffer-limit pubsub', '32mb 8mb 60', '�ͻ����������������(��������)', '2019-10-24 17:33:26', '6', '1', '12', '0'), ('396', 'hz', '10', 'ִ�к�̨task����,Ĭ��:10', '2019-10-24 17:33:26', '6', '1', '12', '0'), ('397', 'port', '%d', '�˿�', '2019-10-24 17:33:26', '6', '1', '12', '0'), ('398', 'maxmemory', '%dmb', '��ǰʵ���������ڴ�', '2019-10-24 17:33:26', '6', '1', '12', '0'), ('399', 'maxmemory-policy', 'volatile-lfu', '�ڴ治��ʱ,��̭����,Ĭ��:volatile-lfu', '2019-10-24 17:33:26', '6', '1', '12', '0'), ('400', 'appendonly', 'yes', '����append only�־û�ģʽ', '2019-10-24 17:33:26', '6', '1', '12', '0'), ('401', 'appendfsync', 'everysec', 'Ĭ��:aofÿ��ͬ��һ��', '2019-10-24 17:33:26', '6', '1', '12', '0'), ('402', 'appendfilename', 'appendonly-%d.aof', 'aof�ļ�����,Ĭ��:appendonly-{port}.aof', '2019-10-24 17:33:26', '6', '1', '12', '0'), ('403', 'dbfilename', 'dump-%d.rdb', 'RDB�ļ�Ĭ������,Ĭ��dump-{port}.rdb', '2019-10-24 17:33:26', '6', '1', '12', '0'), ('404', 'aof-rewrite-incremental-fsync', 'yes', 'aof rewrite������,�Ƿ��ȡ�����ļ�ͬ������,Ĭ��:yes', '2019-10-24 17:33:26', '6', '1', '12', '0'), ('405', 'no-appendfsync-on-rewrite', 'yes', '�Ƿ��ں�̨aof�ļ�rewrite�ڼ����fsync,Ĭ�ϵ���,�޸�Ϊyes,��ֹ����fsync����,�����ܶ�ʧrewrite�ڼ������', '2019-10-24 17:33:26', '6', '1', '12', '0'), ('406', 'auto-aof-rewrite-min-size', '64m', '����rewrite��aof�ļ���С��ֵ,Ĭ��64m', '2019-10-24 17:33:26', '6', '1', '12', '0'), ('407', 'auto-aof-rewrite-percentage', '%d', 'Redis��дaof�ļ��ı�������,Ĭ�ϴ�100��ʼ,ͳһ�����²�ͬʵ����4%�ݼ�', '2019-10-24 17:33:26', '6', '1', '12', '0'), ('408', 'maxclients', '10000', '�ͻ������������', '2019-10-24 17:33:26', '6', '1', '12', '0'), ('409', 'protected-mode', 'yes', '��������ģʽ', '2019-10-24 17:33:26', '6', '1', '12', '0'), ('410', 'bind', '0.0.0.0', 'Ĭ�Ͽͻ��˶�������', '2019-10-24 17:33:26', '6', '1', '12', '0'), ('411', 'list-max-ziplist-size', '-2', '8Kb�������ڲ���ziplist', '2019-10-24 17:33:26', '6', '1', '12', '0'), ('412', 'list-compress-depth', '0', 'ѹ����ʽ��0:��ѹ��', '2019-10-24 17:33:26', '6', '1', '12', '0'), ('413', 'always-show-logo', 'yes', 'redis�����Ƿ���ʾlogo', '2019-10-24 17:33:26', '6', '1', '12', '0'), ('414', 'lazyfree-lazy-eviction', 'yes', '�ڱ�����̭��ʱ���Ƿ����lazy free����,Ĭ��:no', '2019-10-24 17:33:26', '6', '1', '12', '0'), ('415', 'lazyfree-lazy-expire', 'yes', 'TTL�ļ������Ƿ����lazyfree���� Ĭ��ֵ:no', '2019-10-24 17:33:26', '6', '1', '12', '0'), ('416', 'lazyfree-lazy-server-del', 'yes', '��ʽ��DEL��(rename)�Ƿ����lazyfree���� Ĭ��ֵ:no', '2019-10-24 17:33:26', '6', '1', '12', '0'), ('417', 'slave-lazy-flush', 'yes', 'slave����ȫ������,�Ƿ����flushall async���������� Ĭ��ֵ no', '2019-10-24 17:33:26', '6', '1', '12', '0'), ('418', 'aof-use-rdb-preamble', 'yes', '�Ƿ�����ϳ־û�,Ĭ��ֵ no ������', '2019-10-31 11:15:57', '6', '1', '12', '0'), ('419', 'protected-mode', 'no', '�ر�sentinel����ģʽ', '2019-10-24 17:33:26', '5', '1', '12', '0'), ('420', 'activedefrag', 'no', '��Ƭ������', '2019-10-24 17:33:26', '6', '1', '12', '0'), ('421', 'active-defrag-threshold-lower', '10', '��Ƭ�ʴﵽ�ٷ�֮���ٿ�������', '2019-10-24 17:33:26', '6', '1', '12', '0'), ('422', 'active-defrag-threshold-upper', '100', '��Ƭ��С����ٰٷֱȿ�������', '2019-10-24 17:33:26', '6', '1', '12', '0'), ('423', 'active-defrag-ignore-bytes', '300mb', '�ڴ���Ƭ�ﵽ�����׿�����Ƭ', '2019-10-24 17:33:26', '6', '1', '12', '0'), ('424', 'active-defrag-cycle-min', '10', '��Ƭ������Сcpu�ٷֱ�', '2019-10-24 17:33:26', '6', '1', '12', '0'), ('425', 'active-defrag-cycle-max', '30', '��Ƭ�������cpu�ٷֱ�', '2019-10-24 17:33:26', '6', '1', '12', '0'), ('506', 'cluster-enabled', 'yes', '�Ƿ�����Ⱥģʽ', '2020-04-26 18:12:55', '2', '1', '37', '0'), ('507', 'cluster-node-timeout', '15000', '��Ⱥ�ڵ㳬ʱʱ��,Ĭ��15��', '2020-04-26 18:12:55', '2', '1', '37', '0'), ('508', 'cluster-migration-barrier', '1', '����Ǩ��������Ҫ�Ĵӽڵ���,Ĭ��1��', '2020-04-26 18:12:55', '2', '1', '37', '0'), ('509', 'cluster-config-file', 'nodes-%d.conf', '��Ⱥ�����ļ�����,��ʽ:nodes-{port}.conf', '2020-04-26 18:12:55', '2', '1', '37', '0'), ('510', 'cluster-require-full-coverage', 'no', '�ڵ㲿��ʧ���ڼ�,�����ڵ��Ƿ��������', '2020-04-26 18:12:55', '2', '1', '37', '0'), ('511', 'port', '%d', 'sentinelʵ���˿�', '2020-04-26 18:12:55', '5', '1', '37', '0'), ('512', 'dir', '%s', '����Ŀ¼', '2020-04-26 18:12:55', '5', '1', '37', '0'), ('513', 'sentinel monitor', '%s %s %d 1', 'master���ƶ�������ٲ����ص�sentinel��,��ʽ:masterName ip port num', '2020-04-26 18:12:55', '5', '1', '37', '0'), ('514', 'sentinel down-after-milliseconds', '%s 20000', 'Sentinel�ж����������ߵĺ�����', '2020-04-26 18:12:55', '5', '1', '37', '0'), ('515', 'sentinel failover-timeout', '%s 180000', '����Ǩ�Ƴ�ʱʱ��,Ĭ��:3����', '2020-04-26 18:12:55', '5', '1', '37', '0'), ('516', 'sentinel parallel-syncs', '%s 1', '��ִ�й���ת��ʱ,����ж��ٸ��ӷ�����ͬʱ���µ�������������ͬ��,Ĭ��:1', '2020-04-26 18:12:55', '5', '1', '37', '0'), ('517', 'daemonize', 'no', '�Ƿ��ػ�����', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('518', 'tcp-backlog', '511', 'TCP������ɶ���', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('519', 'timeout', '0', '�ͻ������ö������ر�����,Ĭ��Ϊ0,�����ر�', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('520', 'tcp-keepalive', '60', '���ͻ����Ƿ񽡿�����,Ĭ�Ϲر�', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('521', 'loglevel', 'notice', '��־����', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('522', 'databases', '16', '���õ����ݿ�����Ĭ��ֵΪ16��,Ĭ�����ݿ�Ϊ0', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('523', 'dir', '%s', 'redis����Ŀ¼', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('524', 'stop-writes-on-bgsave-error', 'no', 'bgsave�����˲�ͣд', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('525', 'repl-timeout', '60', 'master�������ݴ���ʱ�����ping�ظ�ʱ����,Ĭ��:60��', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('526', 'repl-disable-tcp-nodelay', 'no', '�Ƿ����socket��NO_DELAY,Ĭ�Ϲرգ�Ӱ�������ӳ�', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('527', 'repl-backlog-size', '10M', '���ƻ�����,Ĭ��:1mb,����Ϊ:10Mb', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('528', 'repl-backlog-ttl', '7200', 'master��û�дӽڵ��������ͷ�BACKLOG��ʱ����:Ĭ��:3600,����Ϊ:7200', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('529', 'lua-time-limit', '5000', 'Lua�ű����ִ��ʱ�䣬��λΪ����', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('530', 'slowlog-log-slower-than', '10000', '����ѯ����¼�ķ�ֵ,Ĭ��10����', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('531', 'slowlog-max-len', '128', '����¼����ѯ������', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('532', 'hash-max-ziplist-entries', '512', 'hash���ݽṹ�Ż�����', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('533', 'hash-max-ziplist-value', '64', 'hash���ݽṹ�Ż�����', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('534', 'list-max-ziplist-entries', '512', 'list���ݽṹ�Ż�����', '2020-04-26 18:12:55', '6', '0', '37', '0'), ('535', 'list-max-ziplist-value', '64', 'list���ݽṹ�Ż�����', '2020-04-26 18:12:55', '6', '0', '37', '0'), ('536', 'set-max-intset-entries', '512', 'set���ݽṹ�Ż�����', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('537', 'zset-max-ziplist-entries', '128', 'zset���ݽṹ�Ż�����', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('538', 'zset-max-ziplist-value', '64', 'zset���ݽṹ�Ż�����', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('539', 'activerehashing', 'yes', '�Ƿ񼤻����ù�ϣ,Ĭ��:yes', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('540', 'client-output-buffer-limit normal', '0 0 0', '�ͻ����������������(�ͻ���)', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('541', 'client-output-buffer-limit pubsub', '32mb 8mb 60', '�ͻ����������������(��������)', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('542', 'hz', '10', 'ִ�к�̨task����,Ĭ��:10', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('543', 'port', '%d', '�˿�', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('544', 'maxmemory', '%dmb', '��ǰʵ���������ڴ�', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('545', 'maxmemory-policy', 'volatile-lfu', '�ڴ治��ʱ,��̭����,Ĭ��:volatile-lfu', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('546', 'appendonly', 'yes', '����append only�־û�ģʽ', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('547', 'appendfsync', 'everysec', 'Ĭ��:aofÿ��ͬ��һ��', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('548', 'appendfilename', 'appendonly-%d.aof', 'aof�ļ�����,Ĭ��:appendonly-{port}.aof', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('549', 'dbfilename', 'dump-%d.rdb', 'RDB�ļ�Ĭ������,Ĭ��dump-{port}.rdb', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('550', 'aof-rewrite-incremental-fsync', 'yes', 'aof rewrite������,�Ƿ��ȡ�����ļ�ͬ������,Ĭ��:yes', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('551', 'no-appendfsync-on-rewrite', 'yes', '�Ƿ��ں�̨aof�ļ�rewrite�ڼ����fsync,Ĭ�ϵ���,�޸�Ϊyes,��ֹ����fsync����,�����ܶ�ʧrewrite�ڼ������', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('552', 'auto-aof-rewrite-min-size', '64m', '����rewrite��aof�ļ���С��ֵ,Ĭ��64m', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('553', 'auto-aof-rewrite-percentage', '%d', 'Redis��дaof�ļ��ı�������,Ĭ�ϴ�100��ʼ,ͳһ�����²�ͬʵ����4%�ݼ�', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('554', 'maxclients', '10000', '�ͻ������������', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('555', 'protected-mode', 'yes', '��������ģʽ', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('556', 'bind', '0.0.0.0', 'Ĭ�Ͽͻ��˶�������', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('557', 'list-max-ziplist-size', '-2', '8Kb�������ڲ���ziplist', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('558', 'list-compress-depth', '0', 'ѹ����ʽ��0:��ѹ��', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('559', 'always-show-logo', 'yes', 'redis�����Ƿ���ʾlogo', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('560', 'lazyfree-lazy-eviction', 'yes', '�ڱ�����̭��ʱ���Ƿ����lazy free����,Ĭ��:no', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('561', 'lazyfree-lazy-expire', 'yes', 'TTL�ļ������Ƿ����lazyfree���� Ĭ��ֵ:no', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('562', 'lazyfree-lazy-server-del', 'yes', '��ʽ��DEL��(rename)�Ƿ����lazyfree���� Ĭ��ֵ:no', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('563', 'aof-use-rdb-preamble', 'yes', '�Ƿ�����ϳ־û�,Ĭ��ֵ no ������', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('564', 'protected-mode', 'no', '�ر�sentinel����ģʽ', '2020-04-26 18:12:55', '5', '1', '37', '0'), ('565', 'activedefrag', 'yes', '��Ƭ������', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('566', 'active-defrag-threshold-lower', '10', '��Ƭ�ʴﵽ�ٷ�֮���ٿ�������', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('567', 'active-defrag-threshold-upper', '100', '��Ƭ��С����ٰٷֱȿ�������', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('568', 'active-defrag-ignore-bytes', '300mb', '�ڴ���Ƭ�ﵽ�����׿�����Ƭ', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('569', 'active-defrag-cycle-min', '10', '��Ƭ������Сcpu�ٷֱ�', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('570', 'active-defrag-cycle-max', '30', '��Ƭ�������cpu�ٷֱ�', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('571', 'active-defrag-max-scan-fields', '1000', '�ڴ���Ƭ����set/hash/zset/list �е������������', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('572', 'replica-serve-stale-data', 'yes', '�ӽڵ���master��������������Ӧ��yes ������Ӧ no:���������쳣��Ϣ', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('573', 'cluster-replica-validity-factor', '10', '�ӽڵ��ӳ���Ч���ж�����,Ĭ��10��', '2020-04-26 18:12:55', '2', '1', '37', '0'), ('574', 'replica-priority', '100', '�ӽڵ�����ȼ�,Ӱ��sentinel/cluster����master����,0��Զ������', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('575', 'replica-read-only', 'yes', '�ӽڵ��Ƿ�ֻ��: yes ֻ��', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('576', 'replica-lazy-flush', 'yes', '�ӽڵ㷢��ȫ������,�Ƿ����flushall async���������� Ĭ��ֵ no', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('577', 'client-output-buffer-limit replica', '512mb 256mb 60', '�ͻ����������������', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('578', 'replica-ignore-maxmemory', 'yes', '�ӽڵ��Ƿ�������ڴ棬����һЩ���󻺳�������oom', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('579', 'stream-node-max-bytes', '4096', 'stream���ݽṹ�Ż�����', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('580', 'stream-node-max-entries', '100', 'stream���ݽṹ�Ż�����', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('581', 'dynamic-hz', 'yes', '����Ӧƽ�����CPU��ʹ���ʺ���Ӧ', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('582', 'rdb-save-incremental-fsync', 'yes', 'rdbͬ��ˢ���Ƿ��������fsync��ÿ32MBִ��һ��fsync', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('583', 'repl-ping-replica-period', '10', 'ָ���ӽڵ㶨��ping master������,Ĭ��:10��', '2020-04-26 18:12:55', '6', '1', '37', '0'), ('585', 'latency-monitor-threshold', '30', '�ӳ��¼���ֵ����λms', '2020-05-26 15:45:22', '6', '1', '37', '0'), ('587', 'latency-monitor-threshold', '30', '�ӳ��¼���ֵ����λms', '2020-05-26 15:46:18', '6', '1', '12', '0'), ('589', 'latency-monitor-threshold', '30', '�ӳ��¼���ֵ����λms', '2020-05-26 15:46:49', '6', '1', '31', '0'), ('590', 'latency-monitor-threshold', '30', '�ӳ��¼���ֵ����λms', '2020-05-26 15:49:47', '6', '1', '29', '0');
COMMIT;


--
-- Table structure for table `instance_fault`
--

DROP TABLE IF EXISTS `instance_fault`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `instance_fault` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_id` bigint(20) NOT NULL COMMENT 'Ӧ��id',
  `inst_id` bigint(20) NOT NULL COMMENT 'ʵ��id',
  `ip` varchar(16) NOT NULL COMMENT 'ip��ַ',
  `port` int(11) NOT NULL COMMENT '�˿�',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '״̬:0:����ֹͣ,1:�����ָ�',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '����ʱ��',
  `type` mediumint(4) NOT NULL COMMENT '���ͣ�1. memcached, 2. redis-cluster, 3. memcacheq, 4. ��cache-cloud 5. redis-sentinel 6.redis-standalone',
  `reason` mediumtext NOT NULL COMMENT '����ԭ������',
  PRIMARY KEY (`id`),
  KEY `idx_ip_port` (`ip`,`port`),
  KEY `app_id` (`app_id`),
  KEY `inst_id` (`inst_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8927 DEFAULT CHARSET=utf8 COMMENT='ʵ�����ϱ�' /* `compression`='tokudb_zlib' */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `instance_host`
--

DROP TABLE IF EXISTS `instance_host`;
CREATE TABLE `instance_host` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ip` varchar(16) NOT NULL COMMENT '����ip',
  `ssh_user` varchar(32) DEFAULT NULL COMMENT 'ssh�û�',
  `ssh_pwd` varchar(32) DEFAULT NULL COMMENT 'ssh����',
  `warn` int(5) DEFAULT '1' COMMENT '0��������1����',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uidx_host_ip` (`ip`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='������' /* `compression`='tokudb_zlib' */;

--
-- Table structure for table `instance_info`
--

DROP TABLE IF EXISTS `instance_info`;
CREATE TABLE `instance_info` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'memcached instance id',
  `parent_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '�Ե�ʵ����id',
  `app_id` bigint(20) NOT NULL COMMENT 'Ӧ��id����app_desc����',
  `host_id` bigint(20) NOT NULL COMMENT '��Ӧ������id����instance_host����',
  `ip` varchar(16) NOT NULL COMMENT 'ʵ����ip',
  `port` int(11) NOT NULL COMMENT 'ʵ���˿�',
  `status` tinyint(4) NOT NULL COMMENT '�Ƿ�����:0:�ڵ��쳣,1:��������,2:�ڵ�����',
  `mem` int(11) NOT NULL COMMENT '�ڴ��С',
  `conn` int(11) NOT NULL COMMENT '������',
  `cmd` varchar(255) NOT NULL COMMENT '����ʵ��������/redis-sentinel��masterName',
  `type` mediumint(11) NOT NULL COMMENT '���ͣ�1. memcached, 2. redis-cluster, 3. memcacheq, 4. ��cache-cloud 5. redis-sentinel 6.redis-standalone',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '����ʱ��',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uidx_inst_ipport` (`ip`,`port`) USING BTREE,
  KEY `app_id` (`app_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='ʵ����Ϣ' /* `compression`='tokudb_zlib' */;

--
-- Table structure for table `instance_latency_history`
--

DROP TABLE IF EXISTS `instance_latency_history`;
CREATE TABLE `instance_latency_history` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '����id',
  `instance_id` bigint(20) NOT NULL COMMENT 'ʵ����id',
  `app_id` bigint(20) NOT NULL COMMENT 'app id',
  `ip` varchar(32) NOT NULL COMMENT 'ip',
  `port` int(11) NOT NULL COMMENT 'port',
  `event` varchar(255) NOT NULL COMMENT '�¼�����',
  `execute_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'ִ��ʱ���',
  `execution_cost` bigint(20) NOT NULL COMMENT '��ʱ(΢��)',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '����ʱ��',
  PRIMARY KEY (`id`),
  UNIQUE KEY `latencyistorykey` (`instance_id`,`event`,`execute_date`),
  KEY `idx_app_create_time` (`app_id`,`create_time`),
  KEY `idx_app_executedate` (`app_id`,`execute_date`),
  KEY `idx_executedate` (`execute_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='ʵ���ӳ��¼���Ϣ��';

--
-- Table structure for table `instance_minute_stats`
--

DROP TABLE IF EXISTS `instance_minute_stats`;
CREATE TABLE `instance_minute_stats` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `collect_time` bigint(20) NOT NULL COMMENT '�ռ�ʱ��:��ʽyyyyMMddHHmm',
  `ip` varchar(16) NOT NULL COMMENT 'ip��ַ',
  `port` int(11) NOT NULL COMMENT '�˿�/hostId',
  `db_type` varchar(16) NOT NULL COMMENT '�ռ�����������',
  `json` text NOT NULL COMMENT 'ͳ��json����',
  `created_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '����ʱ��',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_index` (`ip`,`port`,`db_type`,`collect_time`),
  KEY `idx_collect_time` (`collect_time`),
  KEY `idx_created_time` (`created_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='ʵ������ͳ�Ʊ�';

--
-- Table structure for table `instance_reshard_process`
--

DROP TABLE IF EXISTS `instance_reshard_process`;
CREATE TABLE `instance_reshard_process` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '����id',
  `app_id` bigint(20) NOT NULL COMMENT 'Ӧ��id',
  `audit_id` bigint(20) NOT NULL COMMENT '���id',
  `source_instance_id` int(11) NOT NULL COMMENT 'Դʵ��id',
  `target_instance_id` int(11) NOT NULL COMMENT 'Ŀ��ʵ��id',
  `start_slot` int(11) NOT NULL COMMENT '��ʼslot',
  `end_slot` int(11) NOT NULL COMMENT '����slot',
  `migrating_slot` int(11) NOT NULL COMMENT '����Ǩ�Ƶ�slot',
  `is_pipeline` tinyint(4) NOT NULL COMMENT '�Ƿ�Ϊpipeline,0:��,1:��',
  `finish_slot_num` int(11) NOT NULL COMMENT '�Ѿ����Ǩ�Ƶ�slot����',
  `status` tinyint(4) NOT NULL COMMENT '0:������ 1:��� 2:����',
  `start_time` datetime NOT NULL COMMENT 'Ǩ�ƿ�ʼʱ��',
  `end_time` datetime NOT NULL COMMENT 'Ǩ�ƽ���ʱ��',
  `create_time` datetime NOT NULL COMMENT '����ʱ��',
  `update_time` datetime NOT NULL COMMENT '����ʱ��',
  PRIMARY KEY (`id`),
  KEY `idx_audit` (`audit_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='ʵ��Reshard����';

--
-- Table structure for table `instance_slow_log`
--

DROP TABLE IF EXISTS `instance_slow_log`;
CREATE TABLE `instance_slow_log` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '����id',
  `instance_id` bigint(20) NOT NULL COMMENT 'ʵ����id',
  `app_id` bigint(20) NOT NULL COMMENT 'app id',
  `ip` varchar(32) NOT NULL COMMENT 'ip',
  `port` int(11) NOT NULL COMMENT 'port',
  `slow_log_id` bigint(20) NOT NULL COMMENT '����ѯid',
  `cost_time` int(11) NOT NULL COMMENT '��ʱ(΢��)',
  `command` varchar(255) NOT NULL COMMENT 'ִ������',
  `execute_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'ִ��ʱ���',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '��¼����ʱ��',
  PRIMARY KEY (`id`),
  UNIQUE KEY `slowlogkey` (`instance_id`,`slow_log_id`,`execute_time`),
  KEY `idx_app_create_time` (`app_id`,`create_time`),
  KEY `idx_app_executetime` (`app_id`,`execute_time`),
  KEY `idx_executetime` (`execute_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='ʵ������ѯ�б�';

--
-- Table structure for table `instance_statistics`
--

DROP TABLE IF EXISTS `instance_statistics`;
CREATE TABLE `instance_statistics` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '����id',
  `inst_id` bigint(20) NOT NULL COMMENT 'ʵ����id',
  `app_id` bigint(20) NOT NULL COMMENT 'app id',
  `host_id` bigint(20) NOT NULL COMMENT '������id',
  `ip` varchar(16) COLLATE utf8_bin NOT NULL COMMENT 'ip',
  `port` int(255) NOT NULL COMMENT 'port',
  `role` tinyint(255) NOT NULL COMMENT '���ӣ�1��2��',
  `max_memory` bigint(255) NOT NULL COMMENT 'Ԥ�����ڴ棬��λbyte',
  `used_memory` bigint(255) NOT NULL COMMENT '��ʹ���ڴ棬��λbyte',
  `curr_items` bigint(255) NOT NULL COMMENT '��ǰitem����',
  `curr_connections` int(255) NOT NULL COMMENT '��ǰ������',
  `misses` bigint(255) NOT NULL COMMENT 'miss��',
  `hits` bigint(255) NOT NULL COMMENT '������',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modify_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `mem_fragmentation_ratio` double DEFAULT '0' COMMENT '��Ƭ��',
  `aof_delayed_fsync` int(11) DEFAULT '0' COMMENT 'aof��������',
  PRIMARY KEY (`id`),
  UNIQUE KEY `ip` (`ip`,`port`),
  KEY `app_id` (`app_id`),
  KEY `machine_id` (`host_id`),
  KEY `idx_inst_id` (`inst_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='ʵ��������ͳ����Ϣ' /* `compression`='tokudb_zlib' */;

--
-- Table structure for table `machine_info`
--

DROP TABLE IF EXISTS `machine_info`;
CREATE TABLE `machine_info` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '������id',
  `ssh_user` varchar(20) COLLATE utf8_bin NOT NULL DEFAULT 'cachecloud' COMMENT 'ssh�û�',
  `ssh_passwd` varchar(20) COLLATE utf8_bin NOT NULL DEFAULT 'cachecloud' COMMENT 'ssh����',
  `ip` varchar(16) COLLATE utf8_bin NOT NULL COMMENT 'ip',
  `room` varchar(20) COLLATE utf8_bin NOT NULL COMMENT '��������',
  `mem` int(11) unsigned NOT NULL COMMENT '�ڴ��С����λG',
  `cpu` mediumint(24) unsigned NOT NULL COMMENT 'cpu����',
  `virtual` tinyint(8) unsigned NOT NULL DEFAULT '1' COMMENT '�Ƿ����⣬0��ʾ��1��ʾ��',
  `real_ip` varchar(16) COLLATE utf8_bin NOT NULL COMMENT '������ip',
  `service_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '����ʱ��',
  `fault_count` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '���ϴ���',
  `modify_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '�޸�ʱ��',
  `warn` tinyint(255) unsigned NOT NULL DEFAULT '1' COMMENT '�Ƿ����ñ�����0�����ã�1����',
  `available` tinyint(255) NOT NULL COMMENT '��ʾ�����Ƿ���ã�1��ʾ���ã�0��ʾ�����ã�',
  `groupId` int(11) NOT NULL DEFAULT '0' COMMENT '�������飬Ĭ��Ϊ0����ʾԭ����Դ����0��ʾ�ⲿ�ṩ����Դ(����չ)',
  `type` int(11) NOT NULL DEFAULT '0' COMMENT '0ԭ�� 1 ����',
  `extra_desc` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '���ڻ����Ķ���˵��(���������װ����������(web,mysql,queue�ȵ�))',
  `collect` int(11) DEFAULT '1' COMMENT 'switch of collect server status, 1:open, 0:close',
  `version_install` varchar(512) COLLATE utf8_bin DEFAULT NULL COMMENT '������װredis�汾״̬',
  `use_type` tinyint(4) DEFAULT '2' COMMENT 'ʹ�����ͣ�Redisר�û���(0)��Redis���Ի���(1)����ϲ������(2)��Redis-Sentinel����(3)',
  `k8s_type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '�Ƿ�k8s������0:���� 1:��',
  `rack` varchar(128) COLLATE utf8_bin DEFAULT '' COMMENT '�������ڻ�����Ϣ',
  `is_allocating` tinyint(4) NOT NULL DEFAULT '0' COMMENT '�Ƿ��ڷ�����,1��0��',
  `disk` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '���̿ռ�:G',
  PRIMARY KEY (`id`),
  UNIQUE KEY `ip` (`ip`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='������Ϣ��' /* `compression`='tokudb_zlib' */;

--
-- Table structure for table `machine_relation`
--

DROP TABLE IF EXISTS `machine_relation`;
CREATE TABLE `machine_relation` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '����id',
  `ip` varchar(64) NOT NULL COMMENT '�����ip',
  `real_ip` varchar(64) NOT NULL COMMENT '������ip',
  `extra_desc` varchar(128) DEFAULT NULL COMMENT 'ʵ��������Ϣ',
  `status` int(255) NOT NULL COMMENT 'ʵ�����״̬ 0:offline ,1:online',
  `is_sync` tinyint(4) NOT NULL DEFAULT '0' COMMENT '����ͬ��״̬ 0: δͬ������  -1:ͬ���� 1:������ͬ�� -2:ͬ��ʧ�� ',
  `sync_time` timestamp NULL DEFAULT NULL COMMENT 'ͬ��ʱ��',
  `update_time` timestamp NULL DEFAULT NULL COMMENT 'pod������ʱ��',
  `taskid` bigint(11) DEFAULT NULL COMMENT '����id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `machine_room`
--

DROP TABLE IF EXISTS `machine_room`;
CREATE TABLE `machine_room` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '����id',
  `name` varchar(255) NOT NULL COMMENT '��������',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '0:��Ч 1:��Ч',
  `desc` varchar(255) DEFAULT NULL COMMENT '����������Ϣ',
  `ip_network` varchar(32) NOT NULL DEFAULT '' COMMENT '����������Ϣ',
  `operator` varchar(255) DEFAULT NULL COMMENT '��Ӫ��',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `machine_room`
-- ----------------------------
BEGIN;
INSERT INTO `machine_room` VALUES ('1', '�����ƺ���', '1', '������-���ݻ���', '172.27.*.*', '������');
COMMIT;

--
-- Table structure for table `machine_statistics`
--

DROP TABLE IF EXISTS `machine_statistics`;
CREATE TABLE `machine_statistics` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `host_id` bigint(20) NOT NULL COMMENT '����id',
  `ip` varchar(16) NOT NULL COMMENT '����ip',
  `cpu_usage` varchar(120) NOT NULL COMMENT 'cpuʹ����',
  `load` varchar(120) NOT NULL COMMENT '��������',
  `traffic` varchar(120) NOT NULL COMMENT 'io��������',
  `memory_usage_ratio` varchar(120) NOT NULL COMMENT '�ڴ�ʹ����',
  `memory_free` varchar(120) NOT NULL COMMENT '�ڴ�ʣ��',
  `memory_total` varchar(120) NOT NULL COMMENT '���ڴ���',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '����ʱ��',
  `modify_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '�޸�ʱ��',
  `max_memory` int(11) DEFAULT '0' COMMENT '���������ڴ�,��λMB',
  `instance_count` int(11) DEFAULT '0' COMMENT '����ʵ������',
  `machine_memory` int(11) DEFAULT '0' COMMENT '����������ڴ�,��λMB',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uidx_ip` (`ip`),
  KEY `host_id` (`host_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='����״̬ͳ����Ϣ' /* `compression`='tokudb_zlib' */;

--
-- Table structure for table `qrtz_blob_triggers`
--

DROP TABLE IF EXISTS `qrtz_blob_triggers`;
CREATE TABLE `qrtz_blob_triggers` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `TRIGGER_NAME` varchar(200) NOT NULL,
  `TRIGGER_GROUP` varchar(200) NOT NULL,
  `BLOB_DATA` blob,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
  KEY `SCHED_NAME` (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Trigger ��Ϊ Blob ���ʹ洢(���� Quartz �û��� JDBC ���������Լ����Ƶ� Trigger ����' /* `compression`='tokudb_zlib' */;

--
-- Table structure for table `qrtz_calendars`
--

DROP TABLE IF EXISTS `qrtz_calendars`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `qrtz_calendars` (
  `SCHED_NAME` varchar(120) NOT NULL COMMENT 'scheduler����',
  `CALENDAR_NAME` varchar(200) NOT NULL COMMENT 'calendar����',
  `CALENDAR` blob NOT NULL COMMENT 'calendar��Ϣ',
  PRIMARY KEY (`SCHED_NAME`,`CALENDAR_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='�� Blob ���ʹ洢 Quartz �� Calendar ��Ϣ' /* `compression`='tokudb_zlib' */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `qrtz_cron_triggers`
--

DROP TABLE IF EXISTS `qrtz_cron_triggers`;
CREATE TABLE `qrtz_cron_triggers` (
  `SCHED_NAME` varchar(120) NOT NULL COMMENT 'scheduler����',
  `TRIGGER_NAME` varchar(200) NOT NULL COMMENT 'trigger��',
  `TRIGGER_GROUP` varchar(200) NOT NULL COMMENT 'trigger��',
  `CRON_EXPRESSION` varchar(120) NOT NULL COMMENT 'cron���ʽ',
  `TIME_ZONE_ID` varchar(80) DEFAULT NULL COMMENT 'ʱ��',
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='�洢 Cron Trigger������ Cron ���ʽ��ʱ����Ϣ' /* `compression`='tokudb_zlib' */;

--
-- Table structure for table `qrtz_fired_triggers`
--

DROP TABLE IF EXISTS `qrtz_fired_triggers`;
CREATE TABLE `qrtz_fired_triggers` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `ENTRY_ID` varchar(195) NOT NULL,
  `TRIGGER_NAME` varchar(200) NOT NULL,
  `TRIGGER_GROUP` varchar(200) NOT NULL,
  `INSTANCE_NAME` varchar(200) NOT NULL,
  `FIRED_TIME` bigint(13) NOT NULL,
  `SCHED_TIME` bigint(13) NOT NULL,
  `PRIORITY` int(11) NOT NULL,
  `STATE` varchar(16) NOT NULL,
  `JOB_NAME` varchar(200) DEFAULT NULL,
  `JOB_GROUP` varchar(200) DEFAULT NULL,
  `IS_NONCONCURRENT` varchar(1) DEFAULT NULL COMMENT '�Ƿ�ǲ���ִ��',
  `REQUESTS_RECOVERY` varchar(1) DEFAULT NULL COMMENT '�Ƿ�־û�',
  PRIMARY KEY (`SCHED_NAME`,`ENTRY_ID`),
  KEY `IDX_QRTZ_FT_TRIG_INST_NAME` (`SCHED_NAME`,`INSTANCE_NAME`),
  KEY `IDX_QRTZ_FT_INST_JOB_REQ_RCVRY` (`SCHED_NAME`,`INSTANCE_NAME`,`REQUESTS_RECOVERY`),
  KEY `IDX_QRTZ_FT_J_G` (`SCHED_NAME`,`JOB_NAME`,`JOB_GROUP`),
  KEY `IDX_QRTZ_FT_JG` (`SCHED_NAME`,`JOB_GROUP`),
  KEY `IDX_QRTZ_FT_T_G` (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
  KEY `IDX_QRTZ_FT_TG` (`SCHED_NAME`,`TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='�洢�Ѵ����� Trigger��ص�״̬��Ϣ���Լ����� Job ��ִ����Ϣ' /* `compression`='tokudb_zlib' */;

--
-- Table structure for table `qrtz_job_details`
--

DROP TABLE IF EXISTS `qrtz_job_details`;
CREATE TABLE `qrtz_job_details` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `JOB_NAME` varchar(200) NOT NULL,
  `JOB_GROUP` varchar(200) NOT NULL,
  `DESCRIPTION` varchar(250) DEFAULT NULL,
  `JOB_CLASS_NAME` varchar(250) NOT NULL,
  `IS_DURABLE` varchar(1) NOT NULL COMMENT '�Ƿ�־û���0���־û���1�־û�',
  `IS_NONCONCURRENT` varchar(1) NOT NULL COMMENT '�Ƿ�ǲ�����0�ǲ�����1����',
  `IS_UPDATE_DATA` varchar(1) NOT NULL,
  `REQUESTS_RECOVERY` varchar(1) NOT NULL COMMENT '�Ƿ�ɻָ���0���ָ���1�ָ�',
  `JOB_DATA` blob,
  PRIMARY KEY (`SCHED_NAME`,`JOB_NAME`,`JOB_GROUP`),
  KEY `IDX_QRTZ_J_REQ_RECOVERY` (`SCHED_NAME`,`REQUESTS_RECOVERY`),
  KEY `IDX_QRTZ_J_GRP` (`SCHED_NAME`,`JOB_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='�洢ÿһ�������õ� Job ����ϸ��Ϣ' /* `compression`='tokudb_zlib' */;

--
-- Table structure for table `qrtz_locks`
--

DROP TABLE IF EXISTS `qrtz_locks`;
CREATE TABLE `qrtz_locks` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `LOCK_NAME` varchar(40) NOT NULL,
  PRIMARY KEY (`SCHED_NAME`,`LOCK_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='�洢����ı���������Ϣ(����ʹ���˱�����)' /* `compression`='tokudb_zlib' */;

--
-- Table structure for table `qrtz_paused_trigger_grps`
--

DROP TABLE IF EXISTS `qrtz_paused_trigger_grps`;
CREATE TABLE `qrtz_paused_trigger_grps` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `TRIGGER_GROUP` varchar(200) NOT NULL,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='�洢����ͣ�� Trigger �����Ϣ' /* `compression`='tokudb_zlib' */;

--
-- Table structure for table `qrtz_scheduler_state`
--

DROP TABLE IF EXISTS `qrtz_scheduler_state`;
CREATE TABLE `qrtz_scheduler_state` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `INSTANCE_NAME` varchar(200) NOT NULL COMMENT 'ִ��quartzʵ����������',
  `LAST_CHECKIN_TIME` bigint(13) NOT NULL COMMENT 'ʵ����״̬�������Ⱥ�е�����ʵ������һ��ʱ��',
  `CHECKIN_INTERVAL` bigint(13) NOT NULL COMMENT 'ʵ����״̬�����ʱ��Ƶ��',
  PRIMARY KEY (`SCHED_NAME`,`INSTANCE_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='�洢�������й� Scheduler ��״̬��Ϣ' /* `compression`='tokudb_zlib' */;

--
-- Table structure for table `qrtz_simple_triggers`
--

DROP TABLE IF EXISTS `qrtz_simple_triggers`;
CREATE TABLE `qrtz_simple_triggers` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `TRIGGER_NAME` varchar(200) NOT NULL,
  `TRIGGER_GROUP` varchar(200) NOT NULL,
  `REPEAT_COUNT` bigint(7) NOT NULL COMMENT '�ظ�����',
  `REPEAT_INTERVAL` bigint(12) NOT NULL COMMENT '�ظ����',
  `TIMES_TRIGGERED` bigint(10) NOT NULL COMMENT '�ѳ�������',
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='�洢�򵥵� Trigger�������ظ�������������Լ��Ѵ��Ĵ���' /* `compression`='tokudb_zlib' */;

--
-- Table structure for table `qrtz_simprop_triggers`
--

DROP TABLE IF EXISTS `qrtz_simprop_triggers`;
CREATE TABLE `qrtz_simprop_triggers` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `TRIGGER_NAME` varchar(200) NOT NULL,
  `TRIGGER_GROUP` varchar(200) NOT NULL,
  `STR_PROP_1` varchar(512) DEFAULT NULL,
  `STR_PROP_2` varchar(512) DEFAULT NULL,
  `STR_PROP_3` varchar(512) DEFAULT NULL,
  `INT_PROP_1` int(11) DEFAULT NULL,
  `INT_PROP_2` int(11) DEFAULT NULL,
  `LONG_PROP_1` bigint(20) DEFAULT NULL,
  `LONG_PROP_2` bigint(20) DEFAULT NULL,
  `DEC_PROP_1` decimal(13,4) DEFAULT NULL,
  `DEC_PROP_2` decimal(13,4) DEFAULT NULL,
  `BOOL_PROP_1` varchar(1) DEFAULT NULL,
  `BOOL_PROP_2` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 /* `compression`='tokudb_zlib' */;

--
-- Table structure for table `qrtz_triggers`
--

DROP TABLE IF EXISTS `qrtz_triggers`;
CREATE TABLE `qrtz_triggers` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `TRIGGER_NAME` varchar(200) NOT NULL,
  `TRIGGER_GROUP` varchar(200) NOT NULL,
  `JOB_NAME` varchar(200) NOT NULL,
  `JOB_GROUP` varchar(200) NOT NULL,
  `DESCRIPTION` varchar(250) DEFAULT NULL,
  `NEXT_FIRE_TIME` bigint(13) DEFAULT NULL,
  `PREV_FIRE_TIME` bigint(13) DEFAULT NULL,
  `PRIORITY` int(11) DEFAULT NULL,
  `TRIGGER_STATE` varchar(16) NOT NULL,
  `TRIGGER_TYPE` varchar(8) NOT NULL,
  `START_TIME` bigint(13) NOT NULL,
  `END_TIME` bigint(13) DEFAULT NULL,
  `CALENDAR_NAME` varchar(200) DEFAULT NULL,
  `MISFIRE_INSTR` smallint(2) DEFAULT NULL,
  `JOB_DATA` blob,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
  KEY `IDX_QRTZ_T_J` (`SCHED_NAME`,`JOB_NAME`,`JOB_GROUP`),
  KEY `IDX_QRTZ_T_JG` (`SCHED_NAME`,`JOB_GROUP`),
  KEY `IDX_QRTZ_T_C` (`SCHED_NAME`,`CALENDAR_NAME`),
  KEY `IDX_QRTZ_T_G` (`SCHED_NAME`,`TRIGGER_GROUP`),
  KEY `IDX_QRTZ_T_STATE` (`SCHED_NAME`,`TRIGGER_STATE`),
  KEY `IDX_QRTZ_T_N_STATE` (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`,`TRIGGER_STATE`),
  KEY `IDX_QRTZ_T_N_G_STATE` (`SCHED_NAME`,`TRIGGER_GROUP`,`TRIGGER_STATE`),
  KEY `IDX_QRTZ_T_NEXT_FIRE_TIME` (`SCHED_NAME`,`NEXT_FIRE_TIME`),
  KEY `IDX_QRTZ_T_NFT_ST` (`SCHED_NAME`,`TRIGGER_STATE`,`NEXT_FIRE_TIME`),
  KEY `IDX_QRTZ_T_NFT_MISFIRE` (`SCHED_NAME`,`MISFIRE_INSTR`,`NEXT_FIRE_TIME`),
  KEY `IDX_QRTZ_T_NFT_ST_MISFIRE` (`SCHED_NAME`,`MISFIRE_INSTR`,`NEXT_FIRE_TIME`,`TRIGGER_STATE`),
  KEY `IDX_QRTZ_T_NFT_ST_MISFIRE_GRP` (`SCHED_NAME`,`MISFIRE_INSTR`,`NEXT_FIRE_TIME`,`TRIGGER_GROUP`,`TRIGGER_STATE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='�洢�����õ� Trigger ����Ϣ' /* `compression`='tokudb_zlib' */;


--
-- Table structure for table `server`
--

DROP TABLE IF EXISTS `server`;
CREATE TABLE `server` (
  `ip` varchar(16) NOT NULL COMMENT 'ip',
  `host` varchar(255) DEFAULT NULL COMMENT 'host',
  `nmon` varchar(255) DEFAULT NULL COMMENT 'nmon version',
  `cpus` tinyint(4) DEFAULT NULL COMMENT 'logic cpu num',
  `cpu_model` varchar(255) DEFAULT NULL COMMENT 'cpu �ͺ�',
  `dist` varchar(255) DEFAULT NULL COMMENT '���а���Ϣ',
  `kernel` varchar(255) DEFAULT NULL COMMENT '�ں���Ϣ',
  `ulimit` varchar(255) DEFAULT NULL COMMENT 'ulimit -n,ulimit -u',
  `updatetime` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `server_stat`
--

DROP TABLE IF EXISTS `server_stat`;
CREATE TABLE `server_stat` (
  `ip` varchar(16) NOT NULL COMMENT 'ip',
  `cdate` date NOT NULL COMMENT '�����ռ���',
  `ctime` char(4) NOT NULL COMMENT '�����ռ�Сʱ����',
  `cuser` float DEFAULT NULL COMMENT '�û�̬ռ��',
  `csys` float DEFAULT NULL COMMENT '�ں�̬ռ��',
  `cwio` float DEFAULT NULL COMMENT 'wioռ��',
  `c_ext` text COMMENT '��cpuռ��',
  `cload1` float DEFAULT NULL COMMENT '1����load',
  `cload5` float DEFAULT NULL COMMENT '5����load',
  `cload15` float DEFAULT NULL COMMENT '15����load',
  `mtotal` float DEFAULT NULL COMMENT '���ڴ�,��λM',
  `mfree` float DEFAULT NULL COMMENT '�����ڴ�',
  `mcache` float DEFAULT NULL COMMENT 'cache',
  `mbuffer` float DEFAULT NULL COMMENT 'buffer',
  `mswap` float DEFAULT NULL COMMENT 'cache',
  `mswap_free` float DEFAULT NULL COMMENT 'cache',
  `nin` float DEFAULT NULL COMMENT '���������� ��λK/s',
  `nout` float DEFAULT NULL COMMENT '��������� ��λk/s',
  `nin_ext` text COMMENT '����������������',
  `nout_ext` text COMMENT '����������������',
  `tuse` int(11) DEFAULT NULL COMMENT 'tcp estab������',
  `torphan` int(11) DEFAULT NULL COMMENT 'tcp orphan������',
  `twait` int(11) DEFAULT NULL COMMENT 'tcp time wait������',
  `dread` float DEFAULT NULL COMMENT '���̶����� ��λK/s',
  `dwrite` float DEFAULT NULL COMMENT '����д���� ��λK/s',
  `diops` float DEFAULT NULL COMMENT '����io���� ��������/s',
  `dbusy` float DEFAULT NULL COMMENT '����io����ʹ�ðٷֱ�',
  `d_ext` text COMMENT '���̸�����ռ��',
  `dspace` text COMMENT '���̸������ռ�ʹ����',
  PRIMARY KEY (`ip`,`cdate`,`ctime`),
  KEY `idx_cdate` (`cdate`),
  KEY `idx_cdate_ctime` (`cdate`,`ctime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `system_config`
--

DROP TABLE IF EXISTS `system_config`;
CREATE TABLE `system_config` (
  `config_key` varchar(255) NOT NULL COMMENT '����key',
  `config_value` varchar(512) NOT NULL COMMENT '����value',
  `info` varchar(255) NOT NULL COMMENT '����˵��',
  `status` tinyint(4) NOT NULL COMMENT '1:����,0:������',
  `order_id` int(11) NOT NULL COMMENT '˳��',
  PRIMARY KEY (`config_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='ϵͳ����';

-- ----------------------------
--  Records of `system_config`
-- ----------------------------
BEGIN;
INSERT INTO `system_config` VALUES ('cachecloud.admin.user.name','admin','cachecloud-admin�û���',1,11),('cachecloud.admin.user.password','admin','cachelcoud-admin����',1,12),('cachecloud.app.client.conn.threshold','2000','Ӧ��������������ֵ',1,33),('cachecloud.base.dir','/opt','cachecloud��Ŀ¼��Ҫ��cachecloud-init.sh�ű��е�Ŀ¼һ��',1,31),('cachecloud.contact','user1:(xx@zz.com, user1:135xxxxxxxx)<br/>user2: (user2@zz.com, user2:138xxxxxxxx)','ֵ����ϵ����Ϣ',1,14),('cachecloud.cookie.domain','','cookie��¼��ʽ����Ҫ������',1,22),('cachecloud.email.alert.interface','','�ʼ������ӿ�(�ο������ӿڹ淶)',1,24),('cachecloud.machine.ssh.name','cachecloud-open','����ssh�û���',1,2),('cachecloud.machine.ssh.password','cachecloud-open','����ssh����',1,3),('cachecloud.machine.ssh.port','22','����ssh�˿�',1,10),('cachecloud.machine.stats.cron.minute','1','��������ͳ������(����)',1,35),('cachecloud.nmon.dir','/opt/cachecloud','nmon��װĿ¼',1,32),('cachecloud.owner.email','xx@sohu.com,yy@qq.com','�ʼ�����(���Ÿ���)',1,21),('cachecloud.owner.phone','xxx,yyy','�ֻ��ű���(���Ÿ���)',1,21),('cachecloud.owner.weChat','xxx,yyy','΢�źű���(���Ÿ���)',1,21),('cachecloud.public.key.pem','/opt/ssh/id_rsa','��Կ·��',1,5),('cachecloud.public.user.name','cachecloud-open','��Կ�û���',1,4),('cachecloud.ssh.auth.type','1','ssh��Ȩ��ʽ',1,1),('cachecloud.superAdmin','admin,xx,yy','��������Ա��',1,13),('cachecloud.user.login.type','1','�û���¼״̬���淽ʽ(session��cookie)',1,22),('cachecloud.weChat.alert.interface','','΢�ű����ӿ�(�ο������ӿڹ淶)',1,23),('cachecloud.whether.schedule.clean.data','false','�Ƿ�������ͳ������',1,34),('machine.load.alert.ratio','8.0','�������ر�����ֵ',1,32);
COMMIT;

-- ----------------------------
--  Table structure for `system_resource`
-- ----------------------------
DROP TABLE IF EXISTS `system_resource`;
CREATE TABLE `system_resource` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '��ԴID',
  `name` varchar(64) NOT NULL COMMENT '��Դ����',
  `intro` varchar(255) DEFAULT NULL COMMENT '��Դ˵��',
  `type` tinyint(4) NOT NULL COMMENT '1:�ֿ��ַ 2:�ű� 3:��Դ�� 4:��Կ/˽Կ 6:Ŀ¼���� 7:Ǩ�ƹ��߹���',
  `lastmodify` datetime DEFAULT NULL COMMENT '������ʱ��',
  `dir` varchar(128) DEFAULT NULL COMMENT '��Դ·��',
  `url` varchar(128) DEFAULT NULL COMMENT '�ֿ��ַ',
  `ispush` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0:δ���� 1:������',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '0:��Ч 1:��Ч',
  `username` varchar(255) DEFAULT NULL COMMENT '����޸���',
  `task_id` bigint(11) DEFAULT NULL COMMENT 'Ǩ������id',
  `compile_info` varchar(255) DEFAULT NULL COMMENT '������Ϣ',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `system_resource`
-- ----------------------------
BEGIN;
INSERT INTO `system_resource` VALUES (1,'cachecloud-init.sh','������ʼ���ű�',2,'2020-07-15 18:35:41','/script','',0,1,NULL,NULL,NULL),(2,'x.x.x.x',NULL,1,'2020-08-10 10:31:51','/opt/download/software/cachecloud/resource','http://x.x.x.x/software/cachecloud/resource',0,1,'admin',0,NULL),(4,'cachecloud-env.sh','���������ű�',2,'2020-07-15 18:36:28','/script','',0,1,NULL,NULL,NULL),(5,'id_rsa','˽Կ�ļ�',4,'2020-07-07 10:45:39','/ssh','',0,1,NULL,NULL,NULL),(6,'id_rsa.pub','��Կ�ļ�',4,'2020-07-07 10:45:45','/ssh','',0,1,NULL,NULL,NULL),(12,'redis-4.0.14','redis 4.0.14��Դ��',3,'2020-08-10 09:52:41','/redis','http://download.redis.io/releases/redis-4.0.14.tar.gz',0,1,'admin',532,NULL),(21,'/script','�ű�Ŀ¼����',6,'2020-08-10 10:51:34','',NULL,0,1,'admin',0,NULL),(28,'/ssh','sshĿ¼',6,'2020-07-20 17:55:03',NULL,NULL,0,1,'admin',0,NULL),(29,'redis-3.0.7','redis3.0.7 ��Դ��',3,'2020-08-10 09:53:32','/redis','http://download.redis.io/releases/redis-3.0.7.tar.gz',0,1,'admin',529,NULL),(31,'redis-3.2.12','redis 3.2.12 ��Դ��',3,'2020-08-10 15:08:21','/redis','http://download.redis.io/releases/redis-3.2.12.tar.gz',0,1,'admin',530,NULL),(32,'/redis','redis��Դ������',6,'2020-07-20 17:54:59',NULL,NULL,0,1,'admin',0,NULL),(33,'/tool','Ǩ�ƹ�����Դ��',6,'2020-07-20 17:54:53',NULL,NULL,0,1,'admin',0,NULL),(37,'redis-5.0.9','redis5.0.9 ��Դ��',3,'2020-08-10 09:51:41','/redis','http://download.redis.io/releases/redis-5.0.9.tar.gz',0,1,'admin',533,NULL),(40,'redis-shake-2.0.3','redis 2.0.3\n�޸�fix 5.0Ǩ����������',7,'2020-08-11 10:53:26','/tool','https://github.com/alibaba/RedisShake/releases/download/release-v2.0.3-20200724/redis-shake-v2.0.3.tar.gz',0,1,'admin',518,NULL);
COMMIT;

--
-- Table structure for table `task_queue`
--

DROP TABLE IF EXISTS `task_queue`;
CREATE TABLE `task_queue` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `app_id` bigint(20) NOT NULL COMMENT 'Ӧ��id',
  `class_name` varchar(255) NOT NULL COMMENT '����',
  `important_info` varchar(255) NOT NULL DEFAULT '' COMMENT '��Ҫ��Ϣ',
  `execute_ip_port` varchar(255) DEFAULT '' COMMENT 'ִ�������ip:port',
  `param` longtext NOT NULL COMMENT '�������(json):��������仯',
  `init_param` longtext NOT NULL COMMENT '��ʼ���������(json):����',
  `status` tinyint(4) NOT NULL COMMENT '״̬��0�ȴ���1���У�2�жϣ�3ʧ��',
  `parent_task_id` bigint(20) NOT NULL COMMENT '������id',
  `create_time` datetime NOT NULL COMMENT '����ʱ��',
  `update_time` datetime NOT NULL COMMENT '�޸�ʱ��',
  `start_time` datetime NOT NULL COMMENT '��ʼʱ��',
  `end_time` datetime NOT NULL COMMENT '����ʱ��',
  `priority` int(11) NOT NULL COMMENT '���ȼ�',
  `error_code` int(11) NOT NULL COMMENT '�������',
  `error_msg` varchar(255) NOT NULL COMMENT '������Ϣ',
  `task_note` varchar(255) NOT NULL COMMENT '��ע',
  PRIMARY KEY (`id`),
  KEY `idx_app_id` (`app_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='�����';

--
-- Table structure for table `task_step_flow`
--

DROP TABLE IF EXISTS `task_step_flow`;
CREATE TABLE `task_step_flow` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `task_id` bigint(20) NOT NULL COMMENT '����id',
  `child_task_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '������id',
  `execute_ip_port` varchar(255) DEFAULT '' COMMENT 'ִ�������ip:port',
  `class_name` varchar(255) NOT NULL COMMENT '����',
  `step_name` varchar(255) NOT NULL COMMENT '������',
  `order_no` int(11) NOT NULL COMMENT '���',
  `status` tinyint(4) NOT NULL COMMENT '״̬��0δ��ʼ��1�ɹ���2�жϡ�3������4ʧ��',
  `log` text COMMENT '��־',
  `start_time` datetime NOT NULL COMMENT '��ʼʱ��',
  `end_time` datetime NOT NULL COMMENT '����ʱ��',
  `create_time` datetime NOT NULL COMMENT '����ʱ��',
  `update_time` datetime NOT NULL COMMENT '�޸�ʱ��',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_task_class_step` (`task_id`,`class_name`,`step_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='����������';

--
-- Table structure for table `task_step_meta`
--

DROP TABLE IF EXISTS `task_step_meta`;
CREATE TABLE `task_step_meta` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `class_name` varchar(255) NOT NULL COMMENT '����',
  `step_name` varchar(255) NOT NULL COMMENT '������',
  `step_desc` varchar(255) NOT NULL COMMENT '��������',
  `ops_device` varchar(255) NOT NULL COMMENT '��ά����',
  `timeout` int(11) NOT NULL COMMENT '��ʱʱ��',
  `create_time` datetime NOT NULL COMMENT '����ʱ��',
  `update_time` datetime NOT NULL COMMENT '�޸�ʱ��',
  `order_no` int(11) NOT NULL COMMENT '���',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_class_step` (`class_name`,`step_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='������Ԫ���ݱ�';
/*!40101 SET character_set_client = @saved_cs_client */;

-- ----------------------------
--  Table structure for `standard_statistics`
-- ----------------------------
DROP TABLE IF EXISTS `standard_statistics`;
CREATE TABLE `standard_statistics` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `collect_time` bigint(20) NOT NULL COMMENT '�ռ�ʱ��:��ʽyyyyMMddHHmm',
  `ip` varchar(16) NOT NULL COMMENT 'ip��ַ',
  `port` int(11) NOT NULL COMMENT '�˿�/hostId',
  `db_type` varchar(16) NOT NULL COMMENT '�ռ�����������',
  `info_json` text NOT NULL COMMENT '�ռ���json����',
  `diff_json` text NOT NULL COMMENT '��һ���ռ������json����',
  `created_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '����ʱ��',
  `cluster_info_json` varchar(20480) NOT NULL DEFAULT '' COMMENT '�ռ���cluster info json����',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_index` (`ip`,`port`,`db_type`,`collect_time`),
  KEY `idx_create_time` (`created_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

--
-- Table structure for table `app_alert_record`
--
DROP TABLE IF EXISTS `app_alert_record`;
CREATE TABLE `app_alert_record` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '����id',
  `visible_type` int(1) NOT NULL COMMENT '�ɼ����ͣ�0�����ɼ���1��������Ա�ɼ�����',
  `important_level` int(1) NOT NULL COMMENT '��Ҫ���ͣ�0��һ�㣻1����Ҫ��2��������',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `app_id` bigint(20) DEFAULT NULL COMMENT 'app id',
  `instance_id` bigint(20) DEFAULT NULL COMMENT 'ʵ��id',
  `ip` varchar(16) COLLATE utf8_bin DEFAULT NULL COMMENT '����ip',
  `port` int(10) DEFAULT NULL COMMENT '�˿ں�',
  `title` varchar(255) COLLATE utf8_bin NOT NULL COMMENT '��������',
  `content` varchar(500) COLLATE utf8_bin NOT NULL COMMENT '��������',
  PRIMARY KEY (`id`),
  KEY `app_id` (`app_id`),
  KEY `ip` (`ip`),
  KEY `idx_inst_id` (`instance_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='������¼��';

--
-- Table structure for table `config_restart_record`
--
DROP TABLE IF EXISTS `config_restart_record`;
CREATE TABLE `config_restart_record` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `app_id` bigint(20) NOT NULL COMMENT 'Ӧ��id',
  `app_name` varchar(36) NOT NULL COMMENT 'Ӧ������',
  `operate_type` char(1) NOT NULL COMMENT '�������ͣ�0:����������1:�޸�����ǿ��������2���޸����ã�',
  `param` varchar(2000) NOT NULL COMMENT '��ʼ���������(json):����',
  `status` tinyint(4) NOT NULL COMMENT '״̬��0�ȴ���1���У�2�ɹ���3ʧ�ܣ�4�����޸Ĵ�����',
  `start_time` datetime NOT NULL COMMENT '��ʼʱ��',
  `end_time` datetime NOT NULL COMMENT '����ʱ��',
  `create_time` datetime NOT NULL COMMENT '����ʱ��',
  `update_time` datetime NOT NULL COMMENT '�޸�ʱ��',
  `log` longtext COMMENT '��־��Ϣ',
  `user_name` varchar(64) DEFAULT NULL COMMENT '������Ա����',
  `user_id` bigint(20) NOT NULL COMMENT '�û�id',
  `instances` varchar(1000) DEFAULT NULL COMMENT '�漰ʵ��id�б��json��ʽ',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='������¼��';

--
-- Table structure for table `module_info`
--
DROP TABLE IF EXISTS `module_info`;
CREATE TABLE `module_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `git_url` varchar(255) NOT NULL DEFAULT '' COMMENT 'git resource',
  `info` varchar(128) DEFAULT NULL COMMENT 'ģ����Ϣ˵��',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '0:��Ч 1:��Ч',
  PRIMARY KEY (`id`),
  UNIQUE KEY `NAMEKEY` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Redisģ����Ϣ��';

--
-- Table structure for table `module_version`
--
DROP TABLE IF EXISTS `module_version`;
CREATE TABLE `module_version` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `module_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL COMMENT '�����汾��',
  `create_time` datetime DEFAULT NULL COMMENT '����ʱ��',
  `so_path` varchar(255) DEFAULT NULL COMMENT '�����so��ĵ�ַ',
  `tag` varchar(64) NOT NULL COMMENT 'ģ��汾��',
  `status` int(255) NOT NULL DEFAULT '0' COMMENT '�Ƿ����(����so��ַ)��0 ������ 1������',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Redisģ��汾�����';

--
-- Table structure for table `app_import`
--
DROP TABLE IF EXISTS `app_import`;
CREATE TABLE `app_import` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `app_id` bigint(20) DEFAULT NULL COMMENT 'Ŀ��Ӧ��id',
  `instance_info` text COMMENT 'Դredisʵ����Ϣ',
  `redis_password` varchar(200) DEFAULT NULL COMMENT 'Դredis����',
  `status` int(11) DEFAULT NULL COMMENT 'Ǩ��״̬��PREPARE(0, "׼��", "Ӧ�õ���-δ��ʼ"),     START(1, "������...", "Ӧ�õ���-��ʼ"),     ERROR(2, "error", "Ӧ�õ���-����"),     VERSION_BUILD_START(11, "������...", "�½�redis�汾-������"),     VERSION_BUILD_ERROR(12, "error", "�½�redis�汾-����"),     VERSION_BUILD_END(20, "�ɹ�", "�½�redis�汾-���"),     APP_BUILD_INIT(21, "׼������", "�½�redisӦ��-׼������"),     APP_BUILD_START(22, "������...", "�½�redisӦ��-������"),     APP_BUILD_ERROR(23, "error", "�½�redisӦ��-����"),     APP_BUILD_END(30, "�ɹ�", "�½�redisӦ��-���"),     MIGRATE_INIT(31, "׼������", "����Ǩ��-׼������"),     MIGRATE_START(32, "������...", "����Ǩ��-������"),     MIGRATE_ERROR(33, "error", "����Ǩ��-����"),     MIGRATE_END(3, "�ɹ�", "Ӧ�õ���-�ɹ�")',
  `step` int(11) DEFAULT NULL COMMENT '����׶�',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `migrate_id` bigint(20) DEFAULT NULL COMMENT '����Ǩ��id',
  `mem_size` int(11) DEFAULT NULL COMMENT 'Ŀ��Ӧ���ڴ��С����λG',
  `redis_version_name` varchar(20) DEFAULT NULL COMMENT 'Ŀ��Ӧ��redis�汾����ʽ��redis-x.x.x',
  `app_build_task_id` bigint(20) DEFAULT NULL COMMENT 'Ŀ��Ӧ�ò�������id',
  `source_type` int(11) DEFAULT NULL COMMENT 'Դredis���ͣ�7:cluster, 6:sentinel, 5:standalone',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;