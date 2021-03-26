# 安装DHCP服务

	yum install -y dhcp

# 更改配置文件：vim /etc/dhcp/dhcpd.conf

	#设置DHCP于DNS服务器的动态信息更新模式。初学时完全可以不理这个选项，但是全局设置中一定要有这个选项，否则DHCP服务不能成功启动。
	ddns-update-style interim;

	subnet 192.168.31.0 netmask 255.255.255.0 { # 作用域网段
		range dynamic-bootp 192.168.31.100 192.168.31.254;  # 地址池范围
		option ntp-servers 203.107.6.88,17.253.116.125;   # NTP
		option domain-name-servers 223.5.5.5,114.114.114.114;  # DNS
		option domain-name "example.org";  # 作用域名
		option routers 192.168.31.1;  # 网关，Ser上面配置的网关和此网关要一致
		option broadcast-address 192.168.31.255;  # 广播地址
		default-lease-time 600;  # 默认租约时间
		max-lease-time 3600;  # 最大租约时间

		#  指定IP
		host printer {
			hardware ethernet 00:0c:29:12:9d:d5;
			fixed-address 192.168.31.99;
		}
	}
	
# 启动DHCP服务

	systemctl restart dhcpd
	systemctl enable dhcpd 
	systemctl status dhcpd 

# 查看DHCP端口

	netstat -tunlp |grep dhcpd

# 防火墙放行

	firewall-cmd --zone=public --add-port=67/udp --permanent
	firewall-cmd --reload

# 模块文件

	# [root@k8s-Server ~]# cat /usr/share/doc/dhcp-4.2.5/dhcpd.conf.example
	# dhcpd.conf
	#
	# ISC dhcpd的示例配置文件
	#

	# 所有支持的网络通用的选项定义。。。
	option domain-name "example.org";
	option domain-name-servers ns1.example.org, ns2.example.org;

	default-lease-time 600;
	max-lease-time 7200;

	# 使用此选项全局启用/禁用动态dns更新。
	#ddns-update-style none;

	# 如果此DHCP服务器是本地的官方DHCP服务器网络中，权威指令应取消注释。
	#authoritative;

	# 使用此选项可将dhcp日志消息发送到其他日志文件（您也可以
	# 必须黑客攻击syslog.conf完成重定向）。
	log-facility local7;

	# 此子网上不会提供任何服务，但声明它有助于了解DHCP服务器的网络拓扑结构。.

	subnet 10.152.187.0 netmask 255.255.255.0 {
	}

	# 这是一个非常基本的子网声明。

	subnet 10.254.239.0 netmask 255.255.255.224 {
	  range 10.254.239.10 10.254.239.20;
	  option routers rtr-239-0-1.example.org, rtr-239-0-2.example.org;
	}

	# 这个声明允许BOOTP客户机获取动态地址，但我们并不推荐。

	subnet 10.254.239.32 netmask 255.255.255.224 {
	  range dynamic-bootp 10.254.239.40 10.254.239.60;
	  option broadcast-address 10.254.239.31;
	  option routers rtr-239-32-1.example.org;
	}

	# 内部子网的配置稍有不同。
	subnet 10.5.5.0 netmask 255.255.255.224 {
	  range 10.5.5.26 10.5.5.30;
	  option domain-name-servers ns1.internal.example.org;
	  option domain-name "internal.example.org";
	  option routers 10.5.5.1;
	  option broadcast-address 10.5.5.31;
	  default-lease-time 600;
	  max-lease-time 7200;
	}

	# 需要特殊配置选项的主机可以在中列出主机语句。
	# 如果未指定地址，则地址将为动态分配（如果可能）
	# 但主机特定的信息仍将来自主机声明。

	host passacaglia {
	  hardware ethernet 0:0:c0:5d:bd:95;
	  filename "vmunix.passacaglia";
	  server-name "toccata.fugue.com";
	}

	# 也可以为主机指定固定IP地址。这些地址也不应列为可用于动态分配。
	# 指定了固定IP地址的主机可以使用BOOTP或DHCP。
	# 未指定固定地址的主机只能除非子网上有地址范围，否则无法使用DHCP启动
	# 具有动态BOOTP标志的BOOTP客户机所连接的设置。
	host fantasia {
	  hardware ethernet 08:00:07:26:c0:a5;
	  fixed-address fantasia.fugue.com;
	}

	# 您可以声明一类客户机，然后进行地址分配 基于此。
	# 下面的示例显示了一个所有客户端在某个类中，获取10.17.224/24子网上的地址
	# 以及所有其他客户端在10.0.29/24子网上获得地址。

	class "foo" {
	  match if substring (option vendor-class-identifier, 0, 4) = "SUNW";
	}

	shared-network 224-29 {
	  subnet 10.17.224.0 netmask 255.255.255.0 {
		option routers rtr-224.example.org;
	  }
	  subnet 10.0.29.0 netmask 255.255.255.0 {
		option routers rtr-29.example.org;
	  }
	  pool {
		allow members of "foo";
		range 10.17.224.10 10.17.224.250;
	  }
	  pool {
		deny members of "foo";
		range 10.0.29.10 10.0.29.230;
	  }
	}
