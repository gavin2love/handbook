# 减少进程数与超时时间

	unicorn['worker_processes'] = 5   #默认是被注释掉的，最小不能低于2，否者会卡死 (等于CPU核心数+1)
## 我的服务器配置为4C 8G，所以调整为5.

	unicorn['worker_timeout'] = 60    #设置超时时间

# gitlab默认使用PostgreSQL，如果您开启了，可以进行如下优化

## 减少数据库缓存
	
	postgresql['shared_buffers'] = "256MB"    #默认为256MB，可适当改小
## 减少数据库并发数

	postgresql['max_worker_processes'] = 8     #默认为8，可适当改小
## 减少sidekiq并发数

	sidekiq['concurrency'] = 25               #默认是25，可适当改小

# 时区设置为”Asia/Shanghai”:

	gitlab_rails['time_zone'] = 'UTC' —> gitlab_rails['time_zone'] = 'Asia/Shanghai'

# 禁止用户创建顶层组
	
	gitlab_rails['gitlab_default_can_create_group'] = true 改为= false
# 禁止用户修改用户名
	
	gitlab_rails['gitlab_username_changing_enabled'] = true 改为 = false

# GitLab trusted_proxies可信代理配置

	gitlab_rails['trusted_proxies'] = [] —> gitlab_rails['trusted_proxies']  = [‘192.168.56.0/24’]

# 测试SMTP配置

	运行 gitlab-rails console 进入到 gitlab-rails 控制台:
发送测试邮件:

	irb(main):001:0> Notify.test_email('798423939@qq.com', 'Message Subject by gitlab-rails', '<p style="color:red;">Message Body</p>').deliver_now


#修改数据存放目录
	
	git_data_dirs({
	  "default" => {
		"path" => "/data"
	   }
	})

## 优化进程减少内存占用

将# unicorn['worker_processes'] = 2取消注释，即unicorn['worker_processes'] = 2

官方要求这个最低值为2，如果使用量大，可酌情调整这个值
