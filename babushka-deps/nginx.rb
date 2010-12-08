meta 'nginx' do
	template {
		helper(:passenger_default_user) { "xenia" }
		helper(:passenger_root) { Babushka::GemHelper.gem_path_for('passenger') }
		helper(:log_path) { var(:log_path) }
		helper(:nginx_prefix) { var(:nginx_prefix) }
		helper(:conf_path) { var(:nginx_prefix) / "conf/nginx.conf" }
		
		setup {
			define_var :nginx_prefix, :message => "Nginx default prefix", :default => '/opt/nginx'
			define_var :log_path, :message => "Error log path", :default => "/var/log/nginx"
		}
	}
end

dep 'webserver.nginx' do
	requires 'libcurl4-openssl-dev.managed'

	met? { File.executable?(var(:nginx_prefix) / 'sbin/nginx') }
	meet {
		log_shell "Installing nginx via passenger", "#{passenger_root}/bin/passenger-install-nginx-module --prefix='#{var(:nginx_prefix)}' --auto-download --extra-configure-flags='--with-http_ssl_module' --auto"
		shell "rm #{conf_path}", :sudo => true	# remove the default config
	}	
end

dep 'conf.nginx' do
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

dep 'nginx' do
	requires 'webserver.nginx', 'nginx.dirs', 'conf.nginx', 'init_d.nginx'
end
	
dep 'libcurl4-openssl-dev.managed' do
	provides []
end

dep 'passenger.gem' do
	requires '1.9.2.rvm' 
	installs 'passenger' => '3.0.0'
	provides 'passenger-install-nginx-module'
end

dep 'nginx.dirs' do
	requires 'deploy.group'
	dirs '/var/log/nginx', '/opt/nginx/conf', '/var/www/root'
	user 'root'
	group 'deploy'
	mask '2774'			# drwrwxs--
end
