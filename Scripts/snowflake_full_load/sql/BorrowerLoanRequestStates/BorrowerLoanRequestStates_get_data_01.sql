SELECT PK_BorrowerLoanRequestStates
   ,StatusName
   ,Action
   ,IsFirstContact
 /* metadata colums -- should not incldue in the hash_key */
    ,@@ServerName as Source_System
    ,convert(date, getdate()) as Snapshot_Date
/*--------------------------------------------------------------------
-- derived business key
-------------------------------------------------------------------- */
    ,HASHBYTES("SHA2_256",
      CONCAT_WS("|",
        PK_BorrowerLoanRequestStates
        ,StatusName
       ,Action
       ,IsFirstContact    
      )
    ) AS hash_key
FROM dbo.BorrowerLoanRequestStates



