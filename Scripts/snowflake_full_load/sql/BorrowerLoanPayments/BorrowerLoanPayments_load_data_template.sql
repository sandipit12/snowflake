COPY INTO staging.dbo_BorrowerLoanPayments FROM '@STAGE_VENUS_LIVE/dbo.BorrowerLoanPayments/full/${YYYY}/${YYYY_MM}/${TODAY}/'
file_format = STAGING.CSV_GZIP_SPACE_TRIM
    files=('dbo.BorrowerLoanPayments_${TODAY}_01.csv.gz', 'dbo.BorrowerLoanPayments_${TODAY}_02.csv.gz', 'dbo.BorrowerLoanPayments_${TODAY}_03.csv.gz','dbo.BorrowerLoanPayments_${TODAY}_04.csv.gz','dbo.BorrowerLoanPayments_${TODAY}_05.csv.gz','dbo.BorrowerLoanPayments_${TODAY}_06.csv.gz','dbo.BorrowerLoanPayments_${TODAY}_07.csv.gz','dbo.BorrowerLoanPayments_${TODAY}_08.csv.gz','dbo.BorrowerLoanPayments_${TODAY}_09.csv.gz');
;
