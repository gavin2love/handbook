#!/bin/bash

#关闭SELINUX
sed -i '/SELINUX/s/enforcing/disabled/' /etc/selinux/config  && setenforce 0
#安装依赖
yum -y install wget vim gcc-c++ pcre pcre-devel zlib zlib-devel openssl openssl-devel libunwind-devel google-perftools-devel
#下载安装包
wget https://1314.gift/env/nginx/nginx-1.19.6.tar.gz
#解压
tar -zxvf nginx-1.19.6.tar.gz
#进入安装目录
cd  nginx-1.19.6

configure
./configure \
--prefix=/etc/nginx \
--with-pcre \
--with-http_auth_request_module \
--with-http_ssl_module \
--with-http_v2_module \
--with-http_realip_module \
--with-http_addition_module \
--with-http_sub_module \
--with-http_dav_module \
--with-http_flv_module \
--with-http_mp4_module \
--with-http_gunzip_module \
--with-http_gzip_static_module \
--with-http_random_index_module \
--with-http_secure_link_module \
--with-http_stub_status_module \
--with-mail \
--with-mail_ssl_module \
--with-google_perftools_module  \
--with-stream_ssl_module 

#编译并安装
make && make install
#创建nginx用户
groupadd nginx
useradd -g nginx -s /sbin/nologin -M nginx 
#-g:指定所属的group
#-s:指定shell,因为它不需要登录，所以用/sbin/nologin
#-M：不创建home目录,因为它不需要登录
#生成service文件：
cat <<EOF > /usr/lib/systemd/system/nginx.service
[Unit]
Description=nginx-The High-performance HTTP Server
After=network.target

[Service]
Type=forking
PIDFile=/etc/nginx/logs/nginx.pid
ExecStartPre=/etc/nginx/sbin/nginx -t -c /etc/nginx/conf/nginx.conf
ExecStart=/etc/nginx/sbin/nginx -c /etc/nginx/conf/nginx.conf
ExecReload=/etc/nginx/sbin/nginx -s reload
ExecStop=/etc/nginx/sbin/nginx -s stop
PrivateTmp=true

[Install]
WantedBy=multi-user.target	
EOF

#重新加载服务文件
systemctl daemon-reload 
#运行&自起Nginx服务
systemctl enable nginx && systemctl start nginx
#放行端口
firewall-cmd --zone=public --add-port=80/tcp --permanent  
firewall-cmd --zone=public --add-port=443/tcp --permanent  
firewall-cmd --reload

#找不到nginx
echo "export PATH=$PATH:/etc/nginx/sbin" >>/etc/profile
source /etc/profile