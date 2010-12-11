cd /opt/platform-install

source install.sh 

function run_update {
	echo "Getting newest files from repo"
	git pull
	echo "Running update"
	run
}

is_root && run_update
