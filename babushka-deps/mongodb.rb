dep 'mongodb.dirs' do
	dirs '/var/data/mongodb', '/var/log/mongodb', '/opt/mongodb'
	user 'root'
	group 'root'
	mask '0775'
end

dep 'master.mongodb' do
	daemon_opts '--master'
end

meta 'mongodb' do
  accepts_value_for :daemon_opts
	template {
		requires 'mongodb.setup'
	}
end

dep 'mongodb.setup' do
	requires 'mongodb.dirs'

	prefix "/opt/mongodb"
	source "http://fastdl.mongodb.org/linux/mongodb-linux-#{`uname -m`.chomp}-1.6.4.tgz" 
  provides 'mongod', 'mongo'

	def copy_files; log_shell("Copying files", "cp -r * #{prefix}", :sudo => true); end
	def init_d_exists?; File.exists?("/etc/init.d/mongodb"); end
	def render_init_d
		render_erb 'mongodb/mongodb.init.d.erb', :to => '/etc/init.d/mongodb', :perms => '755', :sudo => true 
		sudo 'update-rc.d mongodb defaults'
	end
	def daemon_opts; var(:mongo_daemon_opts); end

	setup {
		define_var :mongo_daemon_opts, :message => "Provide additional options for the daemon like --master", :default => "--master"
	}

	met? {
		provided? and
		init_d_exists?
	}

	preconfigure { sudo "mkdir -p #{prefix}" }
  install { 
		copy_files 		unless provided?
		render_init_d unless init_d_exists?
		sudo "/etc/init.d/mongodb start" 
	}
end
