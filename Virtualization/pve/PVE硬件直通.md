> PVE 直通：就是将硬件直接分给虚拟机，它和半虚拟化的区别就是，前者是专属，后者是共用，分组直通就是将设备硬件分拆分别分给不同的虚拟机，比如把网卡分给软路由，把硬盘分给群晖，把显卡分给win10，从而在PVE实现在多台设备的功能，并且性能等同物理机！为什么性能等同物理机呢？因为虚拟机得到的就是物理硬件，直通就是将物理硬件分配给虚拟机！所以在PVE直通就非常的重要了。

有的小伙伴问，为什么要做分组直通，因为PVE默认是绑在一起，直通的话就全部绑定了，比如核显和网卡绑定，不分组就无法分别直通，并造成错误，导致无法正常直通，所以必需要分组直通。

PVE虚拟机相对ESXI虚拟机来说直通网卡在5.2版本之前还是比较复杂的，但是5.3版本开始就加入了图形化的直通界面，大大提升了我们直通网卡的便捷性，但是还是不够那么的直观。

# Intel CPU
shell里面输入命令：

	nano /etc/default/grub
在里面找到：

	GRUB_CMDLINE_LINUX_DEFAULT="quiet"
然后修改为

	GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_iommu=on"
在更新一下

	update-grub
重启一下

	reboot
# AMD CPU
shell里面输入命令：

	nano /etc/default/grub
在里面找到：

	GRUB_CMDLINE_LINUX_DEFAULT="quiet"
然后修改为

	GRUB_CMDLINE_LINUX_DEFAULT="quiet amd_iommu=on""
重启一下

	reboot
# Proxmox 直通物理网卡
必须完成上面的步骤，检验其效果，用一下指令验证其有效性。

	dmesg | grep -e DMAR -e IOMMU
如果执行 dmesg | grep -e DMAR -e IOMMU 没有输出，则表明存在问题。极有可能是bios设置的问题，需要启动cpu的vt-x支持。对于amd类型的cpu， /etc/default/grub 文件对于修改为 GRUB_CMDLINE_LINUX_DEFAULT="quiet amd_iommu=on 。该项目还支持几个值，可根据情况增加。

新增模块。修改文件 /etc/modules 加入如下的行（默认为空）：

	vfio
	vfio_iommu_type1
	vfio_pci
	vfio_virqfd
查找网卡`IDlspci |grep net`

需要记住前面ID值

命令行登录系统，打开文件 /etc/pve/nodes/你的集群名称/qemu-server/虚拟机id.conf 其内容由上述操做所生成。一下项目必须手工添加。（PS：PVE6可以直接在虚拟机- 硬件处 添加）