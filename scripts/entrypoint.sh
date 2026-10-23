#!/bin/bash

OWN_SCRIPT_NAME=`basename $0`
LOG_SCRIPT_PATH="/node-red/shells/outputlog.sh"

# バージョン表示
cat application.info

# SettingsJSPathの設定
DEFAULT_SETTINGSJS_PATH="/node-red/settings/settings.js"
# SettingsJSPathが未定義の場合はデフォルトのパスを設定
if [ -z "${SettingsJSPath+defined}" ]; then
    # 必要なファイル生成
    /node-red/shells/entrypoint_preprocess.sh
    if [ $? -ne 0 ]; then
        ${LOG_SCRIPT_PATH} "${OWN_SCRIPT_NAME}" "error" "Creating setting file failed."
        ${LOG_SCRIPT_PATH} "${OWN_SCRIPT_NAME}" "error" "Node-RED could not be started."
        exit 1
    fi
    settingsjspath=${DEFAULT_SETTINGSJS_PATH}
elif [ ! -f "${SettingsJSPath}" ]; then
    ${LOG_SCRIPT_PATH} "${OWN_SCRIPT_NAME}" "error" "Settings.js file '${SettingsJSPath}' was not found."
    exit 1
else
    settingsjspath="${SettingsJSPath}" 
fi

# NodeRED実行
trap stop SIGINT SIGTERM

function stop() {
	kill $CHILD_PID
	wait $CHILD_PID
}

exec /usr/local/bin/node /usr/src/node-red/packages/node_modules/node-red/red.js --userDir /data $FLOWS --settings "${settingsjspath}" "${@}" &

CHILD_PID="$!"

wait "${CHILD_PID}"
