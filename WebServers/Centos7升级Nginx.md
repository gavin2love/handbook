# 准备安装文件

	yum install -y tar wget vim 
	wget https://1314.gift/env/nginx/nginx-1.19.8.tar.gz
	tar -zxvf nginx-1.19.8.tar.gz

# 进入安装目录

	cd nginx-1.19.8
	
# configure

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
	--with-http_auth_request_module \
	--with-mail \
	--with-mail_ssl_module \
	--with-google_perftools_module  \
	--with-stream_ssl_module
	

# 编译
	
	make
	
# 备份文件

	mv /etc/nginx/sbin/nginx /etc/nginx/sbin/nginx_xxx_bak # xxx为版本号
	cp objs/nginx /etc/nginx/sbin/
	
# 检测语法错误

	/etc/nginx/sbin/nginx -t
	
# 升级

	make upgrade
	
## 提示如下：

	/etc/nginx/sbin/nginx -t
	nginx: the configuration file /etc/nginx/conf/nginx.conf syntax is ok
	nginx: configuration file /etc/nginx/conf/nginx.conf test is successful
	kill -USR2 `cat /etc/nginx/logs/nginx.pid`
	sleep 1
	test -f /etc/nginx/logs/nginx.pid.oldbin
	kill -QUIT `cat /etc/nginx/logs/nginx.pid.oldbin`

# 查看版本

	/etc/nginx/sbin/nginx -V

# 软加载新配置

	/etc/nginx/sbin/nginx -s reload
