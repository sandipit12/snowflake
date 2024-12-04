#!/bin/bash
set -o errexit
#source ~/.bashrc

###################################################################
#Script Name    : 
#Description    : load dbo.users data
#Args           : None
#Author         : Yasir 
#Date           : 2021-09-18
###################################################################
export YYYY=$(date '+%Y');
export YYYY_MM=$(date '+%Y_%m');
export TODAY=$(date '+%Y_%m_%d');
SCRIPTNAME=$(basename "$0")

export DATE_PATH="${YYYY}/${YYYY_MM}/${TODAY}"

#-----------------------------
# Variable declaration section
#-----------------------------
TABLE_NAME="dbo.users"
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

# ==================== Extract data from source to data lake
#note: Running the following commands in parallel. consider the impact on the prod source!
log_this $? "INFO: Start script ./bin/export_data.sh"
source ./bin/export_data.sh "./sql/users/users_get_data_01.sql" "./out/users/dbo.users_${TODAY}_01.csv" "${TABLE_NAME}" &
source ./bin/export_data.sh "./sql/users/users_get_data_02.sql" "./out/users/dbo.users_${TODAY}_02.csv" "${TABLE_NAME}" &
source ./bin/export_data.sh "./sql/users/users_get_data_03.sql" "./out/users/dbo.users_${TODAY}_03.csv" "${TABLE_NAME}" &
source ./bin/export_data.sh "./sql/users/users_get_data_04.sql" "./out/users/dbo.users_${TODAY}_04.csv" "${TABLE_NAME}" &
wait
log_this $? "INFO: End script ./bin/export_data.sh"

# ==================== load to Snowflake
log_this $? "INFO: Start create staging.users table"
source ./utility/execute_snowflake_query.sh "./sql/users/users_create_table.sql" "${SNOWFLAKE_CONN}"
log_this $? "INFO: End create staging.users table"

# replace the {DAY} placeholder in the sql template file with the current date.
envsubst  < "./sql/users/users_load_data_template.sql" > "./sql/users/users_load_data.sql"
log_this $? "INFO: ./sql/users/users_load_data.sql written with variable replaced..${TODAY}"

log_this $? "INFO: start loading users data from DataLake to Snowflake"
source ./utility/execute_snowflake_query.sh "./sql/users/users_load_data.sql" "${SNOWFLAKE_CONN}"
log_this $? "INFO: end loading users data from DataLake to Snowflake"

log_this $? "INFO: start merging staging data to raw"
source ./utility/execute_snowflake_query.sh "./sql/users/users_merge_data.sql" "${SNOWFLAKE_CONN}"
log_this $? "INFO: end merging staging data to raw"

log_this $? "INFO: Success"
