COPY INTO staging.dbo_LoanRequestUnderwritingQueue FROM '@STAGE_VENUS_LIVE/dbo.LoanRequestUnderwritingQueue/full/${YYYY}/${YYYY_MM}/${TODAY}/'
file_format = STAGING.CSV_GZIP_SPACE_TRIM
    --PATTERN = "dbo[.]LoanRequestUnderwritingQueue_${TODAY}_[0-9]{2}[.]csv[.]gz"
    -- Pattern does not work, I think it is looking at the full path not just the filename.
    files=('dbo.LoanRequestUnderwritingQueue_${TODAY}_01.csv.gz', 'dbo.LoanRequestUnderwritingQueue_${TODAY}_02.csv.gz','dbo.LoanRequestUnderwritingQueue_${TODAY}_03.csv.gz','dbo.LoanRequestUnderwritingQueue_${TODAY}_04.csv.gz');
;
