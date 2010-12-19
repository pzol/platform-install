dep 'platform', :for => :linux  do
	requires 'ruby_with_gems',  'deploy.user', 'admin_tools'
end

dep 'deploy.user' do
	requires 'deploy.group'
end

dep 'deploy.group'

