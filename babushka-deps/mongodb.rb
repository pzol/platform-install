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

	met? {
		provided? and
		File.exists?("/etc/init.d/mongodb")
	}

	preconfigure { sudo "mkdir -p #{prefix}" }
  install { 
		log_shell "Copying files", "cp -r * #{prefix}", :sudo => true 
		render_erb 'mongodb/mongodb.init.d.erb', :to => '/etc/init.d/mongodb', :perms => '755', :sudo => true
		sudo 'update-rc.d mongodb defaults'
	}
end
