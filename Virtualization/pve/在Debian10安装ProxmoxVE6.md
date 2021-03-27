# 从普通用户切换到root

	su -

# debain10 修改apt源为aliyun
	# 备份原文件
    mv /etc/apt/sources.list /etc/apt/sources.list.bak 
    # 开始换源
    cat <<EOF | tee /etc/apt/sources.list
    deb https://mirrors.aliyun.com/debian/ buster main non-free contrib
    deb https://mirrors.aliyun.com/debian/ buster-updates main non-free contrib
    deb https://mirrors.aliyun.com/debian/ buster-backports main non-free contrib
    deb-src https://mirrors.aliyun.com/debian/ buster main non-free contrib
    deb-src https://mirrors.aliyun.com/debian/ buster-updates main non-free contrib
    deb-src https://mirrors.aliyun.com/debian/ buster-backports main non-free contrib
    deb https://mirrors.aliyun.com/debian-security/ buster/updates main non-free contrib
    deb-src https://mirrors.aliyun.com/debian-security/ buster/updates main non-free contrib
    EOF

# 更新
	apt-get update -y && apt-get upgrade -y && apt-get install -y gnupg2 vim 
# 同步时间
	timedatectl set-timezone Asia/Shanghai # 设置时区
	systemctl start systemd-timesyncd  # 自动同步时间
#设置主机名

	hostnamectl set-hostname PVE-Master
	# 将127.0.1.1改为服务器主IP ，并删除原hosts中的127.0.0.1
	echo "127.0.0.1 PVE-Master.doamin.localdomain  localhost" | tee -a /etc/hosts
	echo "127.0.1.1 PVE-Master.doamin.localdomain PVE-Master " | tee -a /etc/hosts
	echo "192.168.1.254 PVE-Master.doamin.localdomain PVE-Master " | tee -a /etc/hosts

	
## 报错
### bash: sudo: command not found报错
	apt install sudo -y
### dpkg-source报错
	apt install dpkg-dev -y
# 更换SSH端口
	sed -i 's%#Port 22%Port 66%' /etc/ssh/sshd_config
	systemctl restart sshd
# 安装Porxmox VE 6.*

	添加PVE相关的apt下载库
	# 1. 导入GPG秘钥：
	wget -qO - http://download.proxmox.com/debian/proxmox-ve-release-6.x.gpg | apt-key add -
	# 2. 添加Proxmox VE存储库及Proxmox VE Ceph存储库
	# 官方源
	echo "deb http://download.proxmox.com/debian/pve buster pve-no-subscription" | tee /etc/apt/sources.list.d/pve-install-repo.list
	echo "deb http://download.proxmox.com/debian/ceph-nautilus buster main" | tee /etc/apt/sources.list.d/ceph.list
	# 国内源
	echo "deb http://download.proxmox.wiki/debian/pve buster pve-no-subscription" | tee /etc/apt/sources.list.d/pve-install-repo.list
	echo "deb http://download.proxmox.wiki/debian/ceph-nautilus buster main" | tee /etc/apt/sources.list.d/ceph.list
	# 添加完库后执行下更新
	apt-get update -y && apt-get upgrade -y 

# 安装Proxmox VE软件包
	apt install proxmox-ve postfix open-iscsi ksmtuned ceph-base -y
	# apt remove proxmox-ve postfix open-iscsi ksmtuned ceph-base -y
# 配置postfix
选择Internet Site，其他配置选择默认。
	
	dpkg-reconfigure postfix
# 重启  使用PVE内核
	reboot
# 配置PVE 6源
	# 官方源
	echo "deb http://download.proxmox.com/debian/pve buster pve-no-subscription" >> /etc/apt/sources.list
	# 国内源
	echo "deb http://download.proxmox.wiki/debian/pve buster pve-no-subscription" >> /etc/apt/sources.list
# 删除企业源
	rm -rf /etc/apt/sources.list.d/pve-enterprise.list
# 关闭PVE6 订阅提醒
	sed -i_orig "s/data.status !== 'Active'/false/g" /usr/share/pve-manager/js/pvemanagerlib.js
	# 6.3专用
	sed -Ezi.bak "s/(Ext.Msg.show\(\{\s+title: gettext\('No valid sub)/void\(\{ \/\/\1/g" /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js && systemctl restart pveproxy.service

