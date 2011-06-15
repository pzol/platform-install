dep 'redis.init_d' do
	met? { File.exists? "/etc/init.d/redis" }
	meet { 
		render_erb "redis/init.d.erb", :to => '/etc/init.d/redis', :perms => '755', :sudo => true
		sudo 'update-rc.d redis defaults'
	}
end

dep 'redis.started' do
	met? { shell("ps aux | grep redis") }
	meet { shell "/etc/init.d/redis-server start", :sudo => true }
end

dep 'redis.dirs' do
	dirs '/var/log/redis'
	user 'deploy'
	group 'deploy'
	mask '0775'
end

dep 'redis' do
  requires 'redis-server.managed', 'redis.init_d', 'dirs.redis', 'redis.started'
end

dep 'redis-server.managed' do
  provides 'redis-server' 
end
