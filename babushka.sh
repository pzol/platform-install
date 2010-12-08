#!/bin/bash -l

babushka_install_path="$HOME/xenia_install"
babushka_xenia_path="$babushka_install_path/xenia"
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

function babushka_xenia {
	if [[ -s "$babushka_xenia_path" ]]; then
		current_dir=`pwd`
		cd $babushka_xenia_path
		babushka 'xenia'
		cd $current_dir
	else
		echo "Missing xenia sources in $babushka_xenia_path, get them first (I won't do that for you)"
	fi
}

function babushka_cleanup {
	rm -rf $babushka_xenia_path
}

function babushka_run {
	install_babushka && 
	babushka_xenia
	# babushka_cleanup
}

