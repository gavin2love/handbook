# 环境准备
- CentOS7 4C4G 192.168.31.179 Master
- CentOS7 4C4G 192.168.31.248 node01
- CentOS7 4C4G 192.168.31.18  node02

# 设置主机名

	hostnamectl set-hostname Ansible-Master
	hostnamectl set-hostname Ansible-Node01
	hostnamectl set-hostname Ansible-Node02

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

# 安装Ansible 2.9.*

	yum -y install ansible python-argcomplete
	
# 确认安装版本

	[root@ansible-master ~]# ansible --version
	ansible 2.9.18
	  config file = /etc/ansible/ansible.cfg
	  configured module search path = [u'/root/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
	  ansible python module location = /usr/lib/python2.7/site-packages/ansible
	  executable location = /usr/bin/ansible
	  python version = 2.7.5 (default, Oct 14 2020, 14:45:30) [GCC 4.8.5 20150623 (Red Hat 4.8.5-44)]


# 常用路径

	/etc/ansible/hosts  # 主机清单
	/etc/ansible/ansible.cfg  # ansible配置文件
	
	# ansible配置文件存在优先级的问题
	ANSIBLE_CONFIG                       #环境变量
	ansible.cfg                       #项目目录
	.ansible.cfg                      #当前用户的家目录
	/etc/ansible/ansible.cfg                 #默认配置文件 
	#由上到下优先级逐渐降低

# 基本设置

	vim  /etc/ansible/ansible.cfg
	[defaults]
	inventory      	  = /etc/ansible/hosts		#定义主机组文件
	host_key_checking = False					#登录免‘yes’验证
	
	vim /etc/ansible/hosts
	[web]
	192.168.31.18
	192.168.31.248
	
	# 上面2个文件是默认全局， 可在当前路径下新建独立的配置文件和主机清单 
	
	# 主机清单常用参数
	ansible_ssh_host
	将要连接的远程主机名.与你想要设定的主机的别名不同的话,可通过此变量设置.

	ansible_ssh_port
	ssh端口号.如果不是默认的端口号,通过此变量设置.

	ansible_ssh_user
	默认的 ssh 用户名

	ansible_ssh_pass
	ssh 密码(这种方式并不安全,我们强烈建议使用 --ask-pass 或 SSH 密钥)

	ansible_sudo_pass
	sudo 密码(这种方式并不安全,我们强烈建议使用 --ask-sudo-pass)

	ansible_sudo_exe (new in version 1.8)
	sudo 命令路径(适用于1.8及以上版本)

	ansible_connection
	与主机的连接类型.比如:local, ssh 或者 paramiko. Ansible 1.2 以前默认使用 paramiko.1.2 以后默认使用 'smart','smart' 方式会根据是否支持 ControlPersist, 来判断'ssh' 方式是否可行.

	ansible_ssh_private_key_file
	ssh 使用的私钥文件.适用于有多个密钥,而你不想使用 SSH 代理的情况.

	ansible_shell_type
	目标系统的shell类型.默认情况下,命令的执行使用 'sh' 语法,可设置为 'csh' 或 'fish'.

	ansible_python_interpreter
	目标主机的 python 路径.适用于的情况: 系统中有多个 Python, 或者命令路径不是"/usr/bin/python",比如  \*BSD, 或者 /usr/bin/python
	不是 2.X 版本的 Python.我们不使用 "/usr/bin/env" 机制,因为这要求远程用户的路径设置正确,且要求 "python" 可执行程序名不可为 python以外的名字(实际有可能名为python26).


# 密钥对验证
## 生成密钥

    ###  ssh-keygen		默认生成：id_rsa  id_rsa.pub
    ssh-keygen -t rsa -f  /root/.ssh/ansible		# ssh-keygen生成密钥对 -f自定义名称，一路回车即可
    
    ls  /root/.ssh
    	ansible 私钥	  ansible.pub 公钥

## 将公钥上传给受控服务器

    ssh-copy-id -i /root/.ssh/ansible.pub root@192.168.31.248
    ssh-copy-id -i /root/.ssh/ansible.pub root@192.168.31.18

## 验证免密登录

    ssh root@192.168.31.248 -i /root/.ssh/ansible		# ssh免密登录，因为名称不是默认，-i指定 -p加端口
    ssh root@192.168.31.18 -i /root/.ssh/ansible		
    
    vim   /etc/ansible/hosts
    	... ...
	[all:vars]
	ansible_ssh_private_key_file="/root/.ssh/ansible"	# 指定所用私钥
	
# 测试,无需输入密码：

	# ansible  all -m  ping
	ansible  web -m  ping
	ansible  web -m  shell -a  'df -h'
	ansible  web -m  shell -a  'w'
	
