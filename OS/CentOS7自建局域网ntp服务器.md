# NTP简介：
NTP是网络时间协议(Network Time Protocol)，它是用来同步网络中各个计算机的时间的协议。在计算机的世界里，时间非常地重要例如：对于火箭发射这种科研活动，对时间的统一性和准确性要求就非常地高，是按照A这台计算机的时间，还是按照B这台计算机的时间？NTP就是用来解决这个问题的，NTP（Network Time Protocol，网络时间协议）是用来使网络中的各个计算机时间同步的一种协议。它的用途是把计算机的时钟同步到世界协调时UTC，其精度在局域网内可达0.1ms，在互联网上绝大多数的地方其精度可以达到1-50ms。它可以使计算机对其服务器或时钟源（如石英钟，GPS等等）进行时间同步，它可以提供高精准度的时间校正，而且可以使用加密确认的方式来防止病毒的协议攻击。

# 环境：
* CentOS Linux release 7.7.1908 (Core)
* NTP Server服务器IP：192.168.0.15
* NTP Client客户端IP：192.168.0.16

# 搭建NTP服务器
查看服务器是否安装ntp，系统默认安装ntpdate

	[root@localhost ~]# rpm -qa |grep ntp 
	ntpdate-4.2.6p5-28.el7.centos.x86_64 
	ntp-4.2.6p5-28.el7.centos.x86_64
# 安装ntp，ntpdate

	[root@localhost ~]# yum install -y ntp ntpdate
修改ntp配置文件

	[root@localhost ~]# vim /etc/ntp.conf 
取消注释 
	restrict 192.168.1.0 mask 255.255.255.0 nomodify notrap
启动ntp服务，并开机自启动

	[root@localhost ~]# systemctl start ntpd [root@localhost ~]# systemctl enable ntpd
查询ntp是否同步

	[root@localhost ~]# ntpq -p 
	remote refid st t when poll reach delay offset jitter 
	============================================================================== 
	*time.airgapped. 216.218.254.202 2 u 27 64 77 43.822 -11.049 0.711 
	+bray.walcz.net 140.203.204.77 2 u 28 64 77 148.678 -11.361 0.680 
	+time.rdg.uk.as4 74.156.100.179 2 u 26 64 77 140.169 -12.353 0.720 
	-time.panq.nl 46.243.26.34 2 u 25 64 77 148.636 -9.576 0.731
开启防火墙ntp默认端口udp123
	
	[root@localhost ~]# firewall-cmd --permanent --zone=public --add-port=123/udp 
	success 
	[root@localhost ~]# firewall-cmd --reload 
	success
# NTP客户端配置
安装的NTP跟上面的步骤一样

修改ntp配置文件，将上面的NTP服务器作为客户端同步NTP时间服务器

	[root@localhost ~]# vim /etc/ntp.conf 
	#配置允许NTP Server时间服务器主动修改本机的时间 
	restrict 192.168.0.15 nomodify notrap noquery 
	#注释掉其他时间服务器 
	#server 0.centos.pool.ntp.org iburst 
	#server 1.centos.pool.ntp.org iburst 
	#server 2.centos.pool.ntp.org iburst 
	#server 3.centos.pool.ntp.org iburst 
	#配置时间服务器为本地搭建的NTP Server服务器 
	server 192.168.0.15
与NTP server服务器同步一下时间：

	[root@localhost ~]# ntpdate -u 192.168.0.15
查看ntp同步状态

能看到已经成功同步，要记得开启ntpd这个服务器

	[root@localhost ~]# ntpq -p
	     remote           refid      st t when poll reach   delay   offset  jitter
	==============================================================================
	 192.168.0.15  119.28.206.193   3 u    7   64    1    0.217  -288085   0.000