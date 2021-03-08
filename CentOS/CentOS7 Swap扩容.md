# 环境约束
* CentOS7 64

# 查看内存以及交换空间
	[root@localhost ~]# free -m
 查看内存以及交换空间

# 创建5G大小的文件【请读者根据实际需要设置大小】
	[root@localhost ~]#  dd if=/dev/zero of=/var/swapfile bs=1G count=5
 创建5G大小的文件

# 设置为swap虚拟交换文件
	[root@localhost ~]#  mkswap /var/swapfile
 设置为swap虚拟交换文件

# 激活并使用此交换文件
	[root@localhost ~]#  swapon /var/swapfile
 激活并使用此交换文件

# 设置系统启动自动激活虚拟交换文件
	[root@localhost ~]#  sudo tee -a /etc/fstab <<-EOF 
	/var/swapfile swap swap defaults 0 0 
	EOF
设置系统启动自动激活虚拟交换文件

# 再次查看内存以及交换空间
至此，我们完成了swap空间的扩容。