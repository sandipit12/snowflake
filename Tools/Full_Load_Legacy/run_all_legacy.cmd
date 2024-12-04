@echo off
REM ----------------------------------
REM Before running this, environment settings much be set
REM TEST ENVIRONMENT
REM THIS FILE SHOULD NOT BE ADDED TO GIT
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

"C:\Program Files\Git\bin\bash.exe" "./run_Team_CreditRisk_LoanRequestExpectedLoss.sh" > "./log/run_LoanRequestExpectedLoss_main.log"


if %ERRORLEVEL% neq 0 goto error
 
echo Success
echo ETL completed successfully
REM #sendmail.exe -t < success_mail.txt
exit /b 0
 
:error
echo Error!
REM #sendmail.exe -t < error_mail.txt
exit /b 1