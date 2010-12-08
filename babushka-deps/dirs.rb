meta 'dirs' do
	accepts_list_for :dirs
	accepts_value_for :user
	accepts_value_for :group
	accepts_value_for :mask		#TODO: currently must be 4 digits, ie 0774 and NOT 774

	template {
		helper(:uid) { @uid ||= shell("grep '^#{user}' /etc/passwd").split(":")[2].to_i }
		helper(:gid) { @gid ||= shell("grep '^#{group}' /etc/group").split(":")[2].to_i }

		helper(:stat) 			{|dir| File.lstat(dir) }
		helper(:permitted?) {|dir| stat(dir).mode.to_s(8) == "4#{mask}" }
		helper(:exists?) 		{|dir| File.directory?(dir) }
		helper(:ownership?) {|dir| stat(dir).uid == uid && stat(dir).gid == gid }

		helper(:create) 				{|dir| log_shell "Creating dir #{dir}", "mkdir -p -m #{mask} #{dir}", :sudo => true }
		helper(:set_permission) {|dir| log_shell "Setting permission #{mask} on #{dir}", "chmod #{mask} #{dir}", :sudo => true }
		helper(:set_owner) 			{|dir| log_shell "Setting owner #{user}:#{group} on #{dir}", "chown #{uid}:#{gid} #{dir}", :sudo => true }

		met? do dirs.all? {|dir| exists?(dir) and permitted?(dir) and ownership?(dir) } end
		meet {
			dirs.each {|dir|
				create(dir) unless exists?(dir)
				set_permission(dir) unless permitted?(dir)
				set_owner(dir) unless ownership?(dir)
			}
		}
	}
end

