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

CREATE TABLE `module_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `git_url` varchar(255) NOT NULL DEFAULT '' COMMENT 'git resource',
  `info` varchar(128) DEFAULT NULL COMMENT 'ģ����Ϣ˵��',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '0:��Ч 1:��Ч',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Redisģ����Ϣ��';

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

-- instance_alert_configs change
ALTER TABLE instance_alert_configs ADD important_level TINYINT(4) DEFAULT 0 NOT NULL COMMENT '��Ҫ�̶ȣ�0��һ�㣻1����Ҫ��2��������';

-- app_user change
ALTER TABLE app_user ADD password varchar(64) NULL COMMENT '����';
ALTER TABLE app_user ADD register_time DATETIME DEFAULT CURRENT_TIMESTAMP NULL COMMENT 'ע��ʱ��';
ALTER TABLE app_user ADD purpose varchar(255) NULL COMMENT 'ʹ��Ŀ��';
ALTER TABLE app_user ADD company varchar(255) NULL COMMENT '��˾����';

-- module_info change
ALTER TABLE module_info ADD CONSTRAINT `NAMEKEY` UNIQUE KEY (name);

-- app_desc change
ALTER TABLE app_desc ADD custom_password varchar(255) DEFAULT NULL COMMENT '�Զ�������';

-- redis_module_config definition

CREATE TABLE `redis_module_config` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `config_key` varchar(128) NOT NULL COMMENT '������',
  `config_value` varchar(512) NOT NULL COMMENT '����ֵ',
  `info` varchar(512) NOT NULL COMMENT '����˵��',
  `update_time` datetime NOT NULL COMMENT '����ʱ��',
  `type` mediumint(9) NOT NULL COMMENT '���ͣ�2.cluster�ڵ���������, 5:sentinel�ڵ�����, 6:redis��ͨ�ڵ�',
  `status` tinyint(4) NOT NULL COMMENT '1��Ч,0��Ч',
  `version_id` int(11) NOT NULL COMMENT 'Module version�汾������id',
  `refresh` tinyint(4) DEFAULT '0' COMMENT '�Ƿ�����ã�0���ɣ�1������',
  `module_id` int(11) NOT NULL DEFAULT '7' COMMENT 'Module ��Ϣ��id',
  `config_type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '�������ͣ�0�����غ��������ã�1������ʱ���ã�2������ʱ����',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_configkey_type_version_id` (`config_key`,`type`,`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='redisģ�����ñ�';


-- app_to_module definition

CREATE TABLE `app_to_module` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '����',
  `app_id` bigint(20) NOT NULL COMMENT 'Ӧ��id',
  `module_id` int(11) NOT NULL COMMENT 'ģ��info id',
  `module_version_id` int(11) NOT NULL COMMENT 'ģ��汾id',
  PRIMARY KEY (`id`),
  UNIQUE KEY `app_to_module_un` (`app_id`,`module_id`,`module_version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Ӧ����ģ���ϵ��';

ALTER TABLE machine_info ADD dis_type tinyint(4) DEFAULT 0 NOT NULL COMMENT '����ϵͳ���а汾��0:centos;1:ubuntu';

