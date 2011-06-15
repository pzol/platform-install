dep 'redis.init_d' do
	met? { File.exists? "/etc/init.d/redis-server" }
	meet { 
		render_erb "redis/init.d.erb", :to => '/etc/init.d/redis-server', :perms => '755', :sudo => true
		sudo 'update-rc.d redis-server defaults'
	}
end

dep 'redis.dirs' do
	dirs '/var/log/redis', '/var/lib/redis', '/etc/redis'
	user 'deploy'
	group 'deploy'
	mask '0775'
end

dep 'redis.started' do
	met? { File.exists? "/var/run/redis.pid" }
	meet { shell("/etc/init.d/redis-server start") }
end

dep 'redis.config' do
	met? { File.exists? "/etc/redis/redis.conf" }
  meet { 
		render_erb "redis/redis.conf", :to => "/etc/redis/redis.conf", :sudo => true 
	}
end

dep 'redis' do
  requires 'redis-server.managed', 'redis.init_d', 'redis.dirs', 'redis.config', 'redis.started'
end

dep 'redis-server.managed' do
  provides 'redis-server' 
end
