#!/bin/bash -e

SCRIPT_DIR=$(cd $(dirname $0); pwd) # /node-red/shells
SETTINGS_DIR="${SCRIPT_DIR}/../settings" #/node-red/settings
SETTINGS_TEMPLATE="${SETTINGS_DIR}/settings_template.js" #/node-red/settings/settings_template.js

SETTINGS_FILE="${SETTINGS_DIR}/settings.js"

mkdir -p "${SETTINGS_DIR}"
cp "${SETTINGS_TEMPLATE}" "${SETTINGS_FILE}"

#################################
# LogLevelの設定
echo "Loading LogLevel setting."
loglevel="${LogLevel,,}" # 小文字化
if [ -z "${loglevel}" ]; then
    loglevel="info"
elif [ "error" != "$loglevel" ] && [ "warn" != "$loglevel" ] && [ "info" != "$loglevel" ] && [ "debug" != "$loglevel" ] && [ "trace" != "$loglevel" ]; then
    echo "[Warning] Environment LogLevel does not expected string(LogLevel=$LogLevel)."
    echo "          LogLevel = info was set."
    loglevel="info"
fi
sed -i 's/\$loglevel\$/'"${loglevel}"'/' "${SETTINGS_FILE}"

# EnableMetricsの設定
echo "Loading EnableMetrics setting."
enablemetrics="${EnableMetrics,,}" # 小文字化
if [ -z "${enablemetrics}" ]; then
    enablemetrics="false"
elif [ "true" != "$enablemetrics" -a "false" != "$enablemetrics" ]; then
    echo "[Warning] Environment EnableMetrics does not expected string(EnableMetrics=$EnableMetrics)."
    echo "          EnableMetrics = false was set."
    enablemetrics="false"
fi
sed -i 's/\$enablemetrics\$/'"${enablemetrics}"'/' "${SETTINGS_FILE}"

# EnablePaletteの設定
echo "Loading EnablePalette setting."
enablepalette="${EnablePalette,,}" # 小文字化
if [ -z "${enablepalette}" ]; then
    enablepalette="true"
elif [ "true" != "$enablepalette" -a "false" != "$enablepalette" ]; then
    echo "[Warning] Environment EnablePalette does not expected string(EnablePalette=$EnablePalette)."
    echo "          EnablePalette = true was set."
    enablepalette="true"
fi
sed -i 's/\$enablepalette\$/'"${enablepalette}"'/' "${SETTINGS_FILE}"

# EnableFlowStopの設定
echo "Loading EnableFlowStop setting."
enableflowstop="${EnableFlowStop,,}" # 小文字化
if [ -z "${enableflowstop}" ]; then
    enableflowstop="false"
elif [ "true" != "$enableflowstop" -a "false" != "$enableflowstop" ]; then
    echo "[Warning] Environment EnableFlowStop does not expected string(EnableFlowStop=$EnableFlowStop)."
    echo "          EnableFlowStop = false was set."
    enableflowstop="false"
fi
sed -i 's/\$enableflowstop\$/'"${enableflowstop}"'/g' "${SETTINGS_FILE}"

# EnableUserLoginの設定
echo "Loading EnableUserLogin setting."
enableuserlogin="${EnableUserLogin,,}" # 小文字化
if [ -z "${enableuserlogin}" ]; then
    enableuserlogin="true"
elif [ "true" != "$enableuserlogin" -a "false" != "$enableuserlogin" ]; then
    echo "[Warning] Environment EnableUserLogin does not expected string(EnableUserLogin=$EnableUserLogin)."
    echo "          EnableUserLogin = true was set."
    enableuserlogin="true"
fi
if [ "true" == "$enableuserlogin" ]; then
    adminAuth="adminAuth"
else
    adminAuth="noAdminAuth"
fi
sed -i 's/\$adminauth\$/'"${adminAuth}"'/g' "${SETTINGS_FILE}"

if [ "true" == "$enableuserlogin" ]; then
    # AdminPasswordの設定
    echo "Loading AdminPassword setting."
    adminpassword="${AdminPassword}" 
    if [ -z "${adminpassword}" ]; then
        echo "[Warning] Environment AdminPassword is empty."
        echo "          AdminPassword default password was set."
        adminpassword="adminP@ssw0rd"
    fi
    adminpassword=`echo "$adminpassword" | node-red admin hash-pw | awk '{print $2}'`
    sed -i 's@\$adminpassword\$@'"${adminpassword}"'@g' "${SETTINGS_FILE}"

    # GuestPasswordの設定
    echo "Loading GuestPassword setting."
    guestpassword="${GuestPassword}" 
    if [ -z "${guestpassword}" ]; then
        echo "[Warning] Environment GuestPassword is empty."
        echo "          GuestPassword default password was set."
        guestpassword="guestP@ssw0rd"
    fi
    guestpassword=`echo "$guestpassword" | node-red admin hash-pw | awk '{print $2}'`
    sed -i 's@\$guestpassword\$@'"${guestpassword}"'@g' "${SETTINGS_FILE}"

fi

# EditorRootの設定
echo "Loading EditorRoot setting."
editorroot="${EditorRoot}" 
if [ -z "${editorroot}" ]; then
    editorroot="/"
fi
sed -i 's|\$editorroot\$|'"${editorroot}"'|g' "${SETTINGS_FILE}"

exit 0
