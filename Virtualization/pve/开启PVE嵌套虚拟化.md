# 检测pve虚拟系统是否支持虚拟化
PVE虚拟出来的vm系统的cpu,默认不支持vmx，即不支持嵌套虚拟化，在虚拟机中使用命令来验证：

	# egrep --color 'vmx|svm' /proc/cpuinfo
没有输出即不支持，否则会高亮显示vmx或者svm。
有时为了测试和学习，需要开启pve的嵌套虚拟化，以便能在其系统中安装类似esxi，hyper-v之类的虚拟化软件，就需要开启pve的嵌套虚拟化功能了。

# 开启嵌套虚拟化步骤：
1.开启pve主机的nested,关闭所有虚拟机
检查pve系统是否开启nested，运行命令：

	# cat /sys/module/kvm_intel/parameters/nested
	N
输出N，表示未开启，输出Y，表示已开启。
检查结果未开启，必须关闭所有的虚拟机系统，否则不能开启内核支持。

	# modprobe -r kvm_intel
	# modprobe kvm_intel nested=1
	# cat /sys/module/kvm_intel/parameters/nested
	Y
再次检查nested,输出Y，即为开启成功。
如果报错Module kvm_intel is in use，请检查你的虚拟机是否全部关闭。

2.设置系统启动后自动开启nested

	# echo "options kvm_intel nested=1" >> /etc/modprobe.d/modprobe.conf
这样系统重启会自动加载netsted，支持嵌套虚拟了。

3.设置虚拟系统vm的cpu类型为host

	# qm set <vmid> --cpu cputype=host
	例：qm set 101 --cpu cputype=host
也可以在图形界面设置：选择vm,“硬件”–“处理器”–“类型”–“host"
4.测试虚拟机系统是否已经开启了虚拟化
启动虚拟机，运行下面的命令：

	# egrep --color 'vmx|svm' /proc/cpuinfo
你会看到输出中有vmx或者svm的，表示此虚拟系统已经支持了虚拟化，如果是win系统，可以支持在win系统上安装其它的虚拟化软件了。