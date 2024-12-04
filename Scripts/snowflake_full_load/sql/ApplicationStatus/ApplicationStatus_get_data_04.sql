SELECT PK_ApplicationStatus
      ,FK_LoanRequest
      ,ActivityTime
      ,Status
      ,FK_AdminUser
      ,isCreditUpdate
      ,UpdateType
      ,APR
      /* metadata colums -- should not incldue in the hash_key */
      ,@@ServerName as Source_System
      ,convert(date, getdate()) as Snapshot_Date
      /*--------------------------------------------------------------------
      -- derived business key
      -------------------------------------------------------------------- */
      ,HASHBYTES("SHA2_256",
        CONCAT_WS("|",
           PK_ApplicationStatus
          ,FK_LoanRequest
          ,ActivityTime
          ,Status
          ,FK_AdminUser
          ,isCreditUpdate
          ,UpdateType
          ,APR  
           )
      ) AS hash_key
      FROM dbo.ApplicationStatus
        WHERE
        PK_ApplicationStatus >= 10470000
        ORDER BY 
        PK_ApplicationStatus;
