COPY INTO staging.dbo_EnumMapReadOnly FROM '@STAGE_VENUS_LIVE/dbo.EnumMapReadOnly/full/${YYYY}/${YYYY_MM}/${TODAY}/'
file_format = STAGING.CSV_GZIP_SPACE_TRIM
    --PATTERN = "dbo[.]EnumMapReadOnly_${TODAY}_[0-9]{2}[.]csv[.]gz"
    -- Pattern does not work, I think it is looking at the full path not just the filename.
    files=('dbo.EnumMapReadOnly_${TODAY}_01.csv.gz');
;
