COPY INTO staging.dbo_EnumMapReadOnly FROM '@STAGE_VENUS_LIVE/dbo.EnumMapReadOnly/full/2021/2021_12/2021_12_15/'
file_format = STAGING.CSV_GZIP_SPACE_TRIM
    --PATTERN = "dbo[.]EnumMapReadOnly_2021_12_15_[0-9]{2}[.]csv[.]gz"
    -- Pattern does not work, I think it is looking at the full path not just the filename.
    files=('dbo.EnumMapReadOnly_2021_12_15_01.csv.gz');
;
