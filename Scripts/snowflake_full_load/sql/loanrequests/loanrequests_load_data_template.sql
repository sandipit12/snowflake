COPY INTO staging.dbo_loanrequests FROM '@STAGE_VENUS_LIVE/dbo.loanrequests/full/${YYYY}/${YYYY_MM}/${TODAY}/'
file_format = STAGING.CSV_GZIP_SPACE_TRIM
    --PATTERN = "dbo[.]loanrequests_${TODAY}_[0-9]{2}[.]csv[.]gz"
    -- Pattern does not work, I think it is looking at the full path not just the filename.
    files=('dbo.loanrequests_${TODAY}_01.csv.gz', 'dbo.loanrequests_${TODAY}_02.csv.gz', 'dbo.loanrequests_${TODAY}_03.csv.gz','dbo.loanrequests_${TODAY}_04.csv.gz');
;
