meta 'god' do
  requires 'god.gem'
end
  
dep 'god.gem' do
	required '1.9.2.rvm'
	installs 'god'
	provides 'god'
end

dep 'god' do
  requires 'init_d.god', 'conf.god', 'started.god'

end

dep 'init_d.god' do
	met? { File.exists? "/etc/init.d/god" }
	meet { 
		render_erb "god/init.d.erb", :to => '/etc/init.d/god', :perms => '755', :sudo => true
		sudo 'update-rc.d god defaults'
	}
end

dep 'started.god' do
	met? { shell("ps aux | grep 'bin/god' | grep -v grep")["bin/god"] }
	meet { shell "/etc/init.d/god start", :sudo => true }
end

dep 'conf.god' do
  met? { File.exists? "/opt/god.rb" }
  meet { 
		render_erb "god/god.rb", :to => '/opt/god.rb', :perms => '755', :sudo => true
  }
end
