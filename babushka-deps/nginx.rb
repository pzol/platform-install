meta 'nginx' do
	template {
		def passenger_default_user;	"deploy"; end
		def passenger_root; 				Babushka::GemHelper.gem_path_for('passenger'); end
		def passenger_ruby;  				"/usr/local/rvm/wrappers/ruby-1.9.2-p136/ruby"; end
		def log_path; 							var(:log_path); end
		def nginx_prefix; 					var(:nginx_prefix); end
		def conf_path; 							var(:nginx_prefix) / "conf/nginx.conf"; end
		def www_root; 							var(:www_root); end

		setup {
			define_var :nginx_prefix, :message => "Nginx default prefix", :default => '/opt/nginx'
			define_var :log_path, :message => "Error log path", :default => "/var/log/nginx"
			define_var :www_root, :message => "www root path", :default => "/var/www/root"
		}
	}
end

dep 'webserver.nginx' do
	requires 'libcurl4-openssl-dev.managed', 'passenger.gem'

	met? { File.executable?(var(:nginx_prefix) / 'sbin/nginx') }
	meet {
		log_shell "Downloading and installing nginx via passenger",
	 						"#{passenger_root}/bin/passenger-install-nginx-module --prefix='#{var(:nginx_prefix)}' --auto-download --extra-configure-flags='--with-http_ssl_module' --auto"
		shell "rm #{conf_path}", :sudo => true	# remove the default config
	}	
end

dep 'conf.nginx' do
	requires 'deploy.user'
	met? { File.exists? conf_path }
  meet { 
		render_erb "nginx/nginx.conf", :to => conf_path, :sudo => true 
		shell "touch #{nginx_prefix}/conf/access-list", :sudo => true
	}
end

dep 'init_d.nginx' do
	met? { File.exists? "/etc/init.d/nginx" }
	meet { 
		render_erb "nginx/init.d.erb", :to => '/etc/init.d/nginx', :perms => '755', :sudo => true
		sudo 'update-rc.d nginx defaults'
	}
end

dep 'started.nginx' do
	met? { shell("ps aux | grep nginx")["master process"] }
	meet { shell "/etc/init.d/nginx start", :sudo => true }
end

dep 'nginx' do
	requires 'webserver.nginx', 'nginx.dirs', 'conf.nginx', 'init_d.nginx', 'started.nginx', 'deploy user can restart.nginx'
end

dep 'deploy user can restart.nginx' do
	def is_sudoer?; shell("grep '/etc/init.d/nginx' /etc/sudoers"); end

	met? { is_sudoer? }
	meet {
		sudo "cp /etc/sudoers /tmp/sudoers.new && echo 'deploy ALL=NOPASSWD: /etc/init.d/nginx' >> /tmp/sudoers.new && visudo -c -f /tmp/sudoers.new && cp /tmp/sudoers.new /etc/sudoers && rm /tmp/sudoers.new"
	}
end	
	
dep 'libcurl4-openssl-dev.managed' do
	provides []
end

dep 'passenger.gem' do
	requires '1.9.2.rvm' 
	installs 'passenger 3.0.0'
	provides 'passenger-install-nginx-module'
end

dep 'nginx.dirs' do
	requires 'deploy.group'
	dirs '/var/log/nginx', '/opt/nginx/conf', '/opt/nginx/conf/sites-enabled', '/var/www/root'
	user 'root'
	group 'deploy'
	mask '2774'			# drwrwxs--
end
