#! /bin/bash -l
export install_dir=$(cd `mktemp -d platform-install-temp.XXXX`; pwd)

function is_root { # yes, I need to repeat this... coz this needs to run 
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
	echo "The installation process requires to be run as root. Consider using sudo."
	false
fi
}

function fix_permissions {
	chmod -R 775 /opt/platform-install
	}

function pull_source {
	apt-get -qq install git-core
	if [ ! -e "/opt/platform-install" ]; then
		git clone git://github.com/pzol/platform-install.git
	else
		echo $(cd platform-install && git pull)
	fi	
}

function done_message {
	echo "Temporary installation files are in $install_dir, please remove manually"
	echo "Platform installation scripts are in platform-install. For updates and repair run update.sh"
}

source ./install.sh
cd /opt

is_root && 
pull_source && 
run && 
done_message




