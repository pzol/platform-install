cd /opt
apt-get -qq install git-core
export install_dir=$(cd `mktemp -d platform-install.XXXX`; pwd)
git clone git://github.com/pzol/platform-install.git
# wget --no-check-certificate -nv https://github.com/pzol/platform-install/tarball/master
# tar xzf master
cd platform-install
. ./install.sh $install_dir && run
cd ..
echo "Installation files are in $install_dir, please remove manually"

