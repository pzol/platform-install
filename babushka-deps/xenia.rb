dep 'xenia', :for => :linux  do
	requires 'platform', 'xenia_etc_environment', 'xenia.dirs', 'xenia.webservice', 'xenia_crontab' 
	met? { File.directory? "/opt/xenia" }
	meet {
		git "ssh://194.213.22.181/var/git/xenia" do |path|
			shell "cap setup -s server=127.0.0.1 && cap deploy -s server=127.0.0.1"
		end
	}
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

dep 'xenia_crontab' do
	requires 'deploy.user'
	met? { !(failable_shell("crontab -u deploy -l").stderr["no crontab"]) } #TODO: Compare if it is up to date
	meet { shell "pwd"; sudo "crontab -u deploy install/crontab_fti" }
end
