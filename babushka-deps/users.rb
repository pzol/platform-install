meta 'user' do
	template {
		met? { grep /^#{basename}\:/, '/etc/passwd' }
		meet { sudo "useradd -g deploy --create-home --system -s /bin/false #{basename}" }
	}
end

meta 'group' do
	template {
		met? { grep /^#{basename}\:/, '/etc/group' }
		meet { sudo "groupadd --system -f #{basename}" }
	}
end

