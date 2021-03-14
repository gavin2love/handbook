# 首先确认网卡
	[root@localhost ]# ip a
# 定位配置文件
在上一步的一个命令中，我们使用 ip a 输出了网卡名称，现在我们可以定位它的配置文件位置（通常都在 **/etc/sysconfig/network-scripts/**目录中），配置文件通常都以 ifcfg-设备名称 的命名格式存在，譬如：

	[root@localhost ]# cd /etc/sysconfig/network-scripts/ && ls  
	[root@localhost ]# cat ifcfg-ens32  
输出结果：

	TYPE=Ethernet  
	BOOTPROTO=none  
	DEFROUTE=yes  
	IPV4_FAILURE_FATAL=no  
	IPV6INIT=yes  
	IPV6_AUTOCONF=yes  
	IPV6_DEFROUTE=yes  
	IPV6_FAILURE_FATAL=no  
	NAME=enp3s0  
	UUID=a007fd6d-4cc5-45b6-9a38-991a8e820eaf  
	DEVICE=enp3s0  
	ONBOOT=yes  
	IPADDR=10.0.0.2  
	PREFIX=29  
	GATEWAY=10.0.0.1  
	DNS1=8.8.8.8  
	DNS2=8.8.4.4  
	IPV6_PEERDNS=yes  
	IPV6_PEERROUTES=yes  
可以看到，目前网卡上绑定的IP是 10.0.0.2，它存在于一个 CIDR /29 的IP段中，这意味着10.0.0.3, 10.0.0.4, 10.0.0.5, 以及 10.0.0.6 也应该处于可用状态（如果你是从IDC处购得服务器，那么先确认服务商是分配给你了一个CIDR /29的IP段）。

# 绑定单个IP
如果你要添加绑定的IP数量较少，可以手动进行绑定。编辑网卡配置文件：

	[root@localhost ]# vi /etc/sysconfig/network-scripts/ifcfg-enp3s0  
	因为你的网卡本身已经绑定了一个IP：IPADDR=10.0.0.2你可以用以下方式添加这个CIDR段内的其他IP：
	
	IPADDR0=192.168.1.3  
	PREFIX0=29  
	  
	IPADDR1=192.168.1.4  
	PREFIX1=29  
	  
	IPADDR2=192.168.1.5  
	PREFIX2=29  
	  
	IPADDR3=192.168.1.6  
	PREFIX3=29
	重启服务器网络使其生效：
	
	[root@localhost]# systemctl restart network  
# 绑定IP段
首先我们需要对网卡配置文件做一个小小的调整：

	[root@localhost ]# vi /etc/sysconfig/network-scripts/ifcfg-enp3s0  
如果该文件中没有** NM_CONTROLLED=NO** 这一行，则将这一行加到文件的最底部，在CentOS 7中添加IP段绑定这是不可缺少的一步，接着我们创建IP段对应的配置文件：

	[root@localhost ]# vi /etc/sysconfig/network-scripts/ifcfg-enp3s0-range  
对于IP段的数量，系统并没有限制，如果你有多个IP段希望配置，则可以使用 ifcfg-enp3s0-range0, ifcfg-enp3s0-range1 这样的命名方式。添加以下内容到文件中：

	IPADDR_START=192.168.1.2 #起始IP
	IPADDR_END=192.168.1.254 #结束IP   
	PREFIX=24 #CIDR IP段标识   
	CLONENUM_START=0 #别名起始号  
如果你添加的IP段和你当前网卡绑定的IP不在一个段内，且不共用一个网关（Gateway），那么你还需要向文件中添加：

	GATEWAY=网关地址  
# 一切就绪之后，重启服务器网络：

	[root@localhost ]# systemctl restart network  