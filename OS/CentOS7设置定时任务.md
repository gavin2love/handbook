

# 安装 crontabs服务并设置开机自启：
	[root@localhost ~]# yum install crontabs -y  
	[root@localhost ~]# systemctl enable crond  
	[root@localhost ~]# systemctl start crond  
# 设置用户自定义定时任务：
	[root@localhost ~]# vi /etc/crontab  
可以看到：

	# Example of job definition:  
	#   .  ---------------- 分钟 (0 - 59)  
	#   |    .------------- 小时 (0 - 23)  
	#   |   |   .---------- 天 (1 - 31)  
	#   |   |   |   .------- 月 (1 - 12) OR jan,feb,mar,apr ...  
	#   |   |   |   |   .---- 周 (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat # | | | | |  
	#   *  *   *  *  * user-name command to be executed  
	即：分钟(0-59) 小时(0-23) 日(1-31) 月(11-12) 星期(0-6,0表示周日) 用户名 要执行的命令  

每隔30分钟root执行一次updatedb命令：
*/30 * * * * root updatedb  
	
每天早上5点定时重启系统：
	0 5 * * * root reboot  
每隔3分钟执行一次/app目录下的python脚本：
	*/3 * * * * root python3 /app/run.py 

# 保存生效：
# 加载任务,使之生效  
	[root@localhost ~]# crontab /etc/crontab  
#查看任务  
	[root@localhost ~]# crontab -l  
	
出处：CentOS 7 设置计划任务 crontabs——https://blog.itnmg.net/2013/05/18/linux-crond
