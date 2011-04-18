#!/bin/bash -l

rvm_install_path="$install_dir/rvm_install"
mkdir -p $rvm_install_path

function is_rvm_installed {
	[[ "`type rvm | head -n1`"	== "rvm is a function" ]]
}

### add the rvm script so it is run by all users and run it so it is available in the current session
function rvm_install_to_profile {
	cat > $rvm_install_path/rvm.sh <<EOF                                                                                              
[[ -s "/usr/local/rvm/scripts/rvm" ]] && . "/usr/local/rvm/scripts/rvm" # This loads RVM into a shell session
EOF
	cp $rvm_install_path/rvm.sh /etc/profile.d/rvm.sh
	chmod a+x /etc/profile.d/rvm.sh
  source /usr/local/rvm/scripts/rvm   # load rvm into the current session 
}

function rvm_install_failed {
	echo "Rvm install failed :("
	exit 1
}

### to run ruby and native gems with extensions we need those:
function install_rvm {
	if is_rvm_installed; then
		echo "Rvm is already installed"
		true
	else
		echo "Installing rvm"
		mkdir -p $rvm_install_path
		apt-get -q update
		echo "Downloading and installing system pre-requisites"
		apt-get install -qq -y libruby1.8 zlib1g-dev libssl-dev libreadline5-dev build-essential libxslt-dev libxml2-dev curl git-core
		curl -# -L https://rvm.beginrescueend.com/install/rvm -o $rvm_install_path/rvm-installer
    chmod +x $rvm_install_path/rvm-installer
		bash -l -c "$rvm_install_path/rvm-installer 1.6.3"

		usermod -a -G rvm $USER
		rvm_install_to_profile
		is_rvm_installed
	fi
}

