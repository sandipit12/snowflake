@echo off
REM ----------------------------------
REM Before running this, environment settings much be set
REM using the relevant Set_environment_variables_{env}.cmd running in a seperate cmd window as Administrator
REM ----------------------------------

REM Check if environment variables not set
REM -----------
ECHO SOURCE_SERVER %SOURCE_SERVER%

if defined SOURCE_SERVER ( 
    echo "environment variable ok"
) else (
    echo "environment not set. Exit"
    exit 1
)

"C:\Program Files\Git\bin\bash.exe" "./run_loanrequests_main.sh" > "./log/run_loanrequests_main.log"

if %ERRORLEVEL% neq 0 goto error
 
echo Success
echo ETL completed successfully
REM #sendmail.exe -t < success_mail.txt
exit /b 0
 
:error
echo Error!
REM #sendmail.exe -t < error_mail.txt
exit /b 1