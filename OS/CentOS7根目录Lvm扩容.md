> 前提 ： 随着后期数据的逐渐增多或者客户要求。也可能是硬盘内有多余的分区资源未使用。本文不仅扩容根目录，也讲述如何挂在其他目录

# 最终效果如下：
* 单盘扩容根目录
* 多盘扩容根目录
* 单盘空间扩容根目录
首先我们先进入系统用 lsblk 和 df -h 查看磁盘分区情况：

lsblk命令也可以用于列出一个特定设备的拥有关系，同时也可以列出组和模式。可以通过命令来获取以下信息：

	 [root@localhost ~]# lsblk    
	NAME                      MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT    
	sr0                           11:0                    1   918M 0    rom      
	sda                          8:0                      0   500G  0    disk     
	├─sda2                   8:2                      0 239.5G  0    part     
	│ ├─centos-swap   253:1                  0    8G     0    lvm  [SWAP]    
	│ └─centos-root    253:0                  0 231.5G  0    lvm  /    
	└─sda1                   8:1                      0  500M   0     part /boot    
df -h 查看磁盘容量的使用情况

	[root@localhost ~]# df -h  
	Filesystem                                        Size  Used    Avail    Use%   Mounted on  
	devtmpfs                                          2.0G     0      2.0G     0%        /dev  
	tmpfs                                                2.0G     0      2.0G     0%         /dev/shm  
	tmpfs                                                2.0G  8.5M   2.0G      1%        /run  
	tmpfs                                                2.0G     0      2.0G      0%        /sys/fs/cgroup  
	/dev/mapper/centos-root                232G  4.4G  228G     2%        /  
	/dev/sda1                                         497M  171M  327M  35%      /boot  
	tmpfs                                                405M     0    405M     0%        /run/user/0  

上面的信息可以看出

有一个单盘( /dev/sda ) 500G,
划分了 ( /dev/sda1） 500M 给 /boot 启动分区
划分了 ( /dev/sda2 ） 231.5G 给根目录， 8G 给SWAP
硬盘还剩约500-240 ( 260G ) 未使用
接下来我们就来将剩下的空间全部扩容至根目录

# 首先添加磁盘分区，直接使用260G

	[root@localhost ~]# fdisk /dev/sda  
	欢迎使用 fdisk (util-linux 2.23.2)。  
	  
	更改将停留在内存中，直到您决定将更改写入磁盘。  
	使用写入命令前请三思。  
	  
	命令(输入 m 获取帮助)：n  
	Partition type:  
	   p   primary (2 primary, 0 extended, 2 free)  
	   e   extended  
	Select (default p): P  
	Using default response p  
	分区号 (3,4，默认 3)：回车  
	起始 扇区 (503316480-1048575999，默认为 503316480)：回车  
	将使用默认值 83886080  
	Last 扇区, +扇区 or +size{K,M,G} (503316480-1048575999，默认为 1048575999)：回车  
	分区 3 已设置为 Linux 类型，大小设为 260 GiB  
	  
	命令(输入 m 获取帮助)：w  
	The partition table has been altered!  
	  
	Calling ioctl() to re-read partition table.  
	  
	[root@localhost ~]# partprobe  
# 然后查看分区是否创建：

	[root@localhost ~]# lsblk        
	NAME                      MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT        
	sr0                           11:0                    1   918M 0    rom          
	sda                          8:0                      0   500G  0    disk         
	├─sda2                   8:2                      0 239.5G  0    part         
	│ ├─centos-swap   253:1                  0    8G     0    lvm  [SWAP]        
	│ └─centos-root    253:0                  0 231.5G  0    lvm  /        
	├─sda3                   8:3                      0   260G  0     part         #  看这里     
	└─sda1                   8:1                      0  500M   0    part /boot   
可以看到建立了一个260G的 sda3 分区。

# 开始扩容
创建物理卷：

	[root@localhost ~]# lvm  
	lvm> pvcreate /dev/sda3  
	  Physical volume "/dev/sda3" successfully created.  
	查看物理卷和卷组：
	
	[root@localhost ~]# lvm  
	lvm> pvdisplay  
	  --- Physical volume ---  
	  PV Name               /dev/sda2  
	  VG Name               centos  
	  PV Size               239.51 GiB / not usable 3.00 MiB  
	  Allocatable           yes (but full)  
	  PE Size               4.00 MiB  
	  Total PE              61314  
	  Free PE               0  
	  Allocated PE          61314  
	  PV UUID               QMHF0S-eOAL-0nAp-T1Ul-kiHS-V2hS-DdAWHS  
	     
	lvm> vgdisplay  
	  --- Volume group ---  
	  VG Name               centos  
	  System ID               
	  Format                lvm2  
	  Metadata Areas        1  
	  Metadata Sequence No  3  
	  VG Access             read/write  
	  VG Status             resizable  
	  MAX LV                0  
	  Cur LV                2  
	  Open LV               2  
	  Max PV                0  
	  Cur PV                1  
	  Act PV                1  
	  VG Size               <239.51 GiB  
	  PE Size               4.00 MiB  
	  Total PE              61314  
	  Alloc PE / Size       61314 / <239.51 GiB  
	  Free  PE / Size       0 / 0     
	  VG UUID               1dFUDJ-dbDI-LBRg-h0rq-QHQa-UG7I-HLHhUz  
将新创建的物理卷加入到卷组：

	lvm> vgextend centos /dev/sda3  
	  Physical volume "/dev/sda3" successfully created.  
	  Volume group "centos" successfully extended  
	lvm> vgdisplay  
	  --- Volume group ---  
	  VG Name               centos  
	  System ID               
	  Format                lvm2  
	  Metadata Areas        2  
	  Metadata Sequence No  4  
	  VG Access             read/write  
	  VG Status             resizable  
	  MAX LV                0  
	  Cur LV                2  
	  Open LV               2  
	  Max PV                0  
	  Cur PV                2  
	  Act PV                2  
	  VG Size               499.50 GiB  
	  PE Size               4.00 MiB  
	  Total PE              127873  
	  Alloc PE / Size       61314 / <239.51 GiB  
	  Free  PE / Size       66559 / <260.00 GiB  
	  VG UUID               1dFUDJ-dbDI-LBRg-h0rq-QHQa-UG7I-HLHhUz  
可以看到卷组的Free size 增加了

将卷组剩余空间(刚添加的260G)添加到逻辑卷/dev/centos/root :

	lvm> lvextend -l +100%FREE /dev/centos/root  
	  Size of logical volume centos/root changed from <231.51 GiB (59266 extents) to 491.50 GiB (125825 extents).  
	  Logical volume centos/root successfully resized.  
# 同步到文件系统
之前只是对逻辑卷扩容，还要同步到文件系统，实现对根目录的扩容。

	[root@localhost ~]# xfs_growfs /dev/centos/root  
""" 
 省略 
"""  
然后再查看挂载情况：

	[root@localhost ~]# df -h    
	Filesystem                                        Size  Used    Avail    Use%   Mounted on    
	devtmpfs                                          2.0G     0      2.0G     0%        /dev    
	tmpfs                                                2.0G     0      2.0G     0%         /dev/shm    
	tmpfs                                                2.0G  8.5M   2.0G      1%        /run    
	tmpfs                                                2.0G     0      2.0G      0%        /sys/fs/cgroup    
	/dev/mapper/centos-root                492G  4.4G  488G     1%        /    
	/dev/sda1                                         497M  171M  327M  35%      /boot    
	tmpfs                                                405M     0    405M     0%        /run/user/0    
Down , 单盘空间扩容根目录结束/

# 多盘扩容根目录
首先我们先进入系统用 lsblk 磁盘结构情况：

	[root@localhost ~]# lsblk      
	NAME                      MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT      
	sdb                          8:16   0               2T           0     disk   # 看这里  
	sr0                           11:0                    1   918M 0    rom        
	sda                          8:0                      0   240G  0    disk       
	├─sda2                   8:2                      0   239.5G  0    part       
	│ ├─centos-swap   253:1                  0    8G     0    lvm  [SWAP]      
	│ └─centos-root    253:0                  0   231.5G  0    lvm  /      
	└─sda1                   8:1                      0  500M   0     part /boot      
新插入的硬盘是一块2t空间 sdb

具体操作与上面一样。

以下省略800字