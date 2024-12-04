COPY INTO staging.dbo_BorrowerLoanRequestStates FROM '@STAGE_VENUS_LIVE/dbo.BorrowerLoanRequestStates/full/${YYYY}/${YYYY_MM}/${TODAY}/'
file_format = STAGING.CSV_GZIP_SPACE_TRIM
 --   PATTERN = ".*.dbo[.]BorrowerLoanRequestStates_${TODAY}_[0-9]{2}[.]csv[.]gz"
    files=('dbo.BorrowerLoanRequestStates_${TODAY}_01.csv.gz');
;
