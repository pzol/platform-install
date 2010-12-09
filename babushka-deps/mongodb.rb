dep 'mongodb.dirs' do
	dirs '/var/data/mongodb', '/var/log/mongodb', '/opt/mongodb'
	user 'root'
	group 'root'
	mask '0775'
end

dep 'mongodb.setup' do
	requires 'mongodb.dirs'

	prefix "/opt/mongodb"
	source "http://fastdl.mongodb.org/linux/mongodb-linux-#{`uname -m`.chomp}-1.6.4.tgz" 
  provides 'mongod', 'mongo'

	helper(:copy_files) { log_shell "Copying files", "cp -r * #{prefix}", :sudo => true }
	helper(:init_d_exists?) { File.exists?("/etc/init.d/mongodb") }
	helper(:render_init_d) { 
		render_erb 'mongodb/mongodb.init.d.erb', :to => '/etc/init.d/mongodb', :perms => '755', :sudo => true 
		sudo 'update-rc.d mongodb defaults'
	}

	met? {
		provided? and
		init_d_exists?
	}

	preconfigure { sudo "mkdir -p #{prefix}" }
  install { 
		copy_files 		unless provided?
		render_init_d unless init_d_exists?
	}
	postconfigure { sudo "/etc/init.d/mongodb start" }
end
