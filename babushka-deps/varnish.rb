dep 'varnish' do
	requires 'varnish.managed', 'conf.varnish', 'started.varnish'
end

meta 'varnish' do

end

dep 'conf.varnish' do
	met? { File.exists?("/etc/varnish/default.conf") }
	meet { render_erb "varnish/varnish.conf", :to => conf_path, :sudo => true }
end

dep 'started.varnish' do
	met? { shell("ps aux | grep varnish | grep -v grep") }
	meet { shell("/etc/init.d/varnish start") }
end
