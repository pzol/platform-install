#!/bin/bash -l
## DO NOT change the shebang!

xenia_install_path="$HOME/xenia_install"
mkdir -p $xenia_install_path 

function is_root {
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
	echo "The installation process requires to be run as root. Consider using sudo."
	false
fi
}

function welcome {
	echo "Welcome to the xenia installer. Take a seat and lean back!"
}

### Include rvm installation functions
source rvm.sh		# imports install_rvm function

### Include ruby 1.9.2 installation functions
source ruby192.sh

### Include babushka
source babushka.sh

function clone_repo {
	if [[ -s "$xenia_install_path/xenia" ]]; then 
		current_dir=`pwd`
		cd $xenia_install_path/xenia
		git pull
		cd $current_dir
	else
	echo "Cloning xenia repo"
		git clone --depth 1 ssh://xenia@194.213.22.181/var/git/xenia $xenia_install_path/xenia
		rvm rvmrc trust $xenia_install_path/xenia
	fi
}

function xenia_cleanup {
	echo "Removing installation files from $xenia_install_path"
	rm -rf $xenia_install_path
}

function xenia_install {
	welcome && is_root &&
	install_rvm && install_ruby192 &&
	clone_repo && 
	babushka_run

	xenia_cleanup
}

function run {
	xenia_install
}
