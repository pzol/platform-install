meta 'god' do
  template {
    requires 'god.gem'
  }
end
  
dep 'god.gem' do
	requires '1.9.2.rvm'
	installs 'god'
	provides 'god'
end

dep 'god' do
  requires 'god.gem', 'god.dirs', 'init_d.god', 'conf.god', 'started.god'

end

dep 'god.dirs' do
	requires 'deploy.user', 'deploy.group'
	dirs '/opt/god', '/opt/god/conf.d', '/var/log'
	user 'deploy'
	group 'deploy'
	mask '744'			# drwrwxs--
end

dep 'init_d.god' do
	met? { File.exists? "/etc/init.d/god" }
	meet { 
		render_erb "god/init.d.erb", :to => '/etc/init.d/god', :perms => '755', :sudo => true
		sudo 'update-rc.d god defaults'
	}
end

dep 'started.god' do
  requires 'init_d.god', 'conf.god'
	met? { shell("ps -e -o pid,args | grep [b]in/god | wc -l").to_i == 1 }
	meet { shell "/etc/init.d/god start", :sudo => true }
end

dep 'conf.god' do
  def config_path; "/opt/god/god.rb"; end
  met? { File.exists? config_path}
  meet { render_erb "god/god.rb.erb", :to => config_path, :perms => '744', :sudo => true }
end
