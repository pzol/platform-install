dep 'platform', :for => :linux  do
	requires 'ruby_with_gems',  'deploy.user', 'admin_tools'
end

dep 'deploy.user' do
	requires 'deploy.group', 'deploy.userkey'
end

dep 'deploy.group'

dep 'deploy.userkey'
