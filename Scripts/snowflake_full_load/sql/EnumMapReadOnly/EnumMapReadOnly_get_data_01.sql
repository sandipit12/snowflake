SELECT 
      CONCAT_WS("|",[EnumTypeFullyQualifiedName],[EnumItemNumber]) as ID /* THis is a madeup filed to aid merge joins*/
      ,[EnumTypeFullyQualifiedName]
      ,[EnumItemNumber]
      ,[EnumItemKey]
      ,[EnumItemDescription]
      ,[LastModifiedDate]
 /* metadata colums -- should not incldue in the hash_key */
    ,@@ServerName as Source_System
    ,convert(date, getdate()) as Snapshot_Date
/*--------------------------------------------------------------------
-- derived business key
-------------------------------------------------------------------- */
    ,HASHBYTES("SHA2_256",
      CONCAT_WS("|",
        [EnumTypeFullyQualifiedName]
        ,[EnumItemNumber]
        ,[EnumItemKey]
        ,[EnumItemDescription]
        ,[LastModifiedDate]     
      )
    ) AS hash_key
 FROM 
	[dbo].[EnumMapReadOnly]



