#!/bin/bash -l

function is_ruby192_installed {
[[ `rvm list` =~ "ruby-1.9.2-p0" ]]
}

function install_ruby192 {
if is_ruby192_installed; then
	echo "Ruby 1.9.2 is already installed"
else
	rvm install 1.9.2
	rvm use 1.9.2 --default
	is_ruby192_installed
fi
}
