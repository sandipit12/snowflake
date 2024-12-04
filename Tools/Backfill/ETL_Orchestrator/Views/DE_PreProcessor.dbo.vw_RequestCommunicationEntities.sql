/*
This view is created in the source database DecisionEngine_PreProcessor in UKS-RS-DW01
It is required as the table does not have a date column which is needed by the main backfill script

*/

CREATE VIEW vw_RequestCommunicationEntities as
SELECT  rce.[Id]
      ,rce.[ExternalRequestContentId]
      ,rce.[FabricUri]
      ,rce.[Path]
      ,rce.[RequestContentId]
	  ,content.CreateDate
  FROM [DecisionEngine_PreProcessor].[dbo].[RequestCommunicationEntities] rce
  LEFT OUTER JOIN [DecisionEngine_PreProcessor].[dbo].[RequestContentEntities] content on rce.RequestContentId=content.Id
