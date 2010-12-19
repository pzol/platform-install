function is_root {
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
	echo "The installation process requires to be run as root. Consider using sudo."
	false
fi
}
