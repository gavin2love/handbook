# 一、ZABBIX概述
Zabbix是一个基于Web界面的分布式系统监控的企业级开源软件。可以监视各种系统与设备的参数，保障服务器及设备的安全运营。

##Zabbix的功能和特性：
1、安装与配置简单；
2、可视化web管理界面；
3、免费开源；
4、支持中文；
5、自动发现；
6、分布式监控；
7、实时绘图。

## Zabbix的架构：

1、Zabbix Server：负责接收Agent发送的报告信息，组织所有配置、数据和操作。
2、Database Storage：存储配置信息以及收集到的数据。
4、Web Interface：Zabbix的GUI 接口，通常与Server运行在同一台机器上。
5、Proxy：可选组件，常用于分布式监控环境中。
6、Agent：部署在被监控主机上，负责收集数据发送给Server。

## 工作流程：
Agent获取被监控端数据，发送给Server。
Server记录所接收到的数据，存储在Database中并按照策略进行相应操作。
如果是分布式，Server会将数据传送一份到上级Server中。
Web Interface将收集到的数据和操作信息显示给用户。

# 二、系统环境准备
	[root@ops-zabbix ~]# cat /etc/redhat-release 
	CentOS Linux release 7.6.1810 (Core) 
	1、防火墙及SELINUX关闭
	systemctl stop firewalld.service && systemctl disable firewalld.service
	sed -i '/SELINUX/s/enforcing/disabled/' /etc/selinux/config  && setenforce 0
	2、yum源配置
	yum -y install epel-release  wget
	cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak  
	wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo  
	wget -P /etc/yum.repos.d/ http://mirrors.aliyun.com/repo/epel-7.repo  
	yum clean all  
	yum makecache  
	三、zabbix安装
	1、yum源安装
	yum install http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm -y 
	yum install -y zabbix-server-mysql zabbix-web-mysql zabbix-agent mariadb-server
	2、启动mariadb数据库
	systemctl start mariadb.service
	systemctl enable mariadb.service
	3、创建数据库
	mysql -uroot -p
	{回车}
	create database zabbix character set utf8 collate utf8_bin;
	grant all privileges on zabbix.* to zabbix@localhost identified by 'zabbix';
	flush privileges;
	exit;
	4、初始数据导入
	zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz  |mysql -uroot zabbix
	{回车}
	四、zabbix配置
	1、编辑zabbix_server.conf
	grep  -n ^[a-Z]  /etc/zabbix/zabbix_server.conf
	38:LogFile=/var/log/zabbix/zabbix_server.log
	49:LogFileSize=0
	72:PidFile=/var/run/zabbix/zabbix_server.pid
	81:DBHost=localhost
	91:DBName=zabbix
	107:DBUser=zabbix
	115:DBPassword=zabbix
	287:SNMPTrapperFile=/var/log/snmptrap/snmptrap.log
	413:Timeout=4
	455:AlertScriptsPath=/usr/lib/zabbix/alertscripts
	465:ExternalScripts=/usr/lib/zabbix/externalscripts
	501:LogSlowQueries=3000
	2、启动zabbix server并设置开机启动
	systemctl enable zabbix-server
	systemctl start zabbix-server
	3、编辑Zabbix前端PHP配置,更改时区
	vim /etc/httpd/conf.d/zabbix.conf
	php_value date.timezone Asia/Shanghai
	4、启动httpd并设置开机启动
	systemctl start httpd
	systemctl enable httpd
	五、安装Zabbix Web
	1、浏览器访问,并进行安装
	http://172.16.8.210/zabbix/
