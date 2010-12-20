dep 'proxyacc.server' do
	requires 'mongodb.setup', 'nginx', 'varnish', 'xenia'
end
