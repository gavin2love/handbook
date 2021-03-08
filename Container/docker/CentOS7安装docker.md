# Centos7 下快速安装Docker

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
	docker run hello-world

#常用命令

	docker pull pkg:version     # 拉取 image
	docker images               # 查看所有 image
	docker rmi myphp            # 删除 image
	docker ps                   # 查看运行中的 container
	docker ps -a                # 查看所有 container
	docker inspect myphp        # 查看 container 配置
	docker logs myphp           # 查看 container 日志
	docker restart myphp        # 重启 container
	docker stop myphp           # 停止 container
	docker rm myphp             # 删除 container
	docker exec -it myphp bash  # 进入到 container 
	docker build -t repository_name[:tag_name] Dockerfile_dir # 构建 image
	docker volume ls            # 查看数据卷
	docker volume prune         # 删除所有数据卷！！！！！！超级危险，生产环境不要执行！！！！！！