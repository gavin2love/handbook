# 安装PageSpeed 和 Brotli 模块

## 创建编译目录/下载pagespeed以及brotli源码：

    mkdir -p nginx && cd nginx
    wget https://github.com/apache/incubator-pagespeed-ngx/archive/v1.13.35.2-stable.tar.gz
    tar -xzvf v1.13.35.2-stable.tar.gz
    cd incubator-pagespeed-ngx-1.13.35.2-stable/
    wget https://dl.google.com/dl/page-speed/psol/1.13.35.2-x64.tar.gz
    tar -xzvf 1.13.35.2-x64.tar.gz
    cd ..
    git clone https://github.com/google/ngx_brotli.git
    cd ngx_brotli
    git submodule update --init

##  准备二次编译Nginx
    
    cd nginx
    wget  https://1314.gift/env/nginx/nginx-1.19.8.tar.gz
    tar -zxvf 1.19.8.tar.gz
    cd  1.19.8


## 编译

    ./configure --add-dynamic-module=../incubator-pagespeed-ngx-1.13.35.2-stable \
    --add-dynamic-module=../ngx_brotli \
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

## 编译完成之后将模块传输到生产机器内：

    mkdir /etc/nginx/modules
    cp objs/ngx_pagespeed.so /etc/nginx/modules
    cp objs/ngx_http_brotli_filter_module.so /etc/nginx/modules
    cp objs/ngx_http_brotli_static_module.so /etc/nginx/modules

## 在文件/etc/nginx/conf/nginx.conf的顶行加入：

    load_module /etc/nginx/modules/ngx_pagespeed.so;
    load_module /etc/nginx/modules/ngx_http_brotli_filter_module.so;
    load_module /etc/nginx/modules/ngx_http_brotli_static_module.so;


## 启用PageSpeed 和 Brotli
http段内加入：
       
    pagespeed on; # 是否启用pagespeed
    pagespeed EnableFilters local_storage_cache;  # 开启本地存储缓存
    pagespeed FileCachePath /data/nginx/ngx_pagespeed_cache; # 缓存文件存放路径
    pagespeed FileCacheSizeKb 1048576; # 缓存文件占用硬盘的最大空间1GB（单位KB）
    pagespeed FileCacheCleanIntervalMs 43200000; # 缓存过期清理时间12小时（单位毫秒） 
    pagespeed RewriteLevel PassThrough; # 使用下面的自定义配置
    pagespeed EnableFilters combine_css,rewrite_css; # 压缩CSS
    pagespeed EnableFilters combine_javascript,rewrite_javascript; # 压缩JS
    pagespeed EnableFilters lazyload_images; # 图片预加载
    pagespeed EnableFilters rewrite_images; # 压缩图片
    pagespeed EnableFilters insert_dns_prefetch; # 预解析DNS
    pagespeed RewriteLevel OptimizeForBandwidth; # 优化带宽
    pagespeed EnableFilters make_show_ads_async; # 使Google Analytics（分析）异步
    pagespeed EnableFilters make_google_analytics_async;使展示广告异步
    pagespeed EnableFilters convert_jpeg_to_progressive,convert_png_to_jpeg,convert_jpeg_to_webp,convert_to_webp_lossless; # 转换图片为webp格式
    pagespeed EnableFilters remove_comments; # 删除HTML注释
    pagespeed EnableFilters collapse_whitespace; # 删除HTML空行
    pagespeed HttpCacheCompressionLevel 0; # 关闭pagespeed的Gzip压缩功能，避免与brotli冲突。
    pagespeed XHeaderValue "PageSpeed It`s BalaBala"; # 娱乐功能，也可以用来验证pagespeed是否正常工作。

    # 还是在http段内，关闭gzip，并加入brotli的配置：
    gzip off;
    
    # gzip_vary on;
    # gzip_proxied any;
    gzip_comp_level 6;
    # gzip_buffers 16 8k;
    # gzip_http_version 1.1;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript image/jpeg image/gif image/png image/bmp;
    
    brotli on;
    brotli_comp_level 6;
    brotli_types *;


注：我这边是直接全部都写在http段内了，相当于是全局启用这两个模块的功能（所有vhost都会应用这些设置）如果你只想在某一个站点内启用，那么就在对应站点的server段内加入上面的配置即可。

