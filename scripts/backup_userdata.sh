#!/bin/bash

# define
OWN_SCRIPT_NAME=`basename $0`
LOG_SCRIPT_PATH="/node-red/shells/outputlog.sh"

USERDATA_DIR="/data"
BACKUP_DIR="/node-red/backupdata"

FLOWS_FILE="flows.json"
PACKAGE_FILE="package.json"

IGNORE_NAME1=".npm"

result=0

# check /data dir
FOLDER_BIND=`df -P | awk '{if($NF == "'${USERDATA_DIR}'") print $NF}' | wc -l`
if [ ${FOLDER_BIND} -eq 0 ]; then
    ${LOG_SCRIPT_PATH} "${OWN_SCRIPT_NAME}" "error" "Userdata were not backed up because maybe ${USERDATA_DIR} folder was not bound."
    exit 1
fi

# delete existing backup
if [ -d "${BACKUP_DIR}" ]; then
    ${LOG_SCRIPT_PATH} "${OWN_SCRIPT_NAME}" "info" "Delete last backup start."
    rm -rf "${BACKUP_DIR}"
fi
mkdir "${BACKUP_DIR}"

# backup userdata
${LOG_SCRIPT_PATH} "${OWN_SCRIPT_NAME}" "info" "Userdata backup start."
while read -r item; do
    cp -rp "${item}" "${BACKUP_DIR}/"
done < <(find "${USERDATA_DIR}" -mindepth 1 -maxdepth 1 -not -name "${IGNORE_NAME1}")
sleep 1

# check userdata
${LOG_SCRIPT_PATH} "${OWN_SCRIPT_NAME}" "info" "Copy compare start."
diff_ret=`diff -rq "${USERDATA_DIR}" "${BACKUP_DIR}" | grep -v ${IGNORE_NAME1} | wc -l`
if [ ${diff_ret} -eq 0 ]; then
    ${LOG_SCRIPT_PATH} "${OWN_SCRIPT_NAME}" "info" "Userdata backup succeeded."
    result=0
else
    ${LOG_SCRIPT_PATH} "${OWN_SCRIPT_NAME}" "error" "Userdata backup failed."
    result=1
fi

exit ${result}
