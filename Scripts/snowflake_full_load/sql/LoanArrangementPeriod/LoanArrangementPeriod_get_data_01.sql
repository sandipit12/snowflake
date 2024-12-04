SELECT 
     [Id]
    ,[LoanId]
    ,[PeriodType]
    ,[PeriodStartDate]
    ,[PeriodEndDate]
    ,[CreationDate]
 /* metadata colums -- should not incldue in the hash_key */
    ,@@ServerName as Source_System
    ,convert(date, getdate()) as Snapshot_Date
/*--------------------------------------------------------------------
-- derived business key
-------------------------------------------------------------------- */
    ,HASHBYTES("SHA2_256",
      CONCAT_WS("|",
        [Id]
       ,[LoanId]
       ,[PeriodType]
       ,[PeriodStartDate]
       ,[PeriodEndDate]
       ,[CreationDate]
                )
              ) AS hash_key
 FROM 
       [dbo].LoanArrangementPeriod
 ORDER BY ID;