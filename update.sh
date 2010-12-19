#! /bin/bash -l
source is_root.sh 

function run_update {
	echo "Getting newest files from repo"
	git pull
	echo "Running update"
	babushka 'platform'
}

is_root && run_update
