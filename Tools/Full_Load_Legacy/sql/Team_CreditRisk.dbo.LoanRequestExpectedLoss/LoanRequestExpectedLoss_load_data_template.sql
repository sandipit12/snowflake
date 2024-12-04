COPY INTO staging.dbo_LoanRequestExpectedLoss FROM '@STAGE_File_Drop/dbo.LoanRequestExpectedLoss/full/${YYYY}/${YYYY_MM}/${TODAY}/'
file_format = STAGING.CSV_GZIP_SPACE_TRIM
    files=('dbo.LoanRequestExpectedLoss_${TODAY}_01.csv.gz');
;
