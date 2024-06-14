#!/bin/bash

# define
OWN_SCRIPT_NAME=`basename $0`
LOG_SCRIPT_PATH="/node-red/shells/outputlog.sh"

USERDATA_DIR="/data"
BACKUP_DIR="/node-red/backupdata"

IGNORE_NAME1=".npm"

# check backup dir
if [ ! -d "${BACKUP_DIR}" ]; then
    ${LOG_SCRIPT_PATH} "${OWN_SCRIPT_NAME}" "info" "Skip processing because backupdata folder does not exist."
    exit 0
fi

BACKUP_FILE_NUM=`ls -1A "${BACKUP_DIR}" | wc -l`
if [ ${BACKUP_FILE_NUM} -eq 0 ]; then
    ${LOG_SCRIPT_PATH} "${OWN_SCRIPT_NAME}" "info" "Skip processing because backupdata file does not exist."
    exit 0
fi

# check /data dir
if [ ! -d "${USERDATA_DIR}" ]; then
    ${LOG_SCRIPT_PATH} "${OWN_SCRIPT_NAME}" "error" "${USERDATA_DIR} does not exist."
    exit 1
fi

FOLDER_BIND=`df -P | awk '{if($NF == "'${USERDATA_DIR}'") print $NF}' | wc -l`
if [ ${FOLDER_BIND} -eq 0 ]; then
    ${LOG_SCRIPT_PATH} "${OWN_SCRIPT_NAME}" "info" "Userdata were not restored because maybe ${USERDATA_DIR} folder was not bound."
    exit 0
fi

USERDATA_FILE_NUM=`ls -1A "${USERDATA_DIR}" | wc -l`
if [ ${USERDATA_FILE_NUM} -ne 0 ] ; then
    ${LOG_SCRIPT_PATH} "${OWN_SCRIPT_NAME}" "info" "Skipping processing because the file exists in ${USERDATA_DIR}."
    exit 0
fi

# restore userdata
${LOG_SCRIPT_PATH} "${OWN_SCRIPT_NAME}" "info" "Userdata restore start."
while read -r item; do
    cp -rp "${item}" "${USERDATA_DIR}/"
    status=$?
    if [ ${status} -ne 0 ]; then
        ${LOG_SCRIPT_PATH} "${OWN_SCRIPT_NAME}" "error" "Userdata restore failed."
        exit 2
    fi
done < <(find "${BACKUP_DIR}" -mindepth 1 -maxdepth 1 -not -name "${IGNORE_NAME1}")
${LOG_SCRIPT_PATH} "${OWN_SCRIPT_NAME}" "info" "Userdata restore succeeded."

exit 0
