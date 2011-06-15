dep 'init_d.redis' do
	met? { File.exists? "/etc/init.d/redis" }
	meet { 
		render_erb "redis/init.d.erb", :to => '/etc/init.d/redis', :perms => '755', :sudo => true
		sudo 'update-rc.d redis defaults'
	}
end

dep 'started.redis' do
	met? { shell("ps aux | grep redis") }
	meet { shell "/etc/init.d/redis-server start", :sudo => true }
end

dep 'redis' do
  requires 'redis-server.managed', 'init_d.redis', 'started.redis'
end

dep 'redis-server.managed' do
  provides 'redis-server' 
end
