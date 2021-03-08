以下内容摘自  Debian Squeeze更改root密码  ，适用于Proxmox VE3.x和4.x（也可以用于更改任何帐户密码以及其他基于Debian的发行版）：

# 方法1
* 启动到  grub，选择  单个用户，  但  不要按Enter。
* 按  e  进入  编辑  模式。
* 向下滚动到 您要从中引导的  内核行，它以“ linux / boot / vmlinuz-……。 ” 开头。
* 滚动到该行的末尾并按   一次空格键，然后键入   init=/bin/bash
* 按  Ctrl X  启动

		# mount -rw -o remount /
		重新挂载
		#passwd
		#passwd username