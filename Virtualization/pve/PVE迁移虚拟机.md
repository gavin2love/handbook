首先主机的硬盘一般都在这个目录，如果没用就用locate寻找系统盘。

	ls /var/lib/vz/images/
	# 返回的是所以虚拟机ID目录
现在我们需要将PVE主机A的qcow2虚拟机迁移到PVE主机B，

	scp /var/lib/vz/images/100/vm-100-disk-0.qcow2 root@192.168.1.1:/var/lib/vz/images/
传输完毕后，新建一个同类型虚拟机，记住新建的虚拟机ID「xxx」。在shell中删除新建虚拟机的硬盘。

	rm /var/lib/vz/images/xxx/vm-xxx-disk-0.qcow2
再将刚刚主机A转移过来的文件替换到上面的位置
	mv /var/lib/vz/images/vm-100-disk-0.qcow2 vm-xxx-disk-0.qcow2
其中xxx指虚拟机ID
开机测试

# PS 导入虚拟机

# 迁移导入kvm主机

创建虚拟机

	sudo qm create 104
导入磁盘

	sudo qm imp ortdisk 104 /kvm/disk/rancher-05.qcow2 kvm
