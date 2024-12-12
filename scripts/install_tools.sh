#!/bin/bash -e

apt update
apt-get install -y python3=3.11.2-1+b1
apt-get install -y python-is-python3=3.11.2-1+deb12u1
# 脆弱性対策3 START
# python3-pip だと古い Python 向けの pip がインストールされるため、get-pip.py でインストールする
curl -sSL https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py --break-system-packages
# setuptools/wheelをアップグレードして、脆弱性の回避をする
pip3 install --break-system-packages setuptools --upgrade
pip3 install --break-system-packages wheel --upgrade
# 脆弱性対策3 END
# azure-storage-blobはazure-blob-storageモジュールの2024年12月時点での最新版(1.4.4)で正常動作が確認できた12.15.0を指定してインストールする
# 12.16.0以降のバージョンではazure-blob-storageモジュール側がAPIに対応できておらず、エラーが発生する
pip3 install --break-system-packages azure-storage-blob==12.15.0
pip3 install --break-system-packages pandas==2.2.2
