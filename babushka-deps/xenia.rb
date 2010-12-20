dep 'xenia', :for => :linux  do
	requires 'platform', 'xenia_etc_environment', 'xenia.dirs', 'xenia_app', 'xenia.webservice'
	met? { File.directory? "/opt/xenia" }
	meet {
		git "ssh://xenia@194.213.22.181/var/git/xenia" do |path|
			shell "cap deploy:setup -s server=127.0.0.1 && cap deploy -s server=127.0.0.1"
		end
	}
end

dep 'xenia_app' do
	requires 'platform', 'xenia_etc_environment', 'xenia.dirs'
end

dep 'xenia_etc_environment' do
	met? { shell "grep XENIA_CFG /etc/environment" }
	meet { append_to_file 'XENIA_CFG=fti', '/etc/environment', :sudo => true }
end

dep 'xenia.dirs' do
	requires 'deploy.user', 'deploy.group'
	dirs '/var/data/xenia', '/var/log/xenia', '/var/data/export'
	user 'deploy'
	group 'deploy'
	mask '2774'			# drwrwxs--
end

dep 'xenia.webservice' do
	requires 'deploy.user'
end
