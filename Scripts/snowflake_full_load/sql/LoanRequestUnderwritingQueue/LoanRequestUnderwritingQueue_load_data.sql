COPY INTO staging.dbo_LoanRequestUnderwritingQueue FROM '@STAGE_VENUS_LIVE/dbo.LoanRequestUnderwritingQueue/full/2021/2021_12/2021_12_14/'
file_format = STAGING.CSV_GZIP_SPACE_TRIM
    --PATTERN = "dbo[.]LoanRequestUnderwritingQueue_2021_12_14_[0-9]{2}[.]csv[.]gz"
    -- Pattern does not work, I think it is looking at the full path not just the filename.
    files=('dbo.LoanRequestUnderwritingQueue_2021_12_14_01.csv.gz', 'dbo.LoanRequestUnderwritingQueue_2021_12_14_02.csv.gz','dbo.LoanRequestUnderwritingQueue_2021_12_14_03.csv.gz','dbo.LoanRequestUnderwritingQueue_2021_12_14_04.csv.gz');
;
