dep 'xenia', :for => :linux  do
	requires 'platform', 'xenia_etc_environment', 'xenia.dirs', 'xenia.webservice', 'xenia_crontab' 
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
