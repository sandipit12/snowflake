COPY INTO staging.dbo_LoanRequestScore FROM '@STAGE_VENUS_LIVE/dbo.LoanRequestScore/full/2022/2022_01/2022_01_11/'
file_format = STAGING.CSV_GZIP_SPACE_TRIM
    files=('dbo.LoanRequestScore_2022_01_11_01.csv.gz','dbo.LoanRequestScore_2022_01_11_02.csv.gz');
;