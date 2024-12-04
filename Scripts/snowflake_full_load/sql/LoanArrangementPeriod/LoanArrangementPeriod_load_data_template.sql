COPY INTO staging.DBO_LoanArrangementPeriod FROM '@STAGE_VENUS_LIVE/dbo.LoanArrangementPeriod/full/${YYYY}/${YYYY_MM}/${TODAY}/'
file_format = STAGING.CSV_GZIP_SPACE_TRIM
    files=('dbo.LoanArrangementPeriod_${TODAY}_01.csv.gz');
;


