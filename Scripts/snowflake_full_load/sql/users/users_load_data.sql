COPY INTO staging.dbo_users FROM '@STAGE_VENUS_LIVE/dbo.users/full/2021/2021_11/2021_11_18/'
file_format = STAGING.CSV_GZIP_SPACE_TRIM
--PATTERN = "dbo[.]users_2021_11_18_[0-9]{2}[.]csv[.]gz"
files=('dbo.users_2021_11_18_01.csv.gz', 'dbo.users_2021_11_18_02.csv.gz', 'dbo.users_2021_11_18_03.csv.gz','dbo.users_2021_11_18_04.csv.gz');
;
