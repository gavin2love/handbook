编辑sysctl转发

	开启bbr,内核需要是 4.9 以上，可以使用 uname -r 命令查看
	echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
	echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
	echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
	echo "net.ipv4.conf.all.rp_filter=1" >> /etc/sysctl.conf
	echo "net.ipv4.icmp_echo_ignore_broadcasts=1" >> /etc/sysctl.conf
	echo "net.ipv4.conf.default.forwarding=1" >> /etc/sysctl.conf
	echo "net.ipv4.conf.default.proxy_arp = 0" >> /etc/sysctl.conf
	echo "net.ipv4.conf.default.send_redirects = 1" >> /etc/sysctl.conf
	sysctl -p # 生效