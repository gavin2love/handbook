# 准备站点环境

	mkdir /etc/nginx/conf.d/
	mkdir /etc/nginx/conf.d/ssl

# 准备站点文件

    cat /etc/nginx/conf.d/zabbix.conf 
    server {
            listen                  80;
            listen                  [::]:80;
            server_name     zb.domian.com;
            return  301 https://$server_name$request_uri;
    }
    
    server {
            listen                  443 ssl http2;
            listen                  [::]:443 ssl http2;
             server_name     zb.domian.com;
    
            root    /usr/share/zabbix;
    
            index   index.php index.html index.htm;
    
            location = /favicon.ico {
                    log_not_found   off;
            }
    
            location / {
                    try_files       $uri $uri/ =404;
            }
    
            location /assets {
                    access_log      off;
                    expires         10d;
            }
    
            location ~ /\.ht {
                    deny            all;
            }
    
            location ~ /(api\/|conf[^\.]|include|locale) {
                    deny            all;
                    return          404;
            }
    
            location ~ [^/]\.php(/|$) {
                    fastcgi_pass    unix:/run/php-fpm/zabbix.sock;
                    fastcgi_split_path_info ^(.+\.php)(/.+)$;
                    fastcgi_index   index.php;
    
                    fastcgi_param   DOCUMENT_ROOT   /usr/share/zabbix;
                    fastcgi_param   SCRIPT_FILENAME /usr/share/zabbix$fastcgi_script_name;
                    fastcgi_param   PATH_TRANSLATED /usr/share/zabbix$fastcgi_script_name;
    
                    include fastcgi_params;
                    fastcgi_param   QUERY_STRING    $query_string;
                    fastcgi_param   REQUEST_METHOD  $request_method;
                    fastcgi_param   CONTENT_TYPE    $content_type;
                    fastcgi_param   CONTENT_LENGTH  $content_length;
    
                    fastcgi_intercept_errors        on;
                    fastcgi_ignore_client_abort     off;
                    fastcgi_connect_timeout         60;
                    fastcgi_send_timeout            180;
                    fastcgi_read_timeout            180;
                    fastcgi_buffer_size             128k;
                    fastcgi_buffers                 4 256k;
                    fastcgi_busy_buffers_size       256k;
                    fastcgi_temp_file_write_size    256k;
            }
    
            location ~* \.(?:jpg|jpeg|gif|png|ico|cur|gz|svg|svgz|mp4|ogg|ogv|webm|htc)$ {
              expires 1M;
              access_log off;
              add_header Cache-Control "public";
            }
            # CSS and Javascript
            location ~* \.(?:css|js)$ {
              expires 1y;
              access_log off;
              add_header Cache-Control "public";
            }
    
            location ~* \.(?:manifest|appcache|html?|xml|json|php)$ {
              expires -1;
              # access_log logs/static.log; # I don't usually include a static log
            }
            ssl_certificate /etc/nginx/conf.d/ssl/zb.domian.com.crt;
            ssl_certificate_key /etc/nginx/conf.d/ssl/zb.domian.com.key;
            ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3;     #指定SSL服务器端支持的协议版本
            ssl_ciphers 'TLS13-AES-256-GCM-SHA384:TLS13-CHACHA20-POLY1305-SHA256:TLS13-AES-128-GCM-SHA256:TLS13-AES-128-CCM-8-SHA256:TLS13-AES-128-CCM-SHA256:EECDH+CHACHA20:EECDH+CHACHA20-draft:EECDH+ECDSA+AES128:EECDH+aRSA+AES128:RSA+AES128:EECDH+ECDSA+AES256:EECDH+aRSA+AES256:RSA+AES256:EECDH+ECDSA+3DES:EECDH+aRSA+3DES:RSA+3DES:!MD5';
            ssl_prefer_server_ciphers   on;    #在使用SSLv3和TLS协议时指定服务器的加密算法要优先于客户端的加密算法
            add_header Strict-Transport-Security "max-age=31536000; includeSubDomains;preload" always; # # 启用 HSTS
            add_header X-Frame-Options DENY;  # 减少点击劫持
            add_header X-Content-Type-Options nosniff;  # 禁止服务器自动解析资源类型
            add_header X-Xss-Protection 1; # 防XSS攻擊
            
            # GZip
            gzip on; 
           gzip_min_length 1k; 
           gzip_buffers 4 16k; # 设置gzip申请内存的大小,按块大小的倍数 
           gzip_http_version 1.1; # 设置允许压缩的最低http版本 
           gzip_comp_level 5;
           gzip_vary on; # 响应头 add："Vary: Accept-Encoding" 
           gzip_proxied off; # 当 nginx 自己处在反向代理中
         gzip_types text/plain text/css text/xml text/javascript text/x-component application/json application/javascript application/x-javascript application/xml application/xhtml+xml application/rss+xml application/atom+xml application/x-font-ttf application/vnd.ms-fontobject image/svg+xml image/x-icon font/opentype;
    
            #TLS 握手优化 
            ssl_session_cache shared:SSL:1m; 
            ssl_session_timeout 5m; 
            keepalive_timeout 75s; 
            keepalive_requests 100;
    
    }
