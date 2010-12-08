#!/bin/bash -l
## DO NOT change the shebang!

function is_root {
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
	echo "The installation process requires to be run as root. Consider using sudo."
	false
fi
}

function welcome {
	echo "Welcome to the platform installer. Take a seat and lean back!"
}

### Include rvm installation functions
source rvm.sh		# imports install_rvm function

### Include ruby 1.9.2 installation functions
source ruby192.sh

### Include babushka
source babushka.sh

function platform_install {
	welcome && is_root &&
	install_rvm && install_ruby192 &&
	babushka_run
}

function run {
	platform_install
}
