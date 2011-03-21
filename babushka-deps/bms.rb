dep 'bms' do
	requires 'platform', 'bms.dirs', 'bms.webservice'
end

dep 'bms.dirs' do
	requires 'deploy.user', 'deploy.userkey', 'deploy.group'
	dirs '/var/log/bms', '/opt/bms', '/opt/bms/releases', '/opt/bms/shared', '/opt/bms/shared/system',  '/opt/bms/shared/log',  '/opt/bms/shared/pids'
	user 'deploy'
	group 'deploy'
	mask '2774'			# drwrwxs--
end

dep 'bms.webservice' do
	requires 'deploy.user', 'bms symlink exists'
end

dep 'bms symlink exists' do
	met? { FileTest.symlink?("/var/www/root/bms") }
  meet { sudo "ln -f -s /opt/bms/current/public/ /var/www/root/bms" }
end

