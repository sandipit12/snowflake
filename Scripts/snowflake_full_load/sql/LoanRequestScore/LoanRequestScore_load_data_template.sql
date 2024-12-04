COPY INTO staging.dbo_LoanRequestScore FROM '@STAGE_VENUS_LIVE/dbo.LoanRequestScore/full/${YYYY}/${YYYY_MM}/${TODAY}/'
file_format = STAGING.CSV_GZIP_SPACE_TRIM
    files=('dbo.LoanRequestScore_${TODAY}_01.csv.gz','dbo.LoanRequestScore_${TODAY}_02.csv.gz');
;
