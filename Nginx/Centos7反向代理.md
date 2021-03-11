# 准备环境

	mkdir /etc/nginx/conf.d/

# 准备站点文件

    cat /etc/nginx/conf.d/proxyzabbix.conf 
    server {
      listen 80;
      listen [::]:80;
      listen 443 ssl http2;
      listen [::]:443 ssl http2;
      server_name     proxy.domain.com;
      location / {
        proxy_pass https://zabbox.com;
        proxy_http_version 1.1;
        proxy_redirect off; # 是否允许重定向 
        proxy_set_header Host $host; # 传 header 参数至后端服务
        proxy_set_header X-Forwarded-For $remote_addr; # 设置request header 即客户端IP 地址 
        proxy_connect_timeout 90; # 连接代理服务超时时间 
        proxy_send_timeout 90; # 请求发送最大时间 
        proxy_read_timeout 90; # 读取最大时间 
        proxy_buffer_size 4k; 
        proxy_buffers 4 32k; 
        proxy_busy_buffers_size 64k; 
        proxy_temp_file_write_size 64k; 
        proxy_hide_header ETag;
        proxy_cache_key "$scheme$proxy_host$request_uri";
        proxy_cache_valid 200 301 302 3m;
        proxy_cache_valid any 1m;
        add_header X-Via $server_addr;
        add_header X-Cache $upstream_cache_status;
        add_header X-Accel $server_name;
      }
      ssl_certificate /etc/nginx/conf.d/zb.domain.com.crt;
      ssl_certificate_key /etc/nginx/conf.d/zb.domain.com.key;
      ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3;     #指定SSL服务器端支持的协议版本
      ssl_ciphers 'TLS13-AES-256-GCM-SHA384:TLS13-CHACHA20-POLY1305-SHA256:TLS13-AES-128-GCM-SHA256:TLS13-AES-128-CCM-8-SHA256:TLS13-AES-128-CCM-SHA256:EECDH+CHACHA20:EECDH+CHACHA20-draft:EECDH+ECDSA+AES128:EECDH+aRSA+AES128:RSA+AES128:EECDH+ECDSA+AES256:EECDH+aRSA+AES256:RSA+AES256:EECDH+ECDSA+3DES:EECDH+aRSA+3DES:RSA+3DES:!MD5';
      ssl_prefer_server_ciphers   on;    #在使用SSLv3和TLS协议时指定服务器的加密算法要优先于客户端的加密算法
      add_header Strict-Transport-Security "max-age=31536000; includeSubDomains;preload" always; # # 启用 HSTS
      add_header X-Frame-Options DENY;  # 减少点击劫持
      add_header X-Content-Type-Options nosniff;  # 禁止服务器自动解析资源类型
      add_header X-Xss-Protection 1; # 防XSS攻擊
    } 
