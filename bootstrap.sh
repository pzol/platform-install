export install_dir=`mktemp -d platform.XXXX`
cd $install_dir
wget --no-check-certificate -nv https://github.com/pzol/platform-install/tarball/master
tar xzf master
cd pzol-platform-install-*
. ./install.sh && run
cd ..
echo "Installation files are in $install_dir, please remove manually"

