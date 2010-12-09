temp_dir=`mktemp -d platform.XXXX`
cd $temp_dir
wget --no-check-certificate -nv https://github.com/pzol/platform-install/tarball/master
tar xzf master
cd pzol-platform-install-*
. ./install.sh && run
cd ..
echo "Installation files are in $temp_dir, please remove manually"

