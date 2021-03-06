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
	requires 'libcurl4-openssl-dev.managed', 'passenger.gem', 'nginx_ruby.god'

	met? { File.executable?(var(:nginx_prefix) / 'sbin/nginx') }
	meet {
		log_shell "Downloading and installing nginx via passenger",
	 						"#{passenger_root}/bin/passenger-install-nginx-module --prefix='#{var(:nginx_prefix)}' --auto-download --extra-configure-flags='--with-http_ssl_module' --auto"
		shell "rm #{conf_path}", :sudo => true	# remove the default config
	}	
end

dep 'conf.nginx' do
	requires 'deploy.user', 'sites.nginx'
	met? { File.exists? conf_path }
  meet { 
		render_erb "nginx/nginx.conf", :to => conf_path, :sudo => true 
		shell "touch #{nginx_prefix}/conf/access-list", :sudo => true
	}
end

dep 'sites.nginx' do
	requires 'sites-enabled.nginx', 'ruby.nginx', 'castor3.nginx'
end

dep 'ruby.nginx' do
	def path; "#{nginx_prefix}/conf/sites-enabled/ruby"; end
	met? { File.exists? path }
	meet { render_erb "nginx/sites-enabled/ruby", :to => path, :sudo => true }
end

dep 'castor3.nginx' do
	def path; "#{nginx_prefix}/conf/sites-enabled/castor3"; end
	met? { File.exists? path }
	meet { render_erb "nginx/sites-enabled/castor3", :to => path, :sudo => true }
end

dep 'sites-enabled.nginx' do
	met? { File.exists? "#{nginx_prefix}/conf/sites-enabled" }
	meet { shell "mkdir -p #{nginx_prefix}/conf/sites-enabled" }
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
	installs 'passenger 3.0.5'
	provides 'passenger-install-nginx-module'
end

dep 'nginx.dirs' do
	requires 'deploy.group'
	dirs '/var/log/nginx', '/opt/nginx/conf', '/opt/nginx/conf/sites-enabled', '/var/www/root'
	user 'root'
	group 'deploy'
	mask '2774'			# drwrwxs--
end

dep 'nginx_ruby.god' do
	requires 'god'
	def config_path; '/opt/god/conf.d/nginx_ruby.rb'; end
 	met? { File.exists? config_path }
  meet { render_erb "nginx/nginx_ruby_god.rb.erb", :to => config_path, :perms => '744', :sudo => true }
end
