#!/bin/bash
set -o errexit

###################################################################
#Script Name    : export_data.sh
#Description    : general script to extract data from sql and copy it to the data lake
#Args           : None
#Author         : Yasir Bamarni
#Date           : 2021-11-03
###################################################################

export YYYY=$(date '+%Y');
export YYYY_MM=$(date '+%Y_%m');
export TODAY=$(date '+%Y_%m_%d');

export DATE_PATH="${YYYY}/${YYYY_MM}/${TODAY}"
SCRIPTNAME=$(basename "$0")


ECHO "In export_data.sh"
ECHO $SOURCE_SERVER  $SOURCE_DATABASE  $SOURCE_USER
#-----------------------------
# Variable declaration section
#-----------------------------
FILE_IN=$1
FILE_OUT=$2
TABLE_NAME=$3
FILE_OUT_ZIP="${FILE_OUT}.gz"
ADSL_STORAGE_FILE_PATH="raw/Venus_Live/${TABLE_NAME}/full"

#--------------------
# Utility function
# Takes 2 parameters, 1=error_code, 2=message to log. if error_code !=0, it will exist script
#--------------------
function log_this ( )
{
 dt=$(date '+%Y-%m-%d %H:%M:%S')
 if [ "$1" -eq 0 ];then
    echo "${dt}: ${SCRIPTNAME}: ${1}: ${2}"
 else
    echo "${dt}: ${SCRIPTNAME}: ${1}: ERROR: ${2}"
    exit 1
 fi
}

log_this $? "INFO: Start executing MSSQL script ${FILE_IN}"
source ./utility/execute_mssql_query.sh $FILE_IN $FILE_OUT
log_this $? "INFO: end executing MSSQL script ${FILE_IN}, exit status $?"

if [[ -s "$FILE_OUT" && -f "$FILE_OUT" ]]; then echo "file has something"; else echo "file "$FILE_OUT" is empty or does not exist.. exiting" ; exit 1; fi

log_this $? "INFO: start gzip..ing file ${FILE_OUT_ZIP}"
gzip -9 -f $FILE_OUT &&
log_this $? "INFO: end gzip ${FILE_OUT_ZIP}"

log_this $? "INFO: start copying file ${FILE_OUT_ZIP} to DataLake"
./utility/azcopy copy $FILE_OUT_ZIP "https://${ADSL_STORAGE_ACCOUNT}.blob.core.windows.net/${ADSL_STORAGE_CONTAINER}/${ADSL_STORAGE_FILE_PATH}/${DATE_PATH}/?${ADSL_STORAGE_SAS}"
log_this $? "INFO: end copying file ${FILE_OUT_ZIP} to DataLake"

log_this $? "INFO: start removing local file ${FILE_OUT_ZIP}"
rm "${FILE_OUT_ZIP}"
log_this $? "INFO: end removing local file ${FILE_OUT_ZIP}"

