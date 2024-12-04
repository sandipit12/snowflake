COPY INTO staging.dbo_LoanRequestExpectedLoss FROM '@STAGE_File_Drop/dbo.LoanRequestExpectedLoss/full/2022/2022_03/2022_03_28/'
file_format = STAGING.CSV_GZIP_SPACE_TRIM
    files=('dbo.LoanRequestExpectedLoss_2022_03_28_01.csv.gz');
;
