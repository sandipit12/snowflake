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

"C:\Program Files\Git\bin\bash.exe" "./run_EnumMapReadOnly_main.sh" > "./log/run_EnumMapReadOnly_main.log"
"C:\Program Files\Git\bin\bash.exe" "./run_loanrequests_main.sh" > "./log/run_loanrequests_main.log"
"C:\Program Files\Git\bin\bash.exe" "./run_users_main.sh" > "./log/run_users_main.log"
"C:\Program Files\Git\bin\bash.exe" "./run_BorrowerLoanRequestStates_main.sh" > "./log/run_BorrowerLoanRequestStates_main.log"
"C:\Program Files\Git\bin\bash.exe" "./run_LoanRequestUnderwritingQueue_main.sh" > "./log/run_LoanRequestUnderwritingQueue_main.log"
"C:\Program Files\Git\bin\bash.exe" "./run_BorrowerLoanPayments_main.sh" > "./log/run_BorrowerLoanPayments_main.log"
"C:\Program Files\Git\bin\bash.exe" "./run_LoanRequestScore_main.sh" > "./log/run_LoanRequestScore_main.log"
"C:\Program Files\Git\bin\bash.exe" "./run_ApplicationStatus_main.sh" > "./log/run_ApplicationStatus_main.log"
"C:\Program Files\Git\bin\bash.exe" "./run_LoanArrangementPeriod_main.sh" > "./log/run_LoanArrangementPeriod_main.log"
"C:\Program Files\Git\bin\bash.exe" "./run_Addresses_main.sh" > "./log/run_Addresses_main.log"

if %ERRORLEVEL% neq 0 goto error
 
echo Success
echo ETL completed successfully
REM #sendmail.exe -t < success_mail.txt
exit /b 0
 
:error
echo Error!
REM #sendmail.exe -t < error_mail.txt
exit /b 1