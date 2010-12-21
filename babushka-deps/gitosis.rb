dep 'gitosis.server' do
	requires 'gitosis', 'git_daemon', 'openssh-server.managed'
end

meta 'gitosis' do
	template{}
end

# installation according to this help http://scie.nti.st/2007/11/14/hosting-git-repositories-the-easy-and-secure-way
dep 'gitosis' do
	requires 'python-setuptools.managed', 'git-core.managed', 'git.user'
	helper(:post_update) { "/home/git/repositories/gitosis-admin.git/hooks/post-update" }
	helper(:post_update_executable?) { File.lstat(post_update).mode.to_s(8) =~ /755/ } 
	
	met? { File.exists? "/home/git/repositories/gitosis-admin.git" and 
		post_update_executable?
 		}
	meet do
    git "git://eagain.net/gitosis.git" do |path|
      log_shell "Setting up gitosis", "python setup.py install"
    end

		sudo "echo '#{var(:pub_key)}' > /tmp/id_rsa.pub && sudo -H -u git gitosis-init < /tmp/id_rsa.pub" 
		sudo "chmod 755 #{post_update}" unless post_update_executable?
	end

	after {
		ip = shell("ifconfig  | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}'")
		puts "Now do:
		git clone git@#{ip}:gitosis-admin.git
		cd gitosis-admin
		
		edit gitosis.conf to add repos
		add keys to keydir
		"
	}
end

dep 'git_daemon' do
	requires 'git-core.managed', 'started.git_daemon'
end

dep 'init_d.git_daemon' do
	met? { File.exists? "/etc/init.d/git-daemon" }
	meet {
		render_erb "git/git-daemon.erb", :to => '/etc/init.d/git-daemon', :perms => '755', :sudo => true
		sudo 'update-rc.d git-daemon defaults'
	}
end

dep 'started.git_daemon' do
	requires 'init_d.git_daemon'
	met? { shell("ps aux | grep git-daemon")[" git-daemon "] }
	meet { shell "/etc/init.d/git-daemon start", :sudo => true }
end

dep 'git.user' do
	meet { sudo "adduser --system --shell /bin/sh --gecos 'git version control' --group --disabled-password --home /home/git git" }
end

dep 'python-setuptools.managed' do
	provides 'python'
end

dep 'git-core.managed' do
	provides 'git'
end

dep 'openssh-server.managed' do
	provides 'sshd'
end
