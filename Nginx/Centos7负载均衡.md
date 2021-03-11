
upstream node {
       ip_hash;
       server 192.168.1.1:80 weight=2 max_fails=3 fail_timeout=15; # 如果有3次请求失败，15秒内，不会将新的请求分配给它。
       server 192.168.1.2:80 weight=3;  # 3/6次
      server example.com:80 weight=1;  # 1/6次
      #server 192.168.1.3:80 backup; # 当全部都挂了后使用 
      #server 192.168.1.4:80 down; # 不参与轮训


}



server {
        listen                  443 ssl http2;
        listen                  [::]:443 ssl http2;
        server_name     www.domain.com;

        location / {
            proxy_pass   http://node;
            proxy_set_header        Host    $host;
            proxy_set_header        X-Real-IP       $remote_addr;
            proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
        }


        ssl_certificate /etc/nginx/conf.d/www.domain.com.crt;
        ssl_certificate_key /etc/nginx/conf.d/www.domain.com.key;
        ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3;     #指定SSL服务器端支持的协议版本
        ssl_ciphers 'TLS13-AES-256-GCM-SHA384:TLS13-CHACHA20-POLY1305-SHA256:TLS13-AES-128-GCM-SHA256:TLS13-AES-128-CCM-8-SHA256:TLS13-AES-128-CCM-SHA256:EECDH+CHACHA20:EECDH+CHACHA20-draft:EECDH+ECDSA+AES128:EECDH+aRSA+AES128:RSA+AES128:EECDH+ECDSA+AES256:EECDH+aRSA+AES256:RSA+AES256:EECDH+ECDSA+3DES:EECDH+aRSA+3DES:RSA+3DES:!MD5';
        ssl_prefer_server_ciphers   on;    #在使用SSLv3和TLS协议时指定服务器的加密算法要优先于客户端的加密算法
        add_header Strict-Transport-Security "max-age=31536000; includeSubDomains;preload" always; # # 启用 HSTS
        add_header X-Frame-Options DENY;  # 减少点击劫持
        add_header X-Content-Type-Options nosniff;  # 禁止服务器自动解析资源类型
        add_header X-Xss-Protection 1; # 防XSS攻擊
        

}
