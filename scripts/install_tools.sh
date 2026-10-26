#!/bin/bash -e
 
apt update
apt-get install -y python3=3.11.2-1+b1
apt-get install -y python-is-python3=3.11.2-1+deb12u1
 
##### 脆弱性対策 START #####
# 関連コードをまとめておくため、脆弱性対策に関するコードは本区画(START～END)内に記載すること
 
# python3-pip だと古い Python 向けの pip がインストールされるため、get-pip.py でインストールする
# 導入されるパッケージのバージョン（最新）の確認は、こちらから（https://pypi.org/project/pip/#history）
curl -sSL https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py pip==26.2.0 --break-system-packages
# ライブラリをアップグレードして、脆弱性を回避する
# バージョンを固定にすることで再現性を確保したいため、--upgradeオプションは使用しないこと
pip3 install --break-system-packages setuptools==83.0.0
pip3 install --break-system-packages urllib3==2.8.0
##### 脆弱性対策 END #####
 
# azure-storage-blobはazure-blob-storageモジュールの2024年12月時点での最新版(1.4.4)で正常動作が確認できた12.15.0を指定してインストールする
# 12.16.0以降のバージョンではazure-blob-storageモジュール側がAPIに対応できておらず、エラーが発生する
pip3 install --break-system-packages azure-storage-blob==12.15.0
pip3 install --break-system-packages pandas==2.3.2