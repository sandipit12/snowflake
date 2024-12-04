SELECT [Id]
      ,[LoanRequestId]
      ,[Queue]
      ,[CreateDate]
      ,[CreatedByProcess]
      ,[CreatedByAdminUserId]
      ,[ModifiedByProcess]
      ,[ModifiedByAdminUserId]
      ,[ExitDate]		
/* metadata colums -- should not incldue in the hash_key */
    ,@@ServerName as Source_System
    ,convert(date, getdate()) as Snapshot_Date
/*--------------------------------------------------------------------
-- derived business key
-------------------------------------------------------------------- */
    ,HASHBYTES("SHA2_256",
      CONCAT_WS("|",
       [Id]
      ,[LoanRequestId]
      ,[Queue]
      ,[CreateDate]
      ,[CreatedByProcess]
      ,[CreatedByAdminUserId]
      ,[ModifiedByProcess]
      ,[ModifiedByAdminUserId]
      ,[ExitDate]
      )
    ) AS hash_key
  FROM 
	[dbo].[LoanRequestUnderwritingQueue]
  WHERE
    Id >= 250000 AND Id < 500000
  ORDER BY 
      Id;



