SELECT ID
      ,CheckStatus
	    ,ad_check.EnumItemKey AS CheckStatusName
      ,UDPRN
      ,ElectoralRollStatus
      ,AddressType
	    ,user_ad_type.EnumItemKey AS AddressTypeName
      ,UserId
      ,CHAR(34) + REPLACE(REPLACE(AbodeNumber,CHAR(34), "\" + CHAR(34)),CHAR(9),"") + CHAR(34) 
      ,CHAR(34) + REPLACE(REPLACE(BuildingNumber,CHAR(34), "\" + CHAR(34)),CHAR(9),"") + CHAR(34) 
      ,CHAR(34) + REPLACE(REPLACE(BuildingName,CHAR(34), "\" + CHAR(34)),CHAR(9),"") + CHAR(34) 
      ,CHAR(34) + REPLACE(REPLACE(Company,CHAR(34), "\" + CHAR(34)),CHAR(9),"") + CHAR(34) 
      ,Department
      ,CHAR(34) + REPLACE(REPLACE(Line1,CHAR(34), "\" + CHAR(34)),CHAR(9),"") + CHAR(34)  
      ,CHAR(34) + REPLACE(REPLACE(Line2,CHAR(34), "\" + CHAR(34)),CHAR(9),"") + CHAR(34) 
      ,CHAR(34) + REPLACE(REPLACE(Line3,CHAR(34), "\" + CHAR(34)),CHAR(9),"") + CHAR(34) 
      ,CHAR(34) + REPLACE(REPLACE(Line4,CHAR(34), "\" + CHAR(34)),CHAR(9),"") + CHAR(34) 
      ,CHAR(34) + REPLACE(REPLACE(Line5,CHAR(34), "\" + CHAR(34)),CHAR(9),"") + CHAR(34) 
      ,CHAR(34) + REPLACE(REPLACE(PrimaryStreet,CHAR(34), "\" + CHAR(34)),CHAR(9),"") + CHAR(34) 
      ,CHAR(34) + REPLACE(REPLACE(SecondaryStreet,CHAR(34), "\" + CHAR(34)),CHAR(9),"") + CHAR(34) 
      ,CHAR(34) + REPLACE(REPLACE(DoubleDependentLocality,CHAR(34), "\" + CHAR(34)),CHAR(9),"") + CHAR(34) 
      ,CHAR(34) + REPLACE(REPLACE(DependentLocality,CHAR(34), "\" + CHAR(34)),CHAR(9),"") + CHAR(34) 
      ,CHAR(34) + REPLACE(REPLACE(Town,CHAR(34), "\" + CHAR(34)),CHAR(9),"") + CHAR(34) 
      ,CHAR(34) + REPLACE(REPLACE(PostCode,CHAR(34), "\" + CHAR(34)),CHAR(9),"") + CHAR(34) 
      ,CHAR(34) + REPLACE(REPLACE(County,CHAR(34), "\" + CHAR(34)),CHAR(9),"") + CHAR(34) 
      ,CHAR(34) + REPLACE(REPLACE(Country,CHAR(34), "\" + CHAR(34)),CHAR(9),"") + CHAR(34) 
      ,POBox
      ,Mailsort
      ,DPS
      ,Barcode
      ,AddressUsage
      ,YearIn
      ,YearOut
      ,MonthsAtAddress
      ,Updated
      ,AddressStatus
      ,PartyId
      ,CHAR(34) + REPLACE(REPLACE(PostCodeCompact,CHAR(34), "\" + CHAR(34)),CHAR(9),"") + CHAR(34) 
      ,CompanyID
      ,FK_Application
      ,ApplicationType
	    ,app_type.EnumItemKey AS ApplicationTypeName
      ,FirstDateOnElectoralRoll
      ,MonthsAtAddressUserEntered
      ,CreateDate
      ,UpdateDate
      /* metadata colums -- should not incldue in the hash_key */
      ,@@ServerName as Source_System
      ,convert(date, getdate()) as Snapshot_Date
      /*--------------------------------------------------------------------
      -- derived business key
      -------------------------------------------------------------------- */
      ,HASHBYTES("SHA2_256",
        CONCAT_WS("|",
           ID
          ,CheckStatus
          ,UDPRN
          ,ElectoralRollStatus
          ,AddressType
          ,UserId
          ,AbodeNumber
          ,BuildingNumber
          ,BuildingName
          ,Company
          ,Department
          ,Line1
          ,Line2
          ,Line3
          ,Line4
          ,Line5
          ,PrimaryStreet
          ,SecondaryStreet
          ,DoubleDependentLocality
          ,DependentLocality
          ,Town
          ,PostCode
          ,County
          ,Country
          ,POBox
          ,Mailsort
          ,DPS
          ,Barcode
          ,AddressUsage
          ,YearIn
          ,YearOut
          ,MonthsAtAddress
          ,Updated
          ,AddressStatus
          ,PartyId
          ,PostCodeCompact
          ,CompanyID
          ,FK_Application
          ,ApplicationType
          ,FirstDateOnElectoralRoll
          ,MonthsAtAddressUserEntered
          ,CreateDate
          ,UpdateDate
		      ,ad_check.EnumItemKey
		      ,user_ad_type.EnumItemKey
		      ,app_type.EnumItemKey
           )
      ) AS hash_key
       FROM dbo.Addresses ad
       LEFT JOIN dbo.ENUMMAPREADONLY ad_check ON ad.CheckStatus = ad_check.EnumItemNumber AND EnumTypeFullyQualifiedName="RS.APIAddressCheckResult"
       LEFT JOIN dbo.ENUMMAPREADONLY user_ad_type ON ad.AddressType = user_ad_type.EnumItemNumber AND user_ad_type.EnumTypeFullyQualifiedName="RS.UserAddressType"
       LEFT JOIN dbo.ENUMMAPREADONLY app_type ON ad.ApplicationType = app_type.EnumItemNumber AND app_type.EnumTypeFullyQualifiedName="RS.DataType.APPLICATION_TYPE"
        WHERE
        ID >=6000000
        ORDER BY 
        ID ;

