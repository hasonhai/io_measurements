#! /bin/bash
# For installing fio on Ubuntu
sudo apt-get update
wget https://github.com/axboe/fio/archive/fio-2.2.4.tar.gz
tar -xzvf fio-2.2.4.tar.gz
sudo apt-get install zlib1g-dev -y
sudo apt-get install libaio1 libaio-dev -y
cd fio-fio-2.2.4
./configure
make
sudo make install

