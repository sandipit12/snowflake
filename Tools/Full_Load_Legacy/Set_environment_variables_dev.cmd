@echo off
REM ----------------------------------
REM Setting some environment variables
REM RUN AS ADMINISTRATOR
REM DEVS ENVIRONMENT
REM THIS FILE SHOULD NOT BE ADDED TO GIT
REM ----------------------------------

REM SQL SERVER
REM -----------
setx SOURCE_SERVER "DEV-RS-DW01,1997" /M
setx SOURCE_DATABASE "Team_CreditRisk" /M

REM DataLake
REM ----------

setx ADSL_STORAGE_ACCOUNT "devweudatalakestor01" /M
setx ADSL_STORAGE_CONTAINER "datalake01" /M
setx ADSL_STORAGE_SAS "" /M

REM Snowflake
REM ----------------------------
REM #This environment variable contains snowflake connection setting and is set in the snowsql config file /%USERPROFILE%/.snowsql/config
setx SNOWFLAKE_CONN "dev_environment" /M


REM ----------------------------------
REM Checking environment variables

ECHO SOURCE_SERVER %SOURCE_SERVER%
ECHO SOURCE_DATABASE %SOURCE_DATABASE%
ECHO ADSL_STORAGE_ACCOUNT %ADSL_STORAGE_ACCOUNT%