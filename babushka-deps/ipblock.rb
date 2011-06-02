# require 'RunHelpers'
include Babushka::RunHelpers

dep "ipblock-script" do
  requires "iptables.managed", "anxscript.dirs", "ipblock-file", "iptables-startup-restore", "iptables-startup-save"
end


dep "ipblock-file" do
  met? { File.exists?("/var/anx/bin/script/ipblock.sh") }
  meet { render_erb "ipblock/ipblock.sh", :to => "/var/anx/bin/script/ipblock.sh", :perms => '755', :sudo => true }
end

dep "iptables-startup-restore" do
  met? { File.exists?("/etc/network/if-pre-up.d/iptablesload") }
  meet { render_erb "ipblock/iptablesload", :to => "/etc/network/if-pre-up.d/iptablesload", :perms => '755', :sudo => true }
end

dep "iptables-startup-save" do
  met? { File.exists?("/etc/network/if-post-down.d/iptablessave") }
  meet { render_erb "ipblock/iptablessave", :to => "/etc/network/if-post-down.d/iptablessave", :perms => '755', :sudo => true }
end


dep 'anxscript.dirs' do
        dirs '/var/anx/bin/script/'
        user 'root'
        group 'root'
        mask '775'                      # drwrwxs--
end


dep 'iptables.managed'