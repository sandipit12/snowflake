COPY INTO staging.dbo_ApplicationStatus FROM '@STAGE_VENUS_LIVE/dbo.ApplicationStatus/full/${YYYY}/${YYYY_MM}/${TODAY}/'
file_format = STAGING.CSV_GZIP_SPACE_TRIM
    files=('dbo.ApplicationStatus_${TODAY}_01.csv.gz','dbo.ApplicationStatus_${TODAY}_02.csv.gz','dbo.ApplicationStatus_${TODAY}_03.csv.gz','dbo.ApplicationStatus_${TODAY}_04.csv.gz');
;
