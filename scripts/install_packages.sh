#!/bin/bash -e

# ノードパッケージ
npm install node-red-contrib-omron-fins@0.5.0
npm install node-red-contrib-mcprotocol@1.2.1
npm install node-red-contrib-python3-function@0.0.4
npm install node-red-blobstorage@$node-red-blobstorage$
npm install node-red-datacleansing@$node-red-datacleansing$
npm install node-red-iotedge@$node-red-iotedge$
npm install node-red-kv@$node-red-kv$
npm install node-red-python@$node-red-python$

npm install --unsafe-perm --no-update-notifier --no-fund --omit=dev

# ノードパッケージ・SDKのインストールのためにazure artifacts feedを取得先に指定していたのを
# デフォルトリポジトリに変更、feed情報を削除
rm /usr/src/node-red/.npmrc
npm config set registry https://registry.npmjs.org/
