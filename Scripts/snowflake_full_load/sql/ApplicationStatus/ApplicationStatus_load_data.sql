COPY INTO staging.dbo_ApplicationStatus FROM '@STAGE_VENUS_LIVE/dbo.ApplicationStatus/full/2022/2022_01/2022_01_14/'
file_format = STAGING.CSV_GZIP_SPACE_TRIM
    files=('dbo.ApplicationStatus_2022_01_14_01.csv.gz','dbo.ApplicationStatus_2022_01_14_02.csv.gz','dbo.ApplicationStatus_2022_01_14_03.csv.gz','dbo.ApplicationStatus_2022_01_14_04.csv.gz');
;
