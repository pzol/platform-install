dep 'platform', :for => :linux  do
	requires 'ruby_with_gems', 'mongodb.setup', 'deploy.user', 'nginx'
end

dep 'deploy.user' do
	requires 'deploy.group'
end

dep 'deploy.group'

