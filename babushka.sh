#!/bin/bash -l

function is_babushka_installed {
[[ -s /usr/local/bin/babushka ]]
}

function install_babushka {
	if is_babushka_installed; then
		echo "Babushka is already installed"
		true
	else
		curl -# -L http://babushka.me/up/hard > $install_dir/babushka.sh
		bash -l < $install_dir/babushka.sh
		is_babushka_installed
	fi
}

function babushka_platform {
	babushka -y 'platform'
}

function babushka_list_servers {
	babushka -T | grep -R ".server'$" | sed 's/current dir://'
}

function babushka_done {
	source /usr/local/rvm/scripts/rvm
	if [ -e '/opt/platform-install' ]; then 
		cd /opt/platform-install
	fi
	echo "Now run babushka with a server role:"
	babushka_list_servers
}

function babushka_run {
	install_babushka && 
	babushka_platform &&
	babushka_done
}

