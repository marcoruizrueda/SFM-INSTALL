#!/bin/bash


red="$(tput setaf 1)"
green="$(tput setaf 2)"
standColor="$(tput sgr 0)"

mainFolder="robustglobal1dsfm"

mkdir $mainFolder
cd  $mainFolder

echo "${green}CHECK checking MATLAB installation ${standColor}"
check_matlab="$(matlab -h)"
if [ -z "${check_matlab}" ]; then  
        echo "${red}Matlab was not found. Please, install MATLAB version 2013 or later ${standColor}"
	echo "${red}Follow the instruction describedin https://help.ubuntu.com/community/MATLAB${standColor}"
	exit -1;
else
	echo "${green}	MATLAB is already installed ${standColor}"
fi

echo "${green}CHECK checking GNU C++ installation ${standColor}"
check_gcc="$(dpkg -s gcc)"
echo $check_gcc
if [ -z "${check_gcc}" ]; then  
	sudo apt-get install build-essential
fi

echo "${green}CHECK checking PYTHON installation ${standColor}"
check_python="$(dpkg -s python)"
echo $check_python
if [ -z "${check_python}" ]; then  
        sudo apt-get install python-dev
fi

echo "${green}CHECK checking CYTHON installation ${standColor}"
check_cython="$(dpkg -l | grep cython)"
echo $check_cython
if [ -z "${check_cython}" ]; then
        sudo apt-get install cython
fi

echo "${green}CHECK checking SCIPY  installation ${standColor}"
check_scipy="$(dpkg -l | grep scipy)"
echo $check_scipy
if [ -z "${check_scipy}" ]; then
	sudo apt-get install python-numpy python-scipy python-matplotlib ipython ipython-notebook python-pandas python-sympy python-nose
fi

echo "${green}CHECK checking CMAKE installation ${standColor}"
check_cmake="$(dpkg -s cmake)"
echo $check_cmake
if [ -z "${check_cmake}" ]; then
        sudo apt-get install cmake
fi

echo "${green}CHECK checking LIB GOOGLE installation ${standColor}"
check_libgoogle="$(dpkg -s libgoogle-glog-dev)"
echo $check_libgoogle
if [ -z "${check_libgoogle}" ]; then
        sudo apt-get install libgoogle-glog-dev
fi

echo "${green}CHECK checking LIB ATLAS installation ${standColor}"
check_libatlas="$(dpkg -s libatlas-base-dev)"
echo $check_libatlas
if [ -z "${check_libatlas}" ]; then
        sudo apt-get install libatlas-base-dev
fi

echo "${green}CHECK checking LIB EIGEN3 installation ${standColor}"
check_libeigen3="$(dpkg -s libeigen3-dev)"
echo $check_libeigen3
if [ -z "${check_libeigen3}" ]; then
        sudo apt-get install libeigen3-dev
fi

echo "${green}CHECK checking LIB SUITE PARSE installation ${standColor}"
check_libsuitesparse="$(dpkg -s libsuitesparse-dev)"
echo $check_libeigen3
if [ -z "${check_libsuitesparse}" ]; then
        sudo add-apt-repository ppa:bzindovic/suitesparse-bugfix-1319687
	sudo apt-get update
	sudo apt-get install libsuitesparse-dev
fi

echo "${green}CHECK checking LIB CERES SOLVER installation ${standColor}"
#check_libsuitesparse="$(dpkg -s libsuitesparse-dev)"
#echo $check_libeigen3
#if [ -z "${check_libsuitesparse}" ]; then
        git clone https://ceres-solver.googlesource.com/ceres-solver
	cd ceres-solver
	mkdir build
	cd build
	cmake ..
	sed -i '82s/.*/CMAKE_CXX_FLAGS:STRING=-fPIC/' CMakeCache.txt
	make -j3
	make test
	sudo make install
#fi
cd ../..

echo "${green}CLONE Robust Global Translations with 1DSfM${standColor}"

git clone https://github.com/wilsonkl/SfM_Init.git

cd SfM_Init

cd rotsolver
wget --tries=5  http://www.ee.iisc.ernet.in/labs/cvl/research/rotaveraging/SO3GraphAveraging.tar.gz
tar -xvzf SO3GraphAveraging.tar.gz

cd SO3GraphAveraging/
mv * ../
cd ../..

python setup.py build_ext --inplace


