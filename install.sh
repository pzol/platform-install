#!/bin/bash -l

source is_root.sh

function welcome {
	echo "Welcome to the platform installer. Take a seat and lean back!"
}

### Include rvm installation functions
source rvm.sh		# imports install_rvm function

### Include ruby 1.9.2 installation functions
source ruby192.sh

### Include babushka
source babushka.sh

function install_done {
	echo "\nAll done."
	echo "To update use update.sh and the rerun babushka with the server role"

function platform_install {
	welcome && is_root &&
	install_rvm && install_ruby192 &&
	babushka_run && install_done
}

function run {
	platform_install
}
