# 禁用selinux
	sed -i '/SELINUX/s/enforcing/disabled/' /etc/selinux/config && setenforce 0
# 建立源
	cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
	curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
	yum -y install epel-release wget vim unzip
	mv /etc/yum.repos.d/epel.repo /etc/yum.repos.d/epel.repo.backup
	mv /etc/yum.repos.d/epel-testing.repo /etc/yum.repos.d/epel-testing.repo.backup
	curl -o /etc/yum.repos.d/epel.repo https://mirrors.aliyun.com/repo/epel-7.repo
# 重建软件源缓存
	yum clean all
	yum makecache
# 配置Grafana源
	cat <<EOF > /etc/yum.repos.d/grafana.repo
	[grafana]
	name=grafana
	baseurl=https://packages.grafana.com/oss/rpm
	repo_gpgcheck=1
	enabled=1
	gpgcheck=1
	gpgkey=https://packages.grafana.com/gpg.key
	sslverify=1
	sslcacert=/etc/pki/tls/certs/ca-bundle.crt
	EOF
# 安装配置Grafana
	yum install grafana -y
# 开机启动 运行
	sudo systemctl enable grafana-server && systemctl start grafana-server
# 重启
	systemctl restart grafana-server
# 防火墙放行
	firewall-cmd --zone=public --add-port=3000/tcp --permanent
	firewall-cmd --reload
默认的HTTP端口是 3000，默认的用户和组是admin

默认登录名和密码admin / admin

# Nginx反向代理
	proxy_pass http://192.168.1.2:3000;
	proxy_set_header   Host $host;
# 安装zabbix插件
	grafana-cli plugins install alexanderzobnin-zabbix-app
	service grafana-server restart