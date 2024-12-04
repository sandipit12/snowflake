#!/bin/bash
set -o errexit
#source ~/.bashrc

###################################################################
#Script Name    : 
#Description    : load dbo.LoanRequestExpectedLoss data
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
ADLS_FOLDER="File_Drop"
TABLE_NAME="dbo.LoanRequestExpectedLoss"
echo "In run_Team_CreditRisk_LoanRequestExpectedLoss.main.sh"
echo ${SOURCE_SERVER}  ${SOURCE_DATABASE}  ${SOURCE_USER} ${SCRIPTNAME}

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
log_this $? "INFO: Start script ./bin/export_data_generic.sh"
source ./bin/export_data_generic.sh "./sql/Team_CreditRisk.dbo.LoanRequestExpectedLoss/LoanRequestExpectedLoss_get_data_01.sql" "./out/LoanRequestExpectedLoss/dbo.LoanRequestExpectedLoss_${TODAY}_01.csv" "${TABLE_NAME}" "${ADLS_FOLDER}" &

wait
log_this $? "INFO: End script ./bin/export_data_generic.sh"

# ==================== load to Snowflake
log_this $? "INFO: Start truncating staging.LoanRequestExpectedLoss table"
source ./utility/execute_snowflake_query.sh "./sql/Team_CreditRisk.dbo.LoanRequestExpectedLoss/LoanRequestExpectedLoss_truncate_table.sql" "${SNOWFLAKE_CONN}"
log_this $? "INFO: End truncating staging.LoanRequestExpectedLoss table"

# replace the {DAY} placeholder in the sql template file with the current date.
envsubst  < "./sql/Team_CreditRisk.dbo.LoanRequestExpectedLoss/LoanRequestExpectedLoss_load_data_template.sql" > "./sql/Team_CreditRisk.dbo.LoanRequestExpectedLoss/LoanRequestExpectedLoss_load_data.sql"
log_this $? "INFO: ./sql/Team_CreditRisk.dbo.LoanRequestExpectedLoss/LoanRequestExpectedLoss_load_data.sql written with variable replaced..${TODAY}"

log_this $? "INFO: start loading LoanRequestExpectedLoss data from DataLake to Snowflake"
source ./utility/execute_snowflake_query.sh "./sql/Team_CreditRisk.dbo.LoanRequestExpectedLoss/LoanRequestExpectedLoss_load_data.sql" "${SNOWFLAKE_CONN}"
log_this $? "INFO: end loading LoanRequestExpectedLoss data from DataLake to Snowflake"

log_this $? "INFO: start merging staging data to raw"
source ./utility/execute_snowflake_query.sh "./sql/Team_CreditRisk.dbo.LoanRequestExpectedLoss/LoanRequestExpectedLoss_merge_data.sql" "${SNOWFLAKE_CONN}"
log_this $? "INFO: end merging staging data to raw"

log_this $? "INFO: Success"
