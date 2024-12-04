COPY INTO staging.DBO_LoanArrangementPeriod FROM '@STAGE_VENUS_LIVE/dbo.LoanArrangementPeriod/full/2022/2022_01/2022_01_27/'
file_format = STAGING.CSV_GZIP_SPACE_TRIM
    files=('dbo.LoanArrangementPeriod_2022_01_27_01.csv.gz');
;


