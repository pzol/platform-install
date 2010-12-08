dep 'xenia', :for => :linux  do
	requires 'ruby_with_gems', 'xenia_etc_environment', 'xenia.dirs', 'mongodb.setup', 'xenia.webservice', 'xenia_crontab' 
end

dep 'xenia_etc_environment' do
	met? { shell "grep XENIA_CFG /etc/environment" }
	meet { append_to_file 'XENIA_CFG=fti', '/etc/environment', :sudo => true }
end

dep 'xenia.user' do
	requires 'deploy.group'
end

dep 'deploy.group'

dep 'xenia.dirs' do
	requires 'xenia.user', 'deploy.group'
	dirs '/var/data/xenia', '/var/log/xenia', '/var/data/export', '/opt/xenia/tmp'
	user 'xenia'
	group 'deploy'
	mask '2774'			# drwrwxs--
end

dep 'xenia.webservice' do
	requires 'xenia.user'
end

dep 'xenia_crontab' do
	requires 'xenia.user'
	met? { !(failable_shell("crontab -u xenia -l").stderr["no crontab"]) } #TODO: Compare if it is up to date
	meet { shell "pwd"; sudo "crontab -u xenia install/crontab_fti" }
end
