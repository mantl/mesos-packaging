set -x
tar -xzf mesos-{{.Version}}.tar.gz

echo `pwd`

## Dependencies
sudo wget https://raw.githubusercontent.com/kazuho/picojson/v1.3.0/picojson.h -O /usr/local/include/picojson.h
sudo yum install -y protobuf-devel protobuf-java protobuf-python boost-devel 

## create an installation
INSTALL={{.BuildRoot}}/out
mkdir $INSTALL || echo "Install dir created"

# glog
wget https://github.com/google/glog/archive/v0.3.4.tar.gz
tar -xzvf v0.3.4.tar.gz
cd glog-0.3.4
./configure
make &>/dev/null
sudo make install &> /dev/null
make install DESTDIR="$INSTALL" &>/dev/null
#make install DESTDIR=/home/vagrant/test &>> /dev/null
cd ..

echo "BUILDING MESOS"

## build mesos
cd mesos-{{.Version}}
./bootstrap
mkdir build
pushd build
../configure --prefix=/usr --with-protobuf=/usr --with-boost=/usr --with-glog=${INSTALL}/usr/local/ --enable-optimize &> /dev/null
make -j {{.CPUs}} &>>/dev/null
make install DESTDIR="$INSTALL" &> /dev/null
#make install DESTDIR=/home/vagrant/test &> /dev/null
popd

echo "FINISHED BUILDING MESOS"

pushd $INSTALL
mkdir -p var/log/mesos var/lib/mesos || echo "Dirs created"

# jars
mkdir -p usr/share/java || echo "dirs for jars"
cp {{.BuildRoot}}/mesos-{{.Version}}/build/src/java/target/mesos-*.jar usr/share/java
popd

echo "BUILDING NET MODULES"

## Net-modules
git clone https://github.com/mesosphere/net-modules.git -b integration/0.26
cd net-modules/isolator

# Configure and build
pushd ${INSTALL}/usr/
ln -s lib lib64
popd

./bootstrap
mkdir build || echo "build dir for netmodules"
cd build
../configure --with-mesos=${INSTALL}/usr --with-protobuf=/usr &>> /dev/null
make >> /dev/null
echo "INSTALLING NETMODULES" &>> /dev/null
echo "DESTDIR IS ${INSTALL}" &>> /dev/null
make install DESTDIR="$INSTALL" &>> /dev/null
echo "SYMLINKING"

pushd ${INSTALL}/usr/
rm -f lib64
popd

pushd $INSTALL
# symlinks
mkdir -p usr/local/lib || echo "dir for symlinks"
# ensure symlinks are relative so they work as expected in the final env
( cd usr/local/lib && cp -s ../../lib/lib*so . )

echo "END"
