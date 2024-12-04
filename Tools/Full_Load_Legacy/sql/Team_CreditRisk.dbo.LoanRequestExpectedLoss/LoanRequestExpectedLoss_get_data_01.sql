SELECT LoanRequest_LoanID
      ,pk_loanrequest
      ,LoanAmount
      ,el_frontbook_rate
      ,el_frontbook_amount
      ,el_backbook_rate
      ,el_backbook_amount
      ,el_latest_rate
      ,el_latest_amount
      ,el_at_origination
      ,erebus_score
      ,LoanNumber
      ,LoanID
      /* metadata colums -- should not incldue in the hash_key */
      ,@@ServerName as Source_System
      ,convert(date, getdate()) as Snapshot_Date
      /*--------------------------------------------------------------------
      -- derived business key
      -------------------------------------------------------------------- */
      ,HASHBYTES("SHA2_256",
        CONCAT_WS("|",
          LoanRequest_LoanID
         ,pk_loanrequest
         ,LoanAmount
         ,el_frontbook_rate
         ,el_frontbook_amount
         ,el_backbook_rate
         ,el_backbook_amount
         ,el_latest_rate
         ,el_latest_amount
         ,el_at_origination
         ,erebus_score
         ,LoanNumber
         ,LoanID   
           )
      ) AS hash_key
        FROM dbo.LoanRequestExpectedLoss
         ORDER BY 
         LoanRequest_LoanID;


