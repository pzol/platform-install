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
		def contains_key?; grep(/#{pub_key}/, authorized_keys); end
		def create_ssh_path; shell "mkdir -p #{ssh_path}"; end
		def append_pub_key; shell "echo '#{pub_key} >> #{authorized_keys_path}'"; end

		met? { contains_key? }
		meet {
			create_ssh_path unless File.exist?(ssh_path)
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

