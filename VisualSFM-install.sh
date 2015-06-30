#!/bin/bash

### Script to automatic install VisualSFM.(http://ccwu.me/vsfm/install.html)

### This script is based in follow sites:
### 	http://mdda.net/oss-blog/2014-06/building-VisualSFM-on-FC20/
### 	http://www.10flow.com/2012/08/15/building-visualsfm-on-ubuntu-12-04-precise-pangolin-desktop-64-bit/
### 	http://adinutzyc21.blogspot.com.br/2013/02/installing-bundler-on-linux-tutorial.html

### This script it was tested on:
### UBUNTU 14.*
### UBUNTU 15.04


red="$(tput setaf 1)"
green="$(tput setaf 2)"
standColor="$(tput sgr 0)"

echo "${green}CHECK CUDA IS INSTALLED${standColor}"

nvcc_version="$(nvcc --version | grep 'Cuda compilation tools')"
nvcc_check="$(ls /usr/local/cuda/bin | grep 'nvcc')"
if [ -z "${nvcc_check}" ]; then
	if [ -z "${nvcc_version}" ]; then
		echo "${red}CUDA NOT INSTALED${standColor}"
		exit 0
	fi
fi
echo "$nvcc_version"
mkdir visualsfm
cd visualsfm

echo "${green}CHECK GTK 2.0 DEV${standColor} "

check_libgtk="$(dpkg-query -l libgtk2.0-dev | grep libgtk2.0-dev)"
echo "$check_libgtk"

if [ -z "${check_libgtk}" ]; then
	sudo apt-get install libgtk2.0-dev 
fi

echo "${green}INSTALL VISUAL SFM${standColor} "
## Download

wget --tries=5 http://ccwu.me/vsfm/download/VisualSFM_linux_64bit.zip

## Unzip to visualsfm folder and delete download
unzip VisualSFM_linux_64bit.zip
rm VisualSFM_linux_64bit.zip

## Rum make
echo "${green}MAKE VISUAL SFM${standColor} "
cd vsfm
cp makefile makefile_bkp
make

echo "${green}CHECK SIFTGPU${standColor} "

## CHECK GLEW
check_glew="$(dpkg -l | grep glew)"
echo "${check_glew}"
if [ -z "${check_glew}" ]; then
	sudo apt-get install sudo libglew-dev
fi

## CHECK DEVIL
check_devil="$(dpkg -l | grep libdevil-dev)"
echo "${check_devil}"
if [ -z "${check_devil}" ]; then
	sudo apt-get install sudo libdevil-dev
fi

## DOWNLOAD SFITGPU
wget --tries=5 http://wwwx.cs.unc.edu/~ccwu/cgi-bin/siftgpu.cgi
mv siftgpu.cgi siftgpu.zip
unzip siftgpu.zip
rm siftgpu.zip

## MAKE SIFT GPU
cd SiftGPU
make
#echo "TEST 1 -> $check_sift_make"
cd ..

## make a symbolic link
cd bin
ln -s ../SiftGPU/bin/libsiftgpu.so libsiftgpu.so
cd ..

## Install Multicore Bundle Adjustment
echo "${green} INSTALL  Multicore Bundle Adjustment ${standColor}"

wget --tries=5 http://grail.cs.washington.edu/projects/mcba/pba_v1.0.5.zip
unzip pba_v1.0.5.zip 
rm pba_v1.0.5.zip

cd pba
make
cd ..

## make symbolic link
cd bin
ln -s ../pba/bin/libpba.so libpba.so
cd ..

## Install PMVS
echo "${green} INSTALL PMVS${standColor}"

## CHECK GSL
check_gsl="$(dpkg -l | grep libgsl)"
echo "${check_gsl}"
if [ -z "${check_gsl}" ]; then
        sudo apt-get install sudo libgsl*
fi

## CHECK BLAS
check_blas="$(dpkg -l | grep libblas)"
echo "${check_blas}"
if [ -z "${check_blas}" ]; then
        sudo apt-get install sudo libblas*
fi

## CHECK LAPACK
check_lapack="$(dpkg -l | grep liblapack)"
echo "${check_lapack}"
if [ -z "${check_lapack}" ]; then
        sudo apt-get install sudo liblapack*
fi
cd ..

if [ ! -d "pmvs-2" ]; then

	wget --tries=5 http://www.di.ens.fr/pmvs/pmvs-2.tar.gz
	tar -xvzf pmvs-2.tar.gz
fi

cd pmvs-2/program/main

var_libXext="$(locate libXext.so. | grep 64 | sed -n '1 p')"
echo "libXext.so.6 -> $var_libXext"
#ln -s "$var_libXext" "libXext.so.6"

var_libX11="$(locate libX11.so. | grep 64 | sed -n '1 p')"
echo "libX11.so.6 -> $var_libX11"
#ln -s "$var_libX11" "libX11.so.6"

var_libjpeg="$(locate libjpeg.so.62 | grep 64 | sed -n '1 p')"
if ! [ "$var_libjpeg" ]; then
	sudo apt-get install libjpeg62 libjpeg62-dev
fi

var_libpthread="$(locate libpthread.so. | grep 64 | sed -n '1 p')"
echo "libpthread.so.0 -> $var_libpthread"
#ln -s "$var_libpthread" "libpthread.so.0"

var_libm="$(locate libm.so. | grep 64 | sed -n '1 p')"
echo "libm.so.6 -> $var_libm"
#ln -s "$var_libm" "libm.so.6"

var_libstdc="$(locate libstdc++.so. | grep 64 | sed -n '1 p')"
echo "libstdc++.so.6 -> $var_libstdc"
#ln -s "$var_libstdc" "libstdc++.so.6"

var_libgcc="$(locate libgcc_s.so. | grep 64 | sed -n '1 p')"
echo "libgcc_s.so.1 -> $var_libgcc"
#ln -s "$var_libgcc" "libgcc_s.so.1"

var_libc="$(locate libc.so. | grep 64 | sed -n '1 p')"
echo "libc.so.6 -> $var_libc"
#ln -s "$var_libc" "libc.so.6"

var_libXau="$(locate libXau.so. | grep 64 | sed -n '1 p')"
echo "libXau.so.6 -> $var_libXau"
#ln -s "$var_libXau" "libXau.so.6"

var_libXdmcp="$(locate libXdmcp.so. | grep 64 | sed -n '1 p')"
echo "libXdmcp.so.6 -> $var_libXdmcp"
#ln -s "$var_libXdmcp" "libXdmcp.so.6"

var_libdl="$(locate libdl.so. | grep 64 | sed -n '1 p')"
echo "libdl.so.2 -> $var_libdl"
#ln -s "$var_libdl" "libdl.so.2"

var_ld_linux_x86_64="$(locate ld-linux-x86-64.so. | grep 64 | sed -n '1 p')"
echo "ld-linux-x86-64.so.2 -> $var_ld_linux_x86_64"
#ln -s "$var_ld_linux_x86_64" "ld-linux-x86-64.so.2"

var_libgfortran="$(locate libgfortran.so. | grep 64 | sed -n '1 p')"
echo "libgfortran.so.1 -> $var_libgfortran"
ln -s "$var_libgfortran" "libgfortran.so.1"

sed -i '12s/.*/YOURINCLUDEPATH = -I\/usr\/include/' Makefile
##sed -i '15s/.*/YOURLDLIBPATH =' Makefile

mv liblapack.so.3 liblapack.so.3_old

make depend
make
cd ..

## make symbolic link
cd ../../vsfm/bin
ln -s ../../pmvs-2/program/main/pmvs2 pmvs2
cd ..

echo "${green} INSTALL CMVS${standColor}"
cd ..

echo "PATH ACTUAL $(pwd)"

if [ ! -d "cmvs" ]; then
	wget --tries=5 http://www.di.ens.fr/cmvs/cmvs-fix2.tar.gz
	tar -xvzf cmvs-fix2.tar.gz
fi

cd cmvs

## INSTALL GRACLUS http://www.cs.utexas.edu/users/dml/Software/graclus.html
if [ ! -d "graclus1.2" ]; then
	wget --tries=5 http://www.cs.utexas.edu/users/dml/Software/graclus1.2.tar.gz
	tar -xvzf graclus1.2.tar.gz
fi

cd graclus1.2
sed -i '11s/.*/COPTIONS = -DNUMBITS=64/' Makefile.in
make

cd ../program/base/numeric

sed -i '6s/.*/#include <f2c.h>/' mylapack.cc
sed -i '7s/.*/#include <lapacke.h>/' mylapack.cc

sed -i '31s/.*/                 int width, int height);/' mylapack.h
sed -i '35s/.*/                 int width, int height);/' mylapack.h

cd ../cmvs

sed -i -e '1i#include <vector>\' bundle.cc
sed -i -e '1i#include <numeric>\' bundle.cc

cd ../../main

sed -i -e '1i#include <stdlib.h>\' genOption.cc

mv liblapack.so.3 liblapack.so.3_old

var_libgfortran="$(locate libgfortran.so. | grep 64 | sed -n '1 p')"
echo "libgfortran.so.1 -> $var_libgfortran"
ln -s "$var_libgfortran" "libgfortran.so.1"

sed -i '10s/.*//' Makefile
sed -i '13s/.*//' Makefile
sed -i '16s/.*//' Makefile

sed -i '11s/.*/YOUR_INCLUDE_PATH = -I\/usr\/include\//' Makefile
sed -i '14s/.*/YOUR_INCLUDE_METIS_PATH = -I..\/..\/graclus1.2\/metisLib\//' Makefile
sed -i '17s/.*/YOUR_LDLIB_PATH = -L..\/..\/graclus1.2\//' Makefile

check_boost="$(dpkg -l | grep libboost-dev)"
if ! [ "$check_boost" ] ; then
	sudo apt-get install libboost-dev
fi

check_lapack="$(dpkg -l | grep liblapacke-dev)"
if ! [ "$check_lapack" ] ; then
	sudo apt-get install liblapack-dev liblapack3 liblapacke-dev
fi

check_f2c="$(dpkg -l | grep f2c)"
if ! [ "$check_f2c" ] ; then
        sudo apt-get install f2c
fi

#echo "PATH ACTUAL $(pwd)"
ln -s ../../../pmvs-2/program/main/mylapack.o mylapack.o
make

cd ../../../vsfm/bin

ln -s ../../cmvs/program/main/cmvs cmvs
ln -s ../../cmvs/program/main/genOption genOption

## end of process



