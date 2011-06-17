dep 'castor-services' do
	requres 'castor-services.dirs', 'castor-services.freetds'
end

dep 'castor-services.freetds' do
	shell "apt-get -y install freetds-dev", :sudo => true
end

dep 'castor-services.dirs' do
	requires 'deploy.user', 'deploy.userkey', 'deploy.group'
	dirs '/var/log/castor_services', '/opt/castor_services', '/opt/castor_services/releases', '/opt/castor_services/shared', '/opt/castor_services/shared/system',  '/opt/castor_services/shared/log',  '/opt/castor_services/shared/pids'
	user 'deploy'
	group 'deploy'
	mask '774'			# drwrwxs--
end

