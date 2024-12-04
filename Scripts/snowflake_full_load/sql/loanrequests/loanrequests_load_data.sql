COPY INTO staging.dbo_loanrequests FROM '@STAGE_VENUS_LIVE/dbo.loanrequests/full/2021/2021_11/2021_11_18/'
file_format = STAGING.CSV_GZIP_SPACE_TRIM
    --PATTERN = "dbo[.]loanrequests_2021_11_18_[0-9]{2}[.]csv[.]gz"
    -- Pattern does not work, I think it is looking at the full path not just the filename.
    files=('dbo.loanrequests_2021_11_18_01.csv.gz', 'dbo.loanrequests_2021_11_18_02.csv.gz', 'dbo.loanrequests_2021_11_18_03.csv.gz','dbo.loanrequests_2021_11_18_04.csv.gz');
;
