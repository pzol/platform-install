dep 'redis' do
  requires 'redis-server.managed'
end

dep 'redis-server.managed' do
  provides 'redis-server' 
end
