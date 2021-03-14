学校实验室有台服务器申请了固定的公网IP，能连接外部网络，同时该机器和其它几台内部服务器连接在一个路由器上。需要将该服务器的网络共享给其它内网服务器。进行如下设置即可。

首先，外网服务器有两根网线连接，一根和外网相连，一根和内网路由器相连。在外网服务器进行NAT转发设置：

# 第一种方法：
开启NAT转发

	firewall-cmd --permanent --zone=public --add-masquerade
开放DNS使用的53端口，否则可能导致内网服务器虽然设置正确的DNS，但是依然无法进行域名解析。

	firewall-cmd --zone=public --add-port=53/tcp --permanent
重启防火墙

	systemctl restart firewalld.service
检查是否允许NAT转发

	firewall-cmd --query-masquerade
关闭NAT转发

	firewall-cmd --remove-masquerade
# 第二种方法：
开启ip_forward转发 ，在/etc/sysctl.conf配置文件尾部添加

	net.ipv4.ip_forward=1
然后让其生效

	sysctl -p
执行firewalld命令进行转发：

	firewall-cmd --permanent --direct --passthrough ipv4 -t nat -I 	POSTROUTING -o enoxxxxxx -j MASQUERADE -s 192.168.1.0/24

注意enoxxxxxx对应外网网口名称。
重启防火墙

	systemctl restart firewalld.service
设置外网服务器的IP地址为192.168.1.1，然后，在内网服务器中对配置文件/etc/sysconfig/network-scripts/ifcfg-enxxxxxx进行修改，设置网卡的网关为外网服务器的IP地址：

	ONBOOT=yes
	IPADDR=192.168.1.2
	PREFIX=24
	GATEWAY=192.168.1.1
	DNS1=119.29.29.29
重启内网服务器的网络服务，即可访问外网了。

	systemctl restart network.service