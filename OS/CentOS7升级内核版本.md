# 1、YUM升级内核
1. 更新仓库

		yum -y update

2. 用 ELRepo 仓库

		rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
		rpm -Uvh https://www.elrepo.org/elrepo-release-7.el7.elrepo.noarch.rpm
		# 国内阿里源
		sed -i 's%mirrorlist=%#mirrorlist=%' /etc/yum.repos.d/elrepo.repo
		sed -i 's%http://elrepo.org/linux%https://mirrors.aliyun.com/elrepo%' /etc/yum.repos.d/elrepo.repo
		yum clean all && yum makecache

				  

3. 查看可用的系统内核包(能够看到，只有 5.4 和 5.11 两个版本能够使用)

		[root@localhost ~]# yum --disablerepo="*" --enablerepo="elrepo-kernel" list available
		已加载插件：fastestmirror
		Loading mirror speeds from cached hostfile
		 * elrepo-kernel: hkg.mirror.rackspace.com
		elrepo-kernel                                                                                                                                      | 3.0 kB  00:00:00     
		elrepo-kernel/primary_db                                                                                                                           | 2.0 MB  00:00:00     
		可安装的软件包
		elrepo-release.noarch                                                                7.0-5.el7.elrepo                                                        elrepo-kernel
		kernel-lt.x86_64                                                                     5.4.107-1.el7.elrepo                                                    elrepo-kernel
		kernel-lt-devel.x86_64                                                               5.4.107-1.el7.elrepo                                                    elrepo-kernel
		kernel-lt-doc.noarch                                                                 5.4.107-1.el7.elrepo                                                    elrepo-kernel
		kernel-lt-headers.x86_64                                                             5.4.107-1.el7.elrepo                                                    elrepo-kernel
		kernel-lt-tools.x86_64                                                               5.4.107-1.el7.elrepo                                                    elrepo-kernel
		kernel-lt-tools-libs.x86_64                                                          5.4.107-1.el7.elrepo                                                    elrepo-kernel
		kernel-lt-tools-libs-devel.x86_64                                                    5.4.107-1.el7.elrepo                                                    elrepo-kernel
		kernel-ml.x86_64                                                                     5.11.8-1.el7.elrepo                                                     elrepo-kernel
		kernel-ml-devel.x86_64                                                               5.11.8-1.el7.elrepo                                                     elrepo-kernel
		kernel-ml-doc.noarch                                                                 5.11.8-1.el7.elrepo                                                     elrepo-kernel
		kernel-ml-headers.x86_64                                                             5.11.8-1.el7.elrepo                                                     elrepo-kernel
		kernel-ml-tools.x86_64                                                               5.11.8-1.el7.elrepo                                                     elrepo-kernel
		kernel-ml-tools-libs.x86_64                                                          5.11.8-1.el7.elrepo                                                     elrepo-kernel
		kernel-ml-tools-libs-devel.x86_64                                                    5.11.8-1.el7.elrepo                                                     elrepo-kernel
		perf.x86_64                                                                          5.11.8-1.el7.elrepo                                                     elrepo-kernel
		python-perf.x86_64                                                                   5.11.8-1.el7.elrepo                                                     elrepo-kernel		
4. 安装最新内核

		yum --enablerepo=elrepo-kernel install -y kernel-ml
		
5.  查看系统上的全部能够内核

		[root@localhost ~]# awk -F\' '$1=="menuentry " {print i++ " : " $2}' /etc/grub2.cfg
		0 : CentOS Linux (5.11.8-1.el7.elrepo.x86_64) 7 (Core)
		1 : CentOS Linux (3.10.0-1160.21.1.el7.x86_64) 7 (Core)
		2 : CentOS Linux (3.10.0-1160.el7.x86_64) 7 (Core)
		3 : CentOS Linux (0-rescue-3772870909ce461aa12e89a0abb3d8a5) 7 (Core)
	
6. 设置 grub2,并生成grub配置文件

		[root@localhost ~]# grub2-set-default 0
		[root@localhost ~]# grub2-mkconfig -o /boot/grub2/grub.cfg
		Generating grub configuration file ...
		Found linux image: /boot/vmlinuz-5.11.8-1.el7.elrepo.x86_64
		Found initrd image: /boot/initramfs-5.11.8-1.el7.elrepo.x86_64.img
		Found linux image: /boot/vmlinuz-3.10.0-1160.21.1.el7.x86_64
		Found initrd image: /boot/initramfs-3.10.0-1160.21.1.el7.x86_64.img
		Found linux image: /boot/vmlinuz-3.10.0-1160.el7.x86_64
		Found initrd image: /boot/initramfs-3.10.0-1160.el7.x86_64.img
		Found linux image: /boot/vmlinuz-0-rescue-3772870909ce461aa12e89a0abb3d8a5
		Found initrd image: /boot/initramfs-0-rescue-3772870909ce461aa12e89a0abb3d8a5.img
		done

7. 重启并查看当前内核

		[root@localhost ~]# reboot
		[root@localhost ~]# uname -r
		5.11.8-1.el7.elrepo.x86_64


# 离线RPM包安装内核
1. 下载RPM包python

	> https://elrepo.org/linux/kernel/el7/x86_64/RPMS/ #选择本身想要的版本下载对应的


		wget https://mirrors.aliyun.com/elrepo/kernel/el7/x86_64/RPMS/kernel-ml-5.11.8-1.el7.elrepo.x86_64.rpm
		wget https://mirrors.aliyun.com/elrepo/kernel/el7/x86_64/RPMS/kernel-ml-devel-5.11.8-1.el7.elrepo.x86_64.rpm
		wget https://mirrors.aliyun.com/elrepo/kernel/el7/x86_64/RPMS/kernel-ml-headers-5.11.8-1.el7.elrepo.x86_64.rpm


2. 安装RPM包centos

		yum localinstall -y kernel-ml-5.11.8-1.el7.elrepo.x86_64.rpm kernel-ml-devel-5.11.8-1.el7.elrepo.x86_64.rpm kernel-ml-headers-5.11.8-1.el7.elrepo.x86_64.rpm

3. 查看当前系统上的全部可用内核启动项spa

	非 UEFI 设备（Legacy）：
	
		[root@localhost ~]# awk -F\' '$1=="menuentry " {print i++ " : " $2}' /etc/grub2.cfg
		0 : CentOS Linux (5.11.8-1.el7.elrepo.x86_64) 7 (Core)
		1 : CentOS Linux (3.10.0-1160.el7.x86_64) 7 (Core)
		2 : CentOS Linux (0-rescue-3772870909ce461aa12e89a0abb3d8a5) 7 (Core)
	UEFI 设备（Legacy）：
	
		[root@localhost ~]#  awk -F\' '$1=="menuentry " {print i++ " : " $2}'  /boot/efi/EFI/centos/grub.cfg 
		0 : CentOS Linux (5.11.8-1.el7.elrepo.x86_64) 7 (Core)
		1 : CentOS Linux (3.10.0-1160.el7.x86_64) 7 (Core)
		2 : CentOS Linux (0-rescue-3772870909ce461aa12e89a0abb3d8a5) 7 (Core)

	> 	注意文件名称

4. 修改默认启动项.net

默认启动项由/etc/default/grub中的GRUB_DEFAULT控制。插件

若是GRUB_DEFAULT=saved，则该参数将存储在/boot/grub2/grubenv中。可以使用grub2-editenv list查看

	[root@localhost ~]# grub2-editenv list
	saved_entry=CentOS Linux (3.10.0-1160.el7.x86_64) 7 (Core)
经过grub2-set-default命令修改默认启动项。由以前的输出可知 CentOS Linux (4.4.206-1.el7.elrepo.x86_64) 7 (Core) 的启动序号为0blog

1).经过启动序号设置5.11.8-1.el7.elrepo.x86_64.x86_64为默认启动内核get

[root@localhost ~]# grub2-editenv list
saved_entry=0  #0为4.4内核启动序号
重启并查看内核版本it

	[root@localhost ~]# reboot
	[root@localhost ~]# uname -r
	5.11.8-1.el7.elrepo.x86_64
2).经过内核名称设置5.11.8-1.el7.elrepo.x86_64为默认启动内核

# 恢复至3.10内核

	[root@localhost ~]# grep "^menuentry"  /boot/grub2/grub.cfg
	[root@localhost ~]# grub2-set-default 1
	[root@localhost ~]# grub2-editenv list
	saved_entry=1
	[root@localhost ~]# reboot
	[root@localhost ~]# uname -r
	3.10.0-862.el7.x86_64
经过内核名称设置4.4.205-1.el7.elrepo.x86_64为默认启动内核

	[root@localhost ~]# grub2-set-default "CentOS Linux (5.11.8-1.el7.elrepo.x86_64) 7 (Core)"
	[root@localhost ~]# grub2-editenv list
	saved_entry=CentOS Linux (5.11.8-1.el7.elrepo.x86_64) 7 (Core)
重启查看内核版本

	[root@localhost ~]# reboot
	[root@localhost ~]# uname -r
	5.11.8-1.el7.elrepo.x86_64

# 开启BBr
执行 lsmod | grep bbr，如果结果中没有 tcp_bbr 的话就先执行以下代码

	modprobe tcp_bbr
	echo "tcp_bbr" >> /etc/modules-load.d/modules.conf
	echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
	echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
	sysctl -p

观察BBR是否开启成功，执行以下代码：

	sysctl net.ipv4.tcp_available_congestion_control
	sysctl net.ipv4.tcp_congestion_control

如果结果都有**bbr**, 则证明你的内核已开启bbr
看到有 **tcp_bbr** 模块即说明bbr已启动