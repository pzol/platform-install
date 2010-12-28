meta 'dirs' do
	accepts_list_for :dirs
	accepts_value_for :user
	accepts_value_for :group
	accepts_value_for :mask		#TODO: currently must be 4 digits, ie 0774 and NOT 774

	template {
		def uid
			@uid ||= shell("grep '^#{user}' /etc/passwd").split(":")[2].to_i
		end
		
		def gid
			@gid ||= shell("grep '^#{group}' /etc/group").split(":")[2].to_i
		end

		def stat(dir)
			File.lstat(dir)
		end

		def permitted?(dir)
			stat(dir).mode.to_s(8) == "4#{mask}"
		end

		def exists?(dir)
			File.directory?(dir)
		end

		def ownership?(dir)
			stat(dir).uid == uid && stat(dir).gid == gid
		end

		def create(dir)
		 	log_shell "Creating dir #{dir}", "mkdir -p -m #{mask} #{dir}", :sudo => true
		end

		def set_permission(dir)
			log_shell "Setting permission #{mask} on #{dir}", "chmod #{mask} #{dir}", :sudo => true 
		end

		def set_owner(dir)
			log_shell "Setting owner #{user}:#{group} on #{dir}", "chown #{uid}:#{gid} #{dir}", :sudo => true
		end

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

