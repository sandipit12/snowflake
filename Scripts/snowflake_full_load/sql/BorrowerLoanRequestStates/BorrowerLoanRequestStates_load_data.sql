COPY INTO staging.dbo_BorrowerLoanRequestStates FROM '@STAGE_VENUS_LIVE/dbo.BorrowerLoanRequestStates/full/2021/2021_12/2021_12_16/'
file_format = STAGING.CSV_GZIP_SPACE_TRIM
 --   PATTERN = ".*.dbo[.]BorrowerLoanRequestStates_2021_12_16_[0-9]{2}[.]csv[.]gz"
    files=('dbo.BorrowerLoanRequestStates_2021_12_16_01.csv.gz');
;
