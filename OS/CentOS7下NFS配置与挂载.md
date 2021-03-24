# 禁用selinux

    sed -i '/SELINUX/s/enforcing/disabled/' /etc/selinux/config  && setenforce 0  

# 建立源

    cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
    curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
    sed -i -e '/mirrors.cloud.aliyuncs.com/d' -e '/mirrors.aliyuncs.com/d' /etc/yum.repos.d/CentOS-Base.repo
    yum -y install epel-release wget vim unzip 
    mv /etc/yum.repos.d/epel.repo /etc/yum.repos.d/epel.repo.backup
    mv /etc/yum.repos.d/epel-testing.repo /etc/yum.repos.d/epel-testing.repo.backup
    curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo

# 重建软件源缓存

    yum clean all && yum makecache

# 安装常用软件

    yum install -y wget vim mlocate unzip

# 通过yum直接安装NFS所需要的软件包

    yum install -y nfs-utils rpcbind
    systemctl start rpcbind && systemctl enable rpcbind

# 编辑vim /etc/exports ，添加以下内容
    /data 192.168.31.0/24(rw,sync,all_squash,anonuid=1000,anongid=1000,insecure)
    chmod a+w /data

> /data :nfs共享的文件夹目录（共享哪个目录）
> 192.168.0.0/16:共享的IP网段（允许哪个客户端去访问） rw:允许读写 sync:同步写入 no_root_squash:当客户机以root身份访问时，赋予root权限（即超级用户保留权限）,否则，root用户所有请求映射成anonymous用户一样的权限（默认）

# 关闭firewalld 

    systemctl stop firewalld && systemctl disable firewalld 

# 启动nfs服务，配置开机自启动

    systemctl start nfs && systemctl enable nfs

# 验证是否NFS正确导出目录

    showmount -e

# mac下nfs挂载

    sudo mount -o nolock -t nfs ip:/服务器目录 /Users/nfs

