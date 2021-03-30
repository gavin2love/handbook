# 设置主机名

	hostnamectl set-hostname GitlabServer

#禁用selinux

	sed -i '/SELINUX/s/enforcing/disabled/' /etc/selinux/config  && setenforce 0  
#建立源

	cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
	curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
	sed -i -e '/mirrors.cloud.aliyuncs.com/d' -e '/mirrors.aliyuncs.com/d' /etc/yum.repos.d/CentOS-Base.repo
	yum -y install epel-release wget vim unzip mlocate
	mv /etc/yum.repos.d/epel.repo /etc/yum.repos.d/epel.repo.backup
	mv /etc/yum.repos.d/epel-testing.repo /etc/yum.repos.d/epel-testing.repo.backup
	curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
	yum clean all && yum makecache


# 安装并配置必要的依赖项
在CentOS 7上，下面的命令还将在系统防火墙中打开HTTP、HTTPS和SSH访问。

	yum install -y curl policycoreutils-python openssh-server openssh-clients perl postfix
	systemctl enable sshd && systemctl start sshd
	systemctl enable postfix && systemctl start postfix

	firewall-cmd --permanent --add-service=http
	firewall-cmd --permanent --add-service=https
	systemctl reload firewalld


# 导入清华源

	cat <<EOF > /etc/yum.repos.d/gitlab-ce.repo
	[gitlab-ce]
	name=Gitlab CE Repository
	baseurl=https://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/yum/el\$releasever/
	gpgcheck=0
	enabled=1
	EOF

	yum makecache &&  yum install -y gitlab-ce

# 修改配置

	vi /etc/gitlab/gitlab.rb
## 将external_url 'http://gitlab.example.com' 地址修改成服务器的ip


# 加载配置并重启gitlab

首次启动也需要以下命令加载配置，完成初始化

	gitlab-ctl reconfigure

## 重启gitlab

	gitlab-ctl restart


附上常用gitlab服务指令

	gitlab-ctl reconfigure                            # 重新编译配置
	gitlab-ctl start                                  # 启动
	gitlab-ctl stop                                   # 停止
	gitlab-ctl restart                                # 重启
	gitlab-ctl status                                 # 查看状态
	vim /etc/gitlab/gitlab.rb                         # 修改配置
	gitlab-rake gitlab:check SANITIZE=true --trace    # 检查gitlab
	gitlab-ctl tail                                   # 查看日志
	gitlab-ctl tail nginx/gitlab_access.log
3.如果需要更改默认的80端口号

有时候服务器已有nginx，所以gitlab的自带的nginx端口号冲突，需要修改端口号，编辑配置文件，添加如下配置：

	# 禁用内置NG
	nginx['enable'] = false
	# 指定NG的用户名
	web_server['external_users'] = ['nginx']
	#  添加NG地址到信任列表，我这里就是本机地址
	gitlab_rails['trusted_proxies'] = ['127.0.0.1']
	# 配置监听网络：tcp
	gitlab_workhorse['listen_network'] = "tcp"
	# 配置地址和端口
	gitlab_workhorse['listen_addr'] = "192.168.11.20:8888"
加载配置，再重新启动，重复上面步骤三
