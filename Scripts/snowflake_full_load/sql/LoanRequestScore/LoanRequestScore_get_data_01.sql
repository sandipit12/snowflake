SELECT ID
      ,LoanRequestId
      ,ScoreType
      ,ScoreValue
      ,IsActive
      ,CreateDate
      ,RSCreditCategory
      /* metadata colums -- should not incldue in the hash_key */
      ,@@ServerName as Source_System
      ,convert(date, getdate()) as Snapshot_Date
      /*--------------------------------------------------------------------
      -- derived business key
      -------------------------------------------------------------------- */
      ,HASHBYTES("SHA2_256",
        CONCAT_WS("|",
          ID
          ,LoanRequestId
          ,ScoreType
          ,ScoreValue
          ,IsActive
          ,CreateDate
          ,RSCreditCategory   
           )
      ) AS hash_key
      FROM dbo.LoanRequestScore
        WHERE
        Id < 300000
         ORDER BY 
         Id;


