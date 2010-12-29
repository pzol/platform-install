dep 'platform', :for => :linux  do
	requires 'ruby_with_gems',  'deploy.user', 'deploy.userkey', 'deploy.group', 'root has deploy key', 'admin_tools'
end

dep 'deploy.user'

dep 'root has deploy key' do 	# we need this to be able to deploy to localhost
	requires 'deploy.user', 'root key exists'
	met? { shell "grep \"`cat /root/.ssh/id_rsa.pub`\" /home/deploy/.ssh/authorized_keys" }
	meet { shell "cat /root/.ssh/id_rsa.pub >> /home/deploy/.ssh/authorized_keys"	}
end

dep 'root key exists' do
	met? { File.exist?("/root/.ssh/id_rsa") && File.exist?("/root/.ssh/id_rsa.pub") }
	meet { shell "mkdir -p  /root/.ssh && ssh-keygen -N '' -f /root/.ssh/id_rsa -t rsa -q" }
end

dep 'deploy.group'
dep 'deploy.userkey'
