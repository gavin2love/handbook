## Ansible提供了一个命令行工具，在官方文档中起给命令行起了一个名字叫Ad-Hoc Commands。

ansible命令的格式是：

	ansible <host-pattern> [options]
	
# 检查ansible安装环境
检查所有的远程主机，是否以bruce用户创建了ansible主机可以访问的环境。

	ansible all -m ping

# 执行命令
在所有的远程主机上，以当前bash的同名用户，在远程主机执行'echo bash'

	ansible all -a "/bin/echo hello"
	
# 拷贝文件
拷贝文件/etc/host到远程主机（组）web，位置为/tmp/hosts

	ansible web -m copy -a "src=/etc/hosts dest=/tmp/hosts owner=root group=root mode=644 backup=yes"


# 安装包
远程主机（组）web安装yum包acme

	- name: 安装最新版本的apache
	  ansible web -m yum -a 'name=httpd state=latest'

	- name: 移除apache
	  ansible web -m yum -a 'name=httpd state=absent'

	- name: 安装一个特殊版本的apache
	  ansible web -m yum -a 'name=httpd-2.2.29-1.4.amzn1 state=present'

	- name: 升级所有的软件包
	  ansible web -m yum -a 'name=* state=latest'

	- name: 从一个远程yum仓库安装nginx
	  ansible web -m yum -a 'name=http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm state=present'

	- name: 从本地仓库安装nginx
	  ansible web -m yum -a 'name=/usr/local/src/nginx-release-centos-6-0.el6.ngx.noarch.rpm state=present'

	- name: 安装整个Development tools相关的软件包
	  ansible web -m yum -a 'name="@Development tools" state=present'

# 添加用户

	ansible all -m user -a "name=foo password=foo_PAWD"

# 下载git包

	# 执行此模块的主机需要满足  git> = 1.7.1
	ansible web -m git -a "repo=git://foo.example.org/repo.git dest=/srv/myapp version=HEAD"

# 启动服务

	ansible 通过systemd模块，可以对服务的是否开机启动进行配置，详细过程参考如下：

	-deamon_reload 重新载入systemd
	-enabled 开机是否启动
	-name 必选项
	-state (reloaded、restarted、started、stopped)

	刷新服务
	ansible web -m systemd -a "daemon_reload=yes"

	启动服务并开机启动
	ansible web -m systemd -a "name=httpd enabled=yes state=started"

	停止服务 开机禁止启动
	ansible web -m systemd -a "name=httpd enabled=no state=stopped"

	重启服务
	ansible web -m systemd -a "name=httpd state=restarted"


# 并行执行
启动10个并行进行执行重起

	ansible lb -a "/sbin/reboot" -f 10

# 查看远程主机的全部系统信息
	
	ansible all -m setup
