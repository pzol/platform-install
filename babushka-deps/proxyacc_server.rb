dep 'proxyacc.server' do
	requires 'mongodb.setup', 'nginx', 'xenia'#, 'varnish'
end
