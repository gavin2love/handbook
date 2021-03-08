开启debian定时任务crond，每天凌晨检查一次free内存，当小于8G时执行这三条命令（注：系统内容32G）。

注意：在执行这三条命令之前一定要先执行sync命令（描述：sync 命令运行 sync 子例程。如果必须停止系统，则运行sync 命令以确保文件系统的完整性。sync 命令将所有未写的系统缓冲区写到磁盘中，包含已修改的 i-Node、已延迟的块 I/O 和读写映射文件）

debian启动脚本: cleanCache.sh

	root@host:~# cat cleanCache.sh
	#!/bin/bash
	# 每一小时清除一次缓存
	echo "开始清除缓存"
	used=`free -m | awk 'NR==2' | awk '{print $3}'`
	free=`free -m | awk 'NR==2' | awk '{print $4}'`
	echo "===========================" >> mem.log
	date >> mem.log
	echo "Memory usage before | [Use：${used}MB][Free：${free}MB]" >> mem.log
	if [ $free -le 8000 ] ; then
		sync && echo 1 > /proc/sys/vm/drop_caches
		sleep 3 #延迟10秒
		sync && echo 2 > /proc/sys/vm/drop_caches
		sleep 10 #延迟10秒
		sync && echo 3 > /proc/sys/vm/drop_caches
		used_ok=`free -m | awk 'NR==2' | awk '{print $3}'`
		free_ok=`free -m | awk 'NR==2' | awk '{print $4}'`
		echo "Memory usage after | [Use：${used_ok}MB][Free：${free_ok}MB]" >> mem.log
		echo "OKAY" >> mem-okay.log
	else
		echo "Not required" >> mem-required.log
	fi
	exit 1
设置可执行

	chmod +x cleanCache.sh 
创建定时器任务，以管理员的身份

直接  vim 编辑/etc/crontab
加入指定时间和命令，命令可以加绝对路径或者可以不加

	 0 *  *   *   * root    bash /root/cleanCache.sh