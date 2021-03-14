# 下载

	wget http://1314.gift/iso/ubuntu-20.04.2-live-server-amd64.iso
	
# 查看版本

	user@ubuntu:~$ lsb_release -c
	Codename:       focal

# 切换根管理员
	
	sudo su

# apt更换国内阿里源

	#备份
	
	mv -v /etc/apt/sources.list /etc/apt/sources.list.backup
	cat <<EOF > /etc/apt/sources.list
	deb https://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse
	deb https://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse
	deb https://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse
	deb https://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse
	deb https://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse
	deb-src https://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse
	deb-src https://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse
	deb-src https://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse
	deb-src https://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse
	deb-src https://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse
	EOF

	#修改完软件源后，更新软件列表和软件：

	apt -y update
	apt -y install tasksel
	apt -y upgrade
	apt -y install build-essential
	apt -y install language-pack-zh-hans
	reboot
	
# 安装桌面

	apt -y install  ubuntu-desktop gnome-core  
	reboot
	
# 远程桌面 （安装 Xrdp）

	apt -y install xrdp
	systemctl status xrdp # 查看运行状态
	sed -i 's%port=3389%port=55556%' /etc/xrdp/xrdp.ini 
	sudo systemctl restart xrdp
	sudo ufw allow 55556

# 修改SSH端口

	sed -i 's%#Port 22%Port 66%' /etc/ssh/sshd_config 
	sudo ufw allow 66
	service ssh restart
	
# 安装常用软件
    apt-get -y install fcitx-googlepinyin # 谷歌拼音输入法
    apt-get -y install git # git
    apt-get -y install stacer # 系统管理器
    apt-get -y install okular # pdf阅读器
    apt-get -y install pandoc # markdown转word
    apt-get -y install redshift # 屏幕色温调节
    apt-get -y install pdfgrep # pdf文件正则表达式检索
    apt-get -y install recoll poppler-utils # 文件内容检索工具
    apt-get -y install rdfind # 重复文件扫描
# Chrome

    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    dpkg -i google-chrome*; apt-get -f install 

