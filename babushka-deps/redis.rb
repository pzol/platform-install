dep 'redis.init_d' do
	met? { File.exists? "/etc/init.d/redis-server" }
	meet { 
		render_erb "redis/init.d.erb", :to => '/etc/init.d/redis-server', :perms => '755', :sudo => true
		sudo 'update-rc.d redis-server defaults'
	}
end

dep 'redis.dirs' do
	dirs '/var/log/redis', '/var/lib/redis', '/etc/redis', '/opt/redis'
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

dep 'redis.server' do
  met? { Path.exists? "/opt/redis" }
  meet {
    shell 'mkdir /tmp/redis && cd /tmp/redis && wget http://redis.googlecode.com/files/redis-2.2.10.tar.gz && tar zxf redis-2.2.10.tar.gz && cd redis-2.2.10 && make PREFIX=/opt/redis && make install PREFIX=/opt/redis && rm /tmp/redis -rf'
  }
end

dep 'redis' do
  requires 'redis.server', 'redis.init_d', 'redis.dirs', 'redis.config', 'redis.started'
end
