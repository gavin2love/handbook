# su - root 切换root权限
# 安装源
	wget https://mirrors.aliyun.com/zabbix/zabbix/5.0/debian/pool/main/z/zabbix-release/zabbix-release_5.0-1%2Bbuster_all.deb
	dpkg -i zabbix-release_5.0-1+buster_all.deb
	apt update
# 安装探针
	apt install -y zabbix-agent
	vim /etc/zabbix/zabbix_agentd.conf
## 生成随机码
	openssl rand -hex 32  > /etc/zabbix/zabbix_proxy.psk
## 配置agent2文件
	vim /etc/zabbix/zabbix_agentd.conf
	Server=xxxxxx
	ServerActive=xxxxx
	Hostname=xxxxx
	TLSConnect=psk
	TLSAccept=psk
	TLSPSKFile=/etc/zabbix/zabbix_proxy.psk
	TLSPSKIdentity=xxxxxx
# 启动并启用Zabbix代理
	systemctl enable zabbix-agent && systemctl start zabbix-agent
如果正在运行ufw防火墙，请如下所示允许必要的端口

	ufw allow 10050
	ufw reload
### 重启配置
	systemctl restart zabbix-agent
	cat /etc/zabbix/zabbix_proxy.psk && cat /etc/hostname