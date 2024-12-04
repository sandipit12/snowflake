COPY INTO staging.dbo_Addresses FROM '@STAGE_VENUS_LIVE/dbo.Addresses/full/2022/2022_01/2022_01_27/'
file_format = STAGING.CSV_GZIP_SPACE_TRIM
    files=('dbo.Addresses_2022_01_27_01.csv.gz','dbo.Addresses_2022_01_27_02.csv.gz','dbo.Addresses_2022_01_27_03.csv.gz','dbo.Addresses_2022_01_27_04.csv.gz');
;
