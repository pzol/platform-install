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
  requires 'god.gem', 'init_d.god', 'conf.god', 'started.god'

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
	met? { shell("ps aux | grep 'bin/god' | grep -v grep | wc -l")["1"] rescue false }
	meet { shell "/etc/init.d/god start", :sudo => true }
end

dep 'conf.god' do
  met? { File.exists? "/opt/god.rb" }
  meet { 
		render_erb "god/god.rb.erb", :to => '/opt/god.rb', :perms => '755', :sudo => true
  }
end
