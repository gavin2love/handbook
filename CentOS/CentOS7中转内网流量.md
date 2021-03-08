	echo 1 > /proc/sys/net/ipv4/ip_forward 
	sysctl -p 
	firewall-cmd --permanent --add-port=161/tcp --zone=public 
	firewall-cmd --permanent --add-port=161/udp --zone=public 
	firewall-cmd --permanent --add-masquerade --zone=public 
	firewall-cmd --permanent --add-forward-port=port=161:proto=tcp:toport=161:toaddr=1.1.1.1 --zone=public 
	firewall-cmd --permanent --add-forward-port=port=161:proto=udp:toport=161:toaddr=1.1.1.1 --zone=public 
	firewall-cmd --reload
