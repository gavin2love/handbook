
#禁用selinux
    sed -i '/SELINUX/s/enforcing/disabled/' /etc/selinux/config  && setenforce 0  

#建立源

    cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
    curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
    sed -i -e '/mirrors.cloud.aliyuncs.com/d' -e '/mirrors.aliyuncs.com/d' /etc/yum.repos.d/CentOS-Base.repo
    yum -y install epel-release wget vim unzip 
    mv /etc/yum.repos.d/epel.repo /etc/yum.repos.d/epel.repo.backup
    mv /etc/yum.repos.d/epel-testing.repo /etc/yum.repos.d/epel-testing.repo.backup
    curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
	
    rpm -Uvh https://mirrors.aliyun.com/zabbix/zabbix/5.0/rhel/7/x86_64/zabbix-release-5.0-1.el7.noarch.rpm
    sed -i 's#http://repo.zabbix.com#https://mirrors.aliyun.com/zabbix#' /etc/yum.repos.d/zabbix.repo
    sed -i 's#enabled=0#enabled=1#' /etc/yum.repos.d/zabbix.repo
#重建软件源缓存
    yum clean all
    yum makecache




# 安装agent2
    yum install -y zabbix-agent2

# 查看当前agent2配置文件
    # egrep -v '^#|^$' /etc/zabbix/zabbix_agent2.conf

## 生成随机码
    openssl rand -hex 32  > /etc/zabbix/zabbix_proxy.psk

## 配置agent2文件
    vim /etc/zabbix/zabbix_agent2.conf
    Server=xxxxx
    ServerActive=xxxxx
    Hostname=Server_test客户端主机名，例如MariaDB‐Server-001
    TLSConnect=psk
    TLSAccept=psk
    TLSPSKFile=/etc/zabbix/zabbix_proxy.psk
    TLSPSKIdentity=Server_test客户端主机名，例如MariaDB‐Server-001 
# 自启Zabbix探针
    systemctl restart zabbix-agent2 && systemctl enable zabbix-agent2
    firewall-cmd --add-port=10050/tcp --permanent
    firewall-cmd --reload

# 查看服务和端口运行情况
    systemctl status zabbix-agent2
    netstat -tunlp | grep 10050

# 自定义监控项
    vim /etc/zabbix/zabbix_agentd.conf
### TCP连接数
    UserParameter=tcp-session,netstat -an |grep 'ESTABLISHED' |grep 'tcp' |wc -l 

# 重启配置
    systemctl restart zabbix-agent2
    cat /etc/zabbix/zabbix_proxy.psk && cat /etc/hostname
