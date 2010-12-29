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
		def uid; @uid ||= shell("grep '^#{basename}' /etc/passwd").split(":")[2].to_i; end
		def gid; @gid ||= shell("grep '^#{basename}' /etc/group").split(":")[2].to_i; end
		def stat(dir); File.lstat(dir); end
		def permitted?; File.lstat(ssh_path).mode.to_s(8) == "40644"; end
		def ownership?; stat(home_path).uid == uid && stat(home_path).gid == gid; end
		def fix_permissions; shell "chmod 644 -R #{ssh_path}"; end
		def fix_ownership; shell "chown #{basename}:#{basename} -R #{home_path}"; end
		def contains_key?; shell "grep '#{pub_key}' #{authorized_keys_path}"; end
		def create_ssh_path; shell "mkdir -p -m 644 #{ssh_path}"; end
		def append_pub_key; shell "echo '#{pub_key}' >> #{authorized_keys_path} && chown #{basename}:#{basename} #{authorized_keys_path}"; end

		met? { contains_key? && permitted? && ownership? }
		meet {
			create_ssh_path unless File.directory?(ssh_path)
			fix_permissions unless permitted?
			fix_ownership unless ownership?
			append_pub_key	unless contains_key?
		}	
	}
end

meta 'group' do
	template {
		met? { grep /^#{basename}\:/, '/etc/group' }
		meet { sudo "groupadd --system -f #{basename}" }
	}
end

