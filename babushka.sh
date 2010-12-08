#!/bin/bash -l

babushka_install_path="$HOME/platform-install"
mkdir -p $babushka_install_path

function is_babushka_installed {
[[ -s /usr/local/bin/babushka ]]
}

function install_babushka {
	if is_babushka_installed; then
		echo "Babushka is already installed"
		true
	else
		curl -# -L http://babushka.me/up/hard > $babushka_install_path/babushka.sh
		bash -l < $babushka_install_path/babushka.sh
		is_babushka_installed
	fi
}

function babushka_platform {
	babushka 'platform'
}

function babushka_run {
	install_babushka && 
	babushka_platform
}

