#!/bin/sh
set -ex

# download and install mpfr for Chinese Zodiac Goodie
wget http://www.mpfr.org/mpfr-current/mpfr-3.1.2.tar.gz
tar -xzvf mpfr-3.1.2.tar.gz
cd mpfr-3.1.2 && ./configure --prefix=/usr && make && make check && make install