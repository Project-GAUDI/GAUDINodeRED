#!/bin/bash -e

SCRIPT_DIR=$(cd $(dirname $0); pwd) # /node-red/shells
SETTINGS_DIR="${SCRIPT_DIR}/../settings" #/node-red/settings
SETTINGS_TEMPLATE="${SETTINGS_DIR}/settings_template.js" #/node-red/settings/settings_template.js

SETTINGS_FILE="${SETTINGS_DIR}/settings.js"

status=0

mkdir -p "${SETTINGS_DIR}"
cp "${SETTINGS_TEMPLATE}" "${SETTINGS_FILE}"

#################################
# LogLevelの設定
echo "Loading LogLevel setting."
loglevel="${LogLevel,,}" # 小文字化
if [ -z "${loglevel}" ]; then
    loglevel="info"
elif [ "error" != "$loglevel" -a "warn" != "$loglevel" -a "info" != "$loglevel" -a "debug" != "$loglevel" -a "trace" != "$loglevel" ]; then
    echo "[Error] Environment LogLevel does not expected string(LogLevel=$LogLevel)."
    status=1
fi
sed -i 's/\$loglevel\$/'"${loglevel}"'/' "${SETTINGS_FILE}"

# EnableMetricsの設定
echo "Loading EnableMetrics setting."
enablemetrics="${EnableMetrics,,}" # 小文字化
if [ -z "${enablemetrics}" ]; then
    enablemetrics="false"
elif [ "true" != "$enablemetrics" -a "false" != "$enablemetrics" ]; then
    echo "[Error] Environment EnableMetrics does not expected string(EnableMetrics=$EnableMetrics)."
    status=1
fi
sed -i 's/\$enablemetrics\$/'"${enablemetrics}"'/' "${SETTINGS_FILE}"

# EnablePaletteの設定
echo "Loading EnablePalette setting."
enablepalette="${EnablePalette,,}" # 小文字化
if [ -z "${enablepalette}" ]; then
    enablepalette="true"
elif [ "true" != "$enablepalette" -a "false" != "$enablepalette" ]; then
    echo "[Error] Environment EnablePalette does not expected string(EnablePalette=$EnablePalette)."
    status=1
fi
sed -i 's/\$enablepalette\$/'"${enablepalette}"'/' "${SETTINGS_FILE}"

# EnableFlowStopの設定
echo "Loading EnableFlowStop setting."
enableflowstop="${EnableFlowStop,,}" # 小文字化
if [ -z "${enableflowstop}" ]; then
    enableflowstop="false"
elif [ "true" != "$enableflowstop" -a "false" != "$enableflowstop" ]; then
    echo "[Error] Environment EnableFlowStop does not expected string(EnableFlowStop=$EnableFlowStop)."
    status=1
fi
sed -i 's/\$enableflowstop\$/'"${enableflowstop}"'/g' "${SETTINGS_FILE}"

# EnableHttpsの設定
echo "Loading EnableHttps setting."
enablehttps="${EnableHttps,,}" # 小文字化
if [ -z "${enablehttps}" ]; then
    enablehttps="false"
elif [ "true" != "$enablehttps" -a "false" != "$enablehttps" ]; then
    echo "[Error] Environment EnableHttps does not expected string(EnableHttps=$EnableHttps)."
    status=1
fi
if [ "true" == "$enablehttps" ]; then
    https="https"
else
    https="noHttps"
fi
sed -i 's/\$https\$/'"${https}"'/g' "${SETTINGS_FILE}"

enable_privatekeyfilepath="false"
enable_certificationfilepath="false"
if [ "true" == "$enablehttps" ]; then
    # PrivateKeyFilePathの設定
    echo "Loading PrivateKeyFilePath setting."
    privatekeyfilepath="${PrivateKeyFilePath}" 
    if [ -z "${privatekeyfilepath}" ]; then
        echo "[Error] Environment PrivateKeyFilePath is empty."
        status=1
    elif [ -f "${privatekeyfilepath}" ]; then
        enable_privatekeyfilepath="true"
        sed -i 's@\$privatekeyfilepath\$@'"${privatekeyfilepath}"'@g' "${SETTINGS_FILE}"
    else
        echo "[Error] Private key file '${PrivateKeyFilePath}' was not found."
        status=1
    fi

    # CertificationFilePathの設定
    echo "Loading CertificationFilePath setting."
    certificationfilepath="${CertificationFilePath}" 
    if [ -z "${certificationfilepath}" ]; then
        echo "[Error] Environment CertificationFilePath is empty."
        status=1
    elif [ -f "${certificationfilepath}" ]; then
        enable_certificationfilepath="true"
        sed -i 's@\$certificationfilepath\$@'"${certificationfilepath}"'@g' "${SETTINGS_FILE}"
    else
        echo "[Error] Certification file '${certificationfilepath}' was not found."
        status=1
    fi

fi
sed -i 's/\$enable_privatekeyfilepath\$/'"${enable_privatekeyfilepath}"'/g' "${SETTINGS_FILE}"
sed -i 's/\$enable_certificationfilepath\$/'"${enable_certificationfilepath}"'/g' "${SETTINGS_FILE}"

# EnableUserLoginの設定
echo "Loading EnableUserLogin setting."
enableuserlogin="${EnableUserLogin,,}" # 小文字化
if [ -z "${enableuserlogin}" ]; then
    enableuserlogin="true"
elif [ "true" != "$enableuserlogin" -a "false" != "$enableuserlogin" ]; then
    echo "[Error] Environment EnableUserLogin does not expected string(EnableUserLogin=$EnableUserLogin)."
    status=1
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
    elif echo "$adminpassword" | LC_ALL=C grep -q '[^ -~]'; then
        echo "[Error] Environment AdminPassword contains non-ASCII characters(AdminPassword=$AdminPassword)."
        status=1
    fi
    adminpassword=`echo "$adminpassword" | node-red-admin hash-pw | awk '{print $2}'`
    sed -i 's@\$adminpassword\$@'"${adminpassword}"'@g' "${SETTINGS_FILE}"

    # GuestPasswordの設定
    echo "Loading GuestPassword setting."
    guestpassword="${GuestPassword}" 
    if [ -z "${guestpassword}" ]; then
        echo "[Warning] Environment GuestPassword is empty."
        echo "          GuestPassword default password was set."
        guestpassword="guestP@ssw0rd"
    elif echo "$guestpassword" | LC_ALL=C grep -q '[^ -~]'; then
        echo "[Error] Environment GuestPassword contains non-ASCII characters(GuestPassword=$GuestPassword)."
        status=1
    fi
    guestpassword=`echo "$guestpassword" | node-red-admin hash-pw | awk '{print $2}'`
    sed -i 's@\$guestpassword\$@'"${guestpassword}"'@g' "${SETTINGS_FILE}"

fi

# EditorRootの設定
echo "Loading EditorRoot setting."
editorroot="${EditorRoot}" 
if [ -z "${editorroot}" ]; then
    editorroot="/"
fi
sed -i 's|\$editorroot\$|'"${editorroot}"'|g' "${SETTINGS_FILE}"

echo "Loading ApiMaxLength setting."
apimaxlength="${ApiMaxLength:-5mb}"
sed -i 's|\$apimaxlength\$|'"${apimaxlength}"'|g' "${SETTINGS_FILE}"

exit $status
