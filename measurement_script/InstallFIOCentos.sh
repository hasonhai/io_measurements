#! /bin/bash
# For installing fio
yum install -y libaio* gcc wget make
wget http://brick.kernel.dk/snaps/fio-2.1.13.tar.gz
tar xvzf fio-2.1.13.tar.gz
cd fio-2.1.13
./configure
make
make install

