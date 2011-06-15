dep 'redis.init_d' do
	met? { File.exists? "/etc/init.d/redis-server" }
	meet { 
		render_erb "redis/init.d.erb", :to => '/etc/init.d/redis-server', :perms => '755', :sudo => true
		sudo 'update-rc.d redis-server defaults'
	}
end

dep 'redis.dirs' do
	dirs '/var/log/redis', '/var/lib/redis'
	user 'deploy'
	group 'deploy'
	mask '0775'
end

dep 'redis.started' do
	met? { shell("ps aux | grep redis | grep -v grep") }
	meet { shell("/etc/init.d/redis-server start") }
end

dep 'redis' do
  requires 'redis-server.managed', 'redis.init_d', 'redis.dirs', 'redis.started'
end

dep 'redis-server.managed' do
  provides 'redis-server' 
end
