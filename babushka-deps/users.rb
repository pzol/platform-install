meta 'user' do
	template {
		met? { grep /^#{basename}\:/, '/etc/passwd' }
		meet { sudo "useradd --user-group --create-home --system -s /bin/bash #{basename}" }
	}
end

meta 'userkey' do
	template {
		def pub_key; var(:pub_key); end
		def home_path; "/home/#{basename}"; end
		def ssh_path; "#{home_path}/.ssh"; end
		def authorized_keys_path; File.join(ssh_path, "authorized_keys"); end
		def uid
			@uid ||= shell("grep '^#{basename}' /etc/passwd").split(":")[2].to_i rescue 0
		end
		def gid; 
			@gid ||= shell("grep '^#{basename}' /etc/group").split(":")[2].to_i rescue 0
		end
		def stat(dir); File.lstat(dir); end
		def permitted?; File.lstat(ssh_path).mode.to_s(8) == "40755"; end
		def ownership?; stat(home_path).uid == uid && stat(home_path).gid == gid; end
    def ssh_ownership?; stat(ssh_path).uid == uid && stat(ssh_path).gid == gid; end
		def fix_permissions; shell "chmod 755 -R #{ssh_path}"; end
		def fix_ownership; shell "chown #{basename}:#{basename} -R #{home_path}"; end
    def fix_ssh_ownership; shell "chown #{basename}:#{basename} -R #{ssh_path}"; end
		def contains_key?; shell "grep '#{pub_key}' #{authorized_keys_path}"; end
    def contains_own_key?; File.exist?(File.join(ssh_path, "id_rsa.pub")); end
    def create_own_key; shell "su #{basename} -c 'ssh-keygen -q -t rsa -f #{ssh_path}/id_rsa -N \"\"'"; end
		def create_ssh_path; shell "mkdir -p -m 755 #{ssh_path}"; end
    def create_authorized_keys_path; shell "touch #{authorized_keys_path}"; end
		def append_pub_key; shell "echo '#{pub_key}' >> #{authorized_keys_path} && chown #{basename}:#{basename} #{authorized_keys_path}"; end

		met? { File.directory?(ssh_path) && File.exist?(authorized_keys_path) && contains_key? && permitted? && ownership? && ssh_ownership? && contains_own_key?}
		meet {
			create_ssh_path unless File.directory?(ssh_path)
      create_authorized_keys_path unless File.exist?(authorized_keys_path)
			fix_permissions unless permitted?
			fix_ownership unless ownership?
      fix_ssh_ownership unless ssh_ownership?
      create_own_key unless contains_own_key?
			append_pub_key unless contains_key?
		}	
	}
end

meta 'group' do
	template {
		met? { grep /^#{basename}\:/, '/etc/group' }
		meet { sudo "groupadd --system -f #{basename}" }
	}
end

