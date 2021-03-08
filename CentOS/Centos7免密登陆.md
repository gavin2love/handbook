服务端A 免密登陆服务器B
# 服务端A 生成秘钥，遇到提示直接敲回车即可
	ssh-keygen
# 方法一

将 服务端A ~/.ssh目录中的 id_rsa.pub 这个文件拷贝到你要登录的 服务器B的~/.ssh目录中

	ssh-copy-id -i ~/.ssh/id_rsa.pub root@192.168.x.xxx -p 端口
然后在 服务器B 运行以下命令来将公钥导入到~/.ssh/authorized_keys这个文件中

	cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
 另外要注意请务必要将服务器上
 
	~/.ssh权限设置为700
	~/.ssh/authorized_keys的权限设置为600 #

这是linux的安全要求，如果权限不对，自动登录将不会生效

# 方法二

	ssh-copy-id -i ~/.ssh/id_rsa.pub remote-host
	设置权限
	chmod 700 ~/.ssh
	chmod 600 ~/.ssh/authorized_keys