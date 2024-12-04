COPY INTO staging.dbo_BorrowerLoanPayments FROM '@STAGE_VENUS_LIVE/dbo.BorrowerLoanPayments/full/2021/2021_12/2021_12_14/'
file_format = STAGING.CSV_GZIP_SPACE_TRIM
    files=('dbo.BorrowerLoanPayments_2021_12_14_01.csv.gz', 'dbo.BorrowerLoanPayments_2021_12_14_02.csv.gz', 'dbo.BorrowerLoanPayments_2021_12_14_03.csv.gz','dbo.BorrowerLoanPayments_2021_12_14_04.csv.gz','dbo.BorrowerLoanPayments_2021_12_14_05.csv.gz','dbo.BorrowerLoanPayments_2021_12_14_06.csv.gz','dbo.BorrowerLoanPayments_2021_12_14_07.csv.gz','dbo.BorrowerLoanPayments_2021_12_14_08.csv.gz','dbo.BorrowerLoanPayments_2021_12_14_09.csv.gz');
;
