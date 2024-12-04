@ECHO OFF
REM ==============================
REM This script requires an environment variable called VirtualEnv_Path that points to your python virtual environment
REM The script takes a parameters:
REM 1. Environment (DEV, DEVINT, TEST, PROD)
REM ==============================
IF %1.==. GOTO No1
SET ENVIRONMENT=%1
IF %2.==. GOTO No2
SET DATABASE_NAME=%2
ECHO "Deploying %DATABASE_NAME% scripts to %ENVIRONMENT% Environment."
SET SCRIPT_PATH=%~dp0
ECHO "Script Directory:" "%SCRIPT_PATH%"
for %%i in ("%~dp0..") do set "SnowDWH_PATH=%%~fi"
ECHO "SnowDWH_PATH path is:" "%SnowDWH_PATH%"
ECHO "My virtualEnv_Path:"  "%VirtualEnv_Path%"
CALL "%VirtualEnv_Path%\env_3.7\Scripts\activate"; & python %SnowDWH_PATH%\SchemaChange\schemachange_cli.py ^
deploy --config-folder %SnowDWH_PATH%\ReleaseScripts\ReleaseConfig\%ENVIRONMENT%\ ^
-d %DATABASE_NAME% -f %SnowDWH_PATH%\ReleaseScripts\Databases\%DATABASE_NAME%\scripts\
CALL "%VirtualEnv_Path%\env_3.7\Scripts\deactivate"
GOTO End1
:No1
 ECHO "ERROR: ENV parameter not specified"
GOTO End1
:No2
 ECHO "ERROR: DB parameter not specified"
GOTO End1
:End1