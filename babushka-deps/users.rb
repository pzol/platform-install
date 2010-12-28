meta 'user' do
	template {
		met? { grep /^#{basename}\:/, '/etc/passwd' }
		meet { sudo "useradd -g deploy --create-home --system -s /bin/false #{basename}" }
	}
end

meta 'userkey' do
	template {
		def pub_key; var(:pub_key); end
		def ssh_path; "/home/#{basename}/.ssh"; end
		def authorized_keys_path; File.join(ssh_path, "authorized_keys"); end
		def permitted?; File.lstat(ssh_path).mode.to_s(8) == "40755"; end
		def fix_permissions; shell "chmod 755 -R #{ssh_path}"; end
		def contains_key?; shell "grep '#{pub_key}' #{authorized_keys_path}"; end
		def create_ssh_path; shell "mkdir -p -m 755 #{ssh_path}"; end
		def append_pub_key; shell "echo '#{pub_key}' >> #{authorized_keys_path} && chown #{basename}:#{basename} #{authorized_keys_path}"; end

		met? { contains_key? && permitted? }
		meet {
			create_ssh_path unless File.directory?(ssh_path)
			fix_permissions unless permitted?
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

