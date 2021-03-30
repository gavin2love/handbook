# Gmail

	gitlab_rails['smtp_enable'] = true
	gitlab_rails['smtp_address'] = "smtp.gmail.com"
	gitlab_rails['smtp_port'] = 587
	gitlab_rails['smtp_user_name'] = "my.email@gmail.com"
	gitlab_rails['smtp_password'] = "my-gmail-password"
	gitlab_rails['smtp_domain'] = "smtp.gmail.com"
	gitlab_rails['smtp_authentication'] = "login"
	gitlab_rails['smtp_enable_starttls_auto'] = true
	gitlab_rails['smtp_tls'] = false
	gitlab_rails['smtp_openssl_verify_mode'] = 'peer' # 可以是: 'none', 'peer', 'client_once', 'fail_if_no_peer_cert',  http://api.rubyonrails.org/classes/ActionMailer/Base.html
	
	
# Office365

	gitlab_rails['smtp_enable'] = true
	gitlab_rails['smtp_address'] = "smtp.office365.com"
	gitlab_rails['smtp_port'] = 587
	gitlab_rails['smtp_user_name'] = "username@yourdomain.com"
	gitlab_rails['smtp_password'] = "password"
	gitlab_rails['smtp_domain'] = "yourdomain.com"
	gitlab_rails['smtp_authentication'] = "login"
	gitlab_rails['smtp_enable_starttls_auto'] = true
	gitlab_rails['smtp_openssl_verify_mode'] = 'peer'
	gitlab_rails['gitlab_email_from'] = 'username@yourdomain.com'
	
# QQ exmail (腾讯企业邮箱)

	gitlab_rails['smtp_enable'] = true
	gitlab_rails['smtp_address'] = "smtp.exmail.qq.com"
	gitlab_rails['smtp_port'] = 465
	gitlab_rails['smtp_user_name'] = "xxxx@xx.com"
	gitlab_rails['smtp_password'] = "password"
	gitlab_rails['smtp_authentication'] = "login"
	gitlab_rails['smtp_enable_starttls_auto'] = true
	gitlab_rails['smtp_tls'] = true
	gitlab_rails['gitlab_email_from'] = 'xxxx@xx.com'
	gitlab_rails['smtp_domain'] = "exmail.qq.com"
