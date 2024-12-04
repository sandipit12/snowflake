COPY INTO staging.dbo_Addresses FROM '@STAGE_VENUS_LIVE/dbo.Addresses/full/${YYYY}/${YYYY_MM}/${TODAY}/'
file_format = STAGING.CSV_GZIP_SPACE_TRIM
    files=('dbo.Addresses_${TODAY}_01.csv.gz','dbo.Addresses_${TODAY}_02.csv.gz','dbo.Addresses_${TODAY}_03.csv.gz','dbo.Addresses_${TODAY}_04.csv.gz');
;
