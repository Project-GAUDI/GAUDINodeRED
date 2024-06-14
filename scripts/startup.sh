#!/bin/bash

OWN_SCRIPT_NAME=`basename $0`
LOG_SCRIPT_PATH="/node-red/shells/outputlog.sh"

# 必要なファイル生成
/node-red/shells/startup_preprocess.sh

if [ $? -ne 0 ]; then
    ${LOG_SCRIPT_PATH} "${OWN_SCRIPT_NAME}" "error" "Creating setting file failed."
    ${LOG_SCRIPT_PATH} "${OWN_SCRIPT_NAME}" "error" "Node-RED could not be started."
    exit 1
fi

# ユーザデータの復元
/node-red/shells/restore_userdata.sh

# Python仮想環境起動
source ./venv/bin/activate

# dockerのエントリーポイント実行
exec ./entrypoint.sh "$@"
