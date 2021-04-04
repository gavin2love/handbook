	配置事例
	# 初始化根密码
	set system root-authentication plain-text-password   #配置 root 登录密码（如不配置，将无法执行 commit） 
	# 设置上联端口IP
	set interfaces em0 unit 0 family inet address 1.1.1.2/24  #设置IP、掩码
	# 设置交换机默认路由
	set routing-options static route 0.0.0.0/0 next-hop 1.1.1.1  # 设置默认路由、下一跳地址
	# 设置主机名
	set system host-name R1    #修改主机名，类似linux hostname R1
	# 新建超级用户
	set system login user UserNmae class super-user
	set system login user UserNmae authentication plain-text-password
	# 设置DNS服务器
	set system name-server  1.2.4.8
	set system name-server  1.1.1.1
	set system name-server  8.8.8.8
	# 设置时间
	set system time-zone Asia/Shanghai       //设置时区
	# 设置NTP服务器
	set system ntp server 203.107.6.88
	set system ntp server ntp.ntsc.ac.cn
	set system ntp server time.nist.gov
	set system ntp sboot-server 203.107.6.88