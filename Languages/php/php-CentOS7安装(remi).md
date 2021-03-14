# PHP-CentOS7下安装

# 禁用selinux

	sed -i '/SELINUX/s/enforcing/disabled/' /etc/selinux/config  && setenforce 0  

#建立源
    
    cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
    curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
    sed -i -e '/mirrors.cloud.aliyuncs.com/d' -e '/mirrors.aliyuncs.com/d' /etc/yum.repos.d/CentOS-Base.repo
    yum -y install epel-release wget vim unzip 
    mv /etc/yum.repos.d/epel.repo /etc/yum.repos.d/epel.repo.backup
    mv /etc/yum.repos.d/epel-testing.repo /etc/yum.repos.d/epel-testing.repo.backup
    curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo

#重建软件源缓存

    yum clean all && yum makecache

# 安装PHP7
清理旧 php

    yum -y remove php*

安装Remi存储库

    rpm -Uvh http://mirrors.aliyun.com/remi/enterprise/remi-release-7.rpm
    sed -i 's%http://rpms.remirepo.net%https://mirrors.aliyun.com/remi%' /etc/yum.repos.d/remi*
    sed -i 's%http://cdn.remirepo.net%https://mirrors.aliyun.com/remi%' /etc/yum.repos.d/remi*

查看可以安装的 php 版本

    yum list php*

安装 PHP 7.3

    yum --enablerepo=remi-php73 install php

安装 PHP 7.2

    yum --enablerepo=remi-php72 install php

安装 PHP 7.1

    yum --enablerepo=remi-php71 install php

安装拓展

    yum install -y php73-php-fpm php73-php-cli php73-php-bcmath php73-php-gd php73-php-json php73-php-mbstring php73-php-mcrypt php73-php-mysqlnd php73-php-opcache php73-php-pdo php73-php-pecl-crypto php73-php-pecl-mcrypt php73-php-pecl-geoip php73-php-recode php73-php-snmp php73-php-soap php73-php-xml php73-php-zip

php-fpm 操作

    systemctl enable php73-php-fpm #开机启动
    systemctl restart php73-php-fpm #重启
    systemctl start php73-php-fpm #启动
    systemctl status php73-php-fpm #检查状态
    systemctl stop php73-php-fpm #关闭
    编辑 /etc/opt/remi/php73/php.ini，将;cgi.fix_pathinfo=1 取消注释并将 1 改为 0。

命令行：`sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/opt/remi/php73/php.ini`

## 如果运行的是 nginx 而不是 apache，修改 /etc/opt/remi/php73/php-fpm.d/www.conf

    user = nginx
    group = nginx