#!/bin/bash
set -o errexit
#source ~/.bashrc

###################################################################
#Script Name    : 
#Description    : load dbo.Addresses data
#Args           : None
#Author         : Yasir 
#Date           : 2021-11-20
###################################################################
export YYYY=$(date '+%Y');
export YYYY_MM=$(date '+%Y_%m');
export TODAY=$(date '+%Y_%m_%d');
SCRIPTNAME=$(basename "$0")

#-----------------------------
# Variable declaration section
#-----------------------------
TABLE_NAME="dbo.Addresses"
echo "In run_Addresses.main.sh"
echo ${SOURCE_SERVER}  ${SOURCE_DATABASE}  ${SOURCE_USER}

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
source ./bin/export_data.sh "./sql/Addresses/Addresses_get_data_01.sql" "./out/Addresses/dbo.Addresses_${TODAY}_01.csv" "${TABLE_NAME}" &
source ./bin/export_data.sh "./sql/Addresses/Addresses_get_data_02.sql" "./out/Addresses/dbo.Addresses_${TODAY}_02.csv" "${TABLE_NAME}" &
source ./bin/export_data.sh "./sql/Addresses/Addresses_get_data_03.sql" "./out/Addresses/dbo.Addresses_${TODAY}_03.csv" "${TABLE_NAME}" &
source ./bin/export_data.sh "./sql/Addresses/Addresses_get_data_04.sql" "./out/Addresses/dbo.Addresses_${TODAY}_04.csv" "${TABLE_NAME}" &

wait
log_this $? "INFO: End script ./bin/export_data.sh"

# ==================== load to Snowflake
log_this $? "INFO: Start create staging.Addresses table"
source ./utility/execute_snowflake_query.sh "./sql/Addresses/Addresses_create_table.sql" "${SNOWFLAKE_CONN}"
log_this $? "INFO: End create staging.Addresses table"

# replace the {DAY} placeholder in the sql template file with the current date.
envsubst  < "./sql/Addresses/Addresses_load_data_template.sql" > "./sql/Addresses/Addresses_load_data.sql"
log_this $? "INFO: ./sql/Addresses/Addresses_load_data.sql written with variable replaced..${TODAY}"

log_this $? "INFO: start loading Addresses data from DataLake to Snowflake"
source ./utility/execute_snowflake_query.sh "./sql/Addresses/Addresses_load_data.sql" "${SNOWFLAKE_CONN}"
log_this $? "INFO: end loading Addresses data from DataLake to Snowflake"

log_this $? "INFO: start merging staging data to raw"
source ./utility/execute_snowflake_query.sh "./sql/Addresses/Addresses_merge_data.sql" "${SNOWFLAKE_CONN}"
log_this $? "INFO: end merging staging data to raw"

log_this $? "INFO: Success"