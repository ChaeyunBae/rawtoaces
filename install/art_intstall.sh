#!/bin/sh

#USER
while :
do
	read -p "Enter a user name > " name
	if [ -d /home/$name ];then
		break
	fi
done

#cmake
echo "\n----Install cmake----\n""
yum -y install cmake


#ilmbase
echo "\n----Install ilmbase----\n"
if [ ! -d "/home/$name/app" ]; then
	mkdir /home/$name/app
fi
tar xvf /RD101_Storage/OPT/Installer/Plug-in/Nuke/rawtoaces/ilmbase-2.2.0.tar.gz -C "/home/$name/app"
cd /home/$name/app/ilmbase-2.2.0
./configure
make
make install

#ACES container
echo "\n----Install ACES container----\n"
cd /home/$name/app
cp /RD101_Storage/OPT/Installer/Plug-in/Nuke/rawtoaces/source/aces_containe ./
mkdir build
cd build
cmake ..
make
make install
sed -i "206s/.*/	assert ( outputBufferSize < 350e6 );/g" /home/$name/app/aces_container/aces_Writer.cpp

#LibRaw
echo "\n----Install LibRaw----\n"
tar xvf /RD101_Storage/OPT/Installer/Plug-in/Nuke/rawtoaces/LibRaw-0.19.2.tar.gz -C "/home/$name/app"
cd /home/$name/app/LibRaw-0.19.2
./configure
make
make install
./configure --enable-openmp
./configure --disable-openmp
./configure --enable-lcms
./configure --disable-lcms
./configure --enable-examples
./configure --disable-examples

#Boost
echo "\n----Install Boost----\n"
yum -y install boost-devel

#CeresSolver
echo "\n----Install CeresSolver----\n"
yum -y install glog-devel
yum -y install gflags-devel
yum -y install atlas-devel
yum -y install eigen3-devel

tar xvf /RD101_Storage/OPT/Installer/Plug-in/Nuke/rawtoaces/ceres-solver-refs_heads_1.14.x.tar.gz -C "/home/$name/app"
mkdir ceres-bin
cd ceres-bin
cmake ../ceres-solver-1.14
make -j2
make test
make install

#Install
echo "\n----Install----\n"
cd /usr/local
cp /RD101_Storage/OPT/Installer/Plug-in/Nuke/rawtoaces/source/rawtoaces ./
cd rawtoaces
mkdir build 
cd build
cmake ..
make
make install
