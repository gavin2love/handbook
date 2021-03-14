> 前言：
> 进入CentOS 7以后，网络方面变化比较大，例如eth0不见了，ifconfig不见了，其原因是网络服务全部都由NetworkManager管理了，下面记录下为客户添加端口聚合。

原先 ： Centos7 / RHEL 7 双网卡绑定 – teaming版，这个是一开始使用teaming来做端口聚合，所谓teaming技术就是把同一台服务器上的多个物理网卡通过软件绑定成一个虚拟的网卡，也就是说，对于外部网络而言，这台服务器只有一个可见的网卡。对于任何应用程序，以及本服务器所在的网络，这台服务器只有一个网络链接或者说只有一个可以访问的IP地址。  之所以要利用Teaming 技术，除了利用多网卡同时工作来提高网络速度以外，还有可以实现不同网卡之间的负载均衡（Load balancing）和网卡冗余（Fault tolerance）。

但是第二天客户反应服务器丢包严重。后来测试确实会出现这个问题。

于是，经过比对，Centos7的bonding聚合 成为了测试对象。Linux网卡bond的七种模式详解中，介绍了0-6中mode的具体工作模式，在我们这里聚合采用的是lacp模式也就是mode=4(802.3ad)(IEEE 802.3ad 动态链接聚合)，主要原因是我们也有交换机的权限。注意lacp模式需要接入交换机支持，下面会分为服务器侧和交换机侧两块配置。

# 环境准备：
* 服务器 ， Centos7 双万兆端口
* 华为 CE6851-48S6Q-HI 交换机

# 服务器配置( Centos7.6)

为什么要先做服务器呢。做完后会断网，所以先做服务器端，如果交换机配置成功则通网，若先配置交换机，在无法复制的kvm界面中配置服务器，比较累。

首先确定服务器现有的活动网络端口，和闲置的网络端口

	ip a   # 显示已有网卡
	ll /etc/sysconfig/network-scripts/ifcfg-*   # 显示网卡配置文件
你可以看到俩块内容，在已有网卡中，新端口ens224是UP状态，且无网卡配置文件


首先注册新增端口（若能看到配置文件，则下跳 开始配置网卡文件）

	nmcli con sh #查看网卡连接信息
将未知（NAME 和 DEVICE 的 值不一样 ，例一端是ens224，另一端不是ens224）端口删除

	nmcli con del 「uuid值」 
	例如 ：  
	nmcli con del c632055e-4a32-348b-8c87-5dae12f058c2
	## Connection '有线连接 1' ( XXXX ) successfully deleted. # 删除成功
再次创建新的连接并生成配置文件

	nmcli conn add type ethernet con-name 「端口名」 ifname 「端口名」
	例如 ：  
	nmcli conn add type ethernet con-name ens224 ifname ens224
	## Connection 'ens224' ( XXXXXX ) successfully added.  # 添加成功
	ll /etc/sysconfig/network-scripts/ifcfg-*   # 验证新端口是否生成配置文件
# 开始配置网卡文件
进入网卡配置文件的目录，做备份操作。防止因意外发生，无法及时回档。

	cd /etc/sysconfig/network-scripts/  # 进入目录
	cp ifcfg-ens192 ifcfg-ens192.back   # 备份文件
	cp ifcfg-ens224 ifcfg-ens224.back  # 备份文件
# bond方法 一
修改服务器的网络端口如下，注意ifcfg-ens192和ifcfg-ens224都要修改。

注意DEVICE和NAME 都要写上所在端口网卡的名字，例ens192

	[root@localhost ~]# cat /etc/sysconfig/network-scripts/ifcfg-ens192
	DEVICE=ens192
	NAME=ens192
	TYPE=Ethernet
	BOOTPROTO=none
	ONBOOT=yes
	MASTER=bond0
	SLAVE=yes
ifcfg-ens224 略

虚拟网卡bond0配置

	[root@localhost ~]# cat /etc/sysconfig/network-scripts/ifcfg-bond0
	DEVICE=bond0
	NAME=bond0
	Type=Bond
	BONDING_MASTER=yes
	IPADDR=此处填写IP
	PREFIX=24
	GATEWAY=此处填写网关
	BOOTPROTO=none
	ONBOOT=yes
	DNS1="8.8.8.8"
	DNS2="1.1.1.1"
	﻿BONDING_OPTS="mode=4 miimon=100 updelay=0 downdelay=0 xmit_hash_policy=layer3+4"
加载内核模块、重启服务器bond生效

	[root@localhost ~]# modprobe bonding && reboot



# bond方法 二 （推荐）
服务器侧配置

1、创建bond0口，其mode为lacp4。centos7不再使用mode=4这种表示方法了。如前所述，我们用bond，不用风骚的team driver。

	#nmcli connection add type bond con-name team0 ifname bond0 config '{"runner":{"name":"lacp"}}'
	nmcli connection add type bond con-name bond0 ifname bond0 mode 4
2、将2个万兆口ens192、ens224加到bond0里去

	#nmcli connection add type team-slave con-name bond0-port1 ifname ens192 master bond0
	#nmcli connection add type team-slave con-name bond0-port2 ifname ens224 master bond0
	nmcli connection add type bond-slave ifname ens192 master bond0
	nmcli connection add type bond-slave ifname ens224 master bond0
3、静态配置team0口地址、网关。 注意不要漏掉网关，否则跨网段就不能用啦。再吐槽一下HW的交换机，ping出去的时候源地址竟然不是根据网络最长匹配的，选择的是其他网段的源地址。

	nmcli connection modify bond0 ipv4.addresses '此处是IP/24' ipv4.gateway '此处是网关'
	nmcli connection modify bond0 ipv4.method manual
	nmcli connection up bond0
4、验证

	# ip addr show bond0
	25: bond0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP
	    link/ether 04:27:58:91:58:62 brd ff:ff:ff:ff:ff:ff
	    inet 此处是IP/24 brd x.x.x.255 scope global bond0
	       valid_lft forever preferred_lft forever
	    inet6 fe80::627:58ff:fe91:5862/64 scope link
	       valid_lft forever preferred_lft forever
	# ip route
	default via 此处是IP dev bond0
	IP所在网段/24 dev bond0  proto kernel  scope link  src 
	此处是IP  metric 350
> nmcli相比ifconfig特别好的一点是，其配置会下刷到网络的配置文件里去，不需要担心重启以后配置丢失的问题，亚克西。

# 交换机配置：
交换机使用的是CE6851-48S6Q-HI（双万兆聚合也是没谁了）。吐槽下华为交换机，比华三的交换机质量差太远了，无论是稳定性还是友好度。我甚至遇到过网卡必须要shutdown/undo shutdown才能UP的情况，就不用说进一个视图需要一分钟这种事情了。可是我们就是不能用H3C的交换机。

注意Eth-Trunk8口的mode为lacp-static

	[~HUAWEI-Eth-Trunk8]dis this
	#
	interface Eth-Trunk8
	 port default vlan 100
	 stp edged-port enable
	 mode lacp-static
	#
	return
	[~HUAWEI-10GE2/0/8]dis this
	#
	interface 10GE2/0/8
	 eth-trunk 8
	 device transceiver 10GBASE-FIBER
	#
	return
	[~HUAWEI-10GE2/0/28]dis this
	#
	interface 10GE2/0/28
	 eth-trunk 8
	 device transceiver 10GBASE-FIBER
	#
	return