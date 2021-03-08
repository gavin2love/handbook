# debain10 修改apt源为aliyun
	mv /etc/apt/sources.list /etc/apt/sources.list.bak && vi /etc/apt/sources.list
	deb https://mirrors.aliyun.com/debian/ buster main non-free contrib
	deb https://mirrors.aliyun.com/debian/ buster-updates main non-free contrib
	deb https://mirrors.aliyun.com/debian/ buster-backports main non-free contrib
	deb-src https://mirrors.aliyun.com/debian/ buster main non-free contrib
	deb-src https://mirrors.aliyun.com/debian/ buster-updates main non-free contrib
	deb-src https://mirrors.aliyun.com/debian/ buster-backports main non-free contrib
	deb https://mirrors.aliyun.com/debian-security/ buster/updates main non-free contrib
	deb-src https://mirrors.aliyun.com/debian-security/ buster/updates main non-free contrib
# 更新
	apt-get update -y && apt-get upgrade -y
# 同步时间
	timedatectl set-timezone Asia/Shanghai # 设置时区
	systemctl start systemd-timesyncd  # 自动同步时间
#设置主机名
	hostnamectl set-hostname pve-edge1.doamin.com
	echo "192.168.1.254 pve-edge1.doamin.com pea-edge1" | tee -a /etc/hosts
## 报错
### bash: sudo: command not found报错
	apt install sudo -y
### dpkg-source报错
	apt install dpkg-dev vim -y
# 更换SSH端口
	sed -i 's%#Port 22%Port 66%' /etc/ssh/sshd_config
	systemctl restart sshd
# 安装Porxmox VE 6.*
添加PVE相关的apt下载库

	wget -qO - https://mirrors.tuna.tsinghua.edu.cn/proxmox/debian/proxmox-ve-release-6.x.gpg |  apt-key add -
	echo "deb https://mirrors.tuna.tsinghua.edu.cn/proxmox/debian/pve buster pve-no-subscription" |  tee /etc/apt/sources.list.d/pve-install-repo.list
	echo "deb https://mirrors.tuna.tsinghua.edu.cn/proxmox/debian/ceph-nautilus buster main" |  tee /etc/apt/sources.list.d/ceph.list
	apt-get update -y && apt-get upgrade -y && apt-get install -y gnupg2
# 安装Proxmox VE软件包
	apt install proxmox-ve postfix open-iscsi ksmtuned ceph-base -y
# 配置postfix
选择Internet Site，其他配置选择默认。
	
	dpkg-reconfigure postfix
# 重启  使用PVE内核
	reboot
# 配置PVE 6源
	echo "deb https://mirrors.tuna.tsinghua.edu.cn/proxmox/debian/pve buster pve-no-subscription" >> /etc/apt/sources.list
	#echo "deb http://download.proxmox.wiki/debian/pve stretch pve-no-subscription" >/etc/apt/sources.list.d/pve-install-repo.list
	#echo 'deb http://download.proxmox.wiki/debian/pve stretch pve-no-subscription' >> /etc/apt/sources.list.d/pve-no-subscription.list
# 删除企业源
	rm -rf /etc/apt/sources.list.d/pve-enterprise.list
# 关闭PVE6 订阅提醒
	sed -i_orig "s/data.status !== 'Active'/false/g" /usr/share/pve-manager/js/pvemanagerlib.js