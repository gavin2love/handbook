# 查看系统可用内核

	[root@bigapp-slave27 ~]# cat /boot/grub2/grub.cfg |grep menuentry  
	""" 省略 """  
	menuentry 'CentOS Linux (3.10.0-514.16.1.el7.x86_64) 7 (Core)' -- """ 省略 """  
	menuentry 'CentOS Linux (3.10.0-327.el7.x86_64) 7 (Core)' -- """ 省略 """   
	menuentry 'CentOS Linux (0-rescue-d57307c454c0437d91c309347178cdf5) 7 (Core)' -- """ 省略 """  
	  
	""" 省略 """  
#查看当前内核
	[root@bigapp-slave27 ~]# uname -r
	3.10.0-514.16.1.el7.x86_64  
#修改开机时默认使用的内核
	grub2-set-default 'CentOS Linux (3.10.0-327.el7.x86_64) 7 (Core)'  
#查看内核修改结果
	[root@bigapp-slave27 ~]# grub2-editenv list  
	saved_entry=CentOS Linux (3.10.0-327.el7.x86_64) 7 (Core)
#查看系统安装了哪些内核包
	[root@bigapp-slave27 ~]# rpm -qa |grep kernel  
	kernel-3.10.0-327.el7.x86_64
	kernel-headers-3.10.0-514.6.1.el7.x86_64
	kernel-tools-libs-3.10.0-327.el7.x86_64
	kernel-3.10.0-514.16.1.el7.x86_64
	kernel-tools-3.10.0-327.el7.x86_64
#使用yum remove 或rpm -e 删除无用内核
	yum remove kernel-3.10.0-327.el7.x86_64  