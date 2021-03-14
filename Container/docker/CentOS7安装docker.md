# docker

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


#重建软件源缓存

    yum clean all && yum makecache

# 安装常用软件

    yum install -y wget vim mlocate unzip

# 安装Docker

    sudo yum install -y vim bash-completion
    sudo yum remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-selinux docker-engine-selinux docker-engine
    sudo yum install -y yum-utils device-mapper-persistent-data lvm2
    sudo yum-config-manager --add-repo  https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
    sudo sed -i 's/download.docker.com/mirrors.aliyun.com\/docker-ce/g' /etc/yum.repos.d/docker-ce.repo
    sudo yum makecache fast
    sudo yum -y install docker-ce docker-ce-cli containerd.io
    sudo systemctl enable docker
    sudo systemctl start docker
    sudo groupadd docker
    sudo usermod -aG docker $USER
    
    sudo tee -a /etc/sysctl.conf <<-EOF
    net.bridge.bridge-nf-call-ip6tables = 1
    net.bridge.bridge-nf-call-iptables = 1
    EOF
    
    sudo sysctl -p
    # docker run hello-world

# Docker Hub 镜像加速器

    cat <<EOF > /etc/docker/daemon.json
    {
    	"graph": "/data/docker/",
    	"registry-mirrors": [ "https://1nj0zren.mirror.aliyuncs.com", 
    	"https://mirror.baidubce.com",
    	"https://docker.mirrors.ustc.edu.cn",
    	"https://hub-mirror.c.163.com"],
    	"log-opts": {"max-size": "100m","max-file": "3"},
		"dns" : ["223.5.5.5","8.8.8.8"]
    } 
    EOF

    systemctl daemon-reload && systemctl restart docker

# 检查加速器是否生效
命令行执行 `docker info`，如果从结果中看到了如下内容，说明配置成功。

    Registry Mirrors:
     [...]
     https://registry.docker-cn.com/
	 
#  hello-world

	docker run hello-world