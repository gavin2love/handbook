# 切换到root账户

# 安装依赖项

    yum -y install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel libffi-devel gcc make

# 下载python3.8.5

    wget https://1314.gift/env/python/Python-3.8.5.tgz

# 解压

    tar -zxvf Python-3.8.5.tgz

# 配置编译

    cd Python-3.8.5
    mkdir /usr/local/python3.8.5
    ./configure --prefix=/usr/local/python3.8.5  --enable-optimizations  

> 如果出现错误信息：SystemError: <built-in function compile> returned NULL
> without setting an error generate-posix-vars
> failed；则需要升级gcc版本，请先升级gcc版本，参考链接centos7安装gcc10.2.0。

# 编译安装

    make && make install

# 建立链接

    ln -s /usr/local/python3.8.5/bin/python3 /usr/bin/python3  
    ln -s /usr/local/python3.8.5/bin/pip3 /usr/bin/pip3

# 查询版本

    python3 --version


# 升级配置

    python3 -m pip install --upgrade pip
    #pip3 config set global.index-url https://mirrors.aliyun.com/pypi/simple/ 
    pip3 install pipenv
    python3 -V && pip3 -V 


# 卸载

    删除文件
    rm -rf
    
    删除/usr/local/bin/python3
    rm -rf /usr/local/bin/python3
    
    删除/usr/bin软连接文件
    rm -rf /usr/bin/python3
    rm -rf /usr/bin/pip3
    
    删除已解压的文件夹（可选）
    rm -rf /usr/local/python3/Python-3.8.1
    
    然后再次安装只需从解压开始即可。
