use ETL_Orchestrator

-- Find gaps in data
SELECT A.ID, A.FromId, A.ToId,'------' ,B.ID, B.FromId, b.ToId
	,CAST(b.ToId as int) +1 - cast(A.FromId as int) as Gap
	,CAST(a.ToId as int) - CAST(a.FromId as int) NoOfRecords
	,a.[FileName]
	,b.BatchNo
FROM
	(select  *  from Batch.Backfill (nolock) where  tableName='RequestCommunicationEntities' ) A
	LEFT OUTER JOIN  (select  *  from Batch.Backfill (nolock) where  tableName='RequestCommunicationEntities' ) B 
		on CAST(a.FromId as int) = CAST(B.ToId as int) +1
--where
--	b.Id is null
--	a.BatchNo in ('F6ECF820-D1F1-4294-8C9E-799A51C08E30','D454E759-01F1-40E1-B87E-9087D39218B6')
Order by  
	a.ID
;

-- Find gaps in data -- joining by ID
SELECT A.ID, A.FromId, A.ToId,'------' ,B.ID, B.FromId, b.ToId
	,CAST(b.ToId as int) +1 - cast(A.FromId as int) as Gap
	,CAST(a.ToId as int) - CAST(a.FromId as int) NoOfRecords
	--,a.[FileName]
	,b.BatchNo
	--,a.TransactionDate
	,'UPDATE Batch.Backfill SET ToId=' + a.FromId + '-1 WHERE ID=' + CAST (B.ID as VARCHAR(10)) + ';'
FROM
	(select  *  from Batch.Backfill (nolock) where  tableName='RequestContentEntities' ) A
	LEFT OUTER JOIN  (select  *  from Batch.Backfill (nolock) where  tableName='RequestContentEntities' ) B 
		on a.ID=(b.ID-1)
where
	(CAST(b.ToId as int) +1 - cast(A.FromId as int)) > 0
	--AND A.BatchNo='B0333014-46E4-4916-B7BA-4A42870213BC'
Order by  
	a.ID
;

/*
UPDATE B
	SET B.ToId= a.FromId -1
FROM
	(select  *  from Batch.Backfill (nolock) where  tableName='RequestCommunicationEntities' ) A
	LEFT OUTER JOIN  (select  *  from Batch.Backfill (nolock) where  tableName='RequestCommunicationEntities' ) B 
		on a.ID=(b.ID-1)
where
	(CAST(b.ToId as int) +1 - cast(A.FromId as int)) > 0
;

*/
--UPDATE Batch.Backfill SET ToId=293553878-1 WHERE ID=4;

select  *  from Batch.Backfill (nolock) where  TableNameFQN='DecisionEngine_preprocessor.dbo.RequestCommunicationEntities'  order by ID ;
select  *  from Batch.Backfill (nolock) where  TableNameFQN='DecisionEngine_preprocessor.dbo.RequestContentEntities'  order by ID ;
select  *  from Batch.Backfill (nolock) where  TableNameFQN='DecisionEngine.dbo.RequestContentEntities' order by ID ;

--DELETE FROM Batch.Backfill  where  DatabaseName='DecisionEngine';
SELECT  rce.[Id]        ,rce.[ExternalRequestContentId]        ,rce.[FabricUri]        ,rce.[Path]        ,rce.[RequestContentId]     ,content.CreateDate    
FROM [DecisionEngine_PreProcessor].[dbo].[RequestCommunicationEntities] rce      LEFT OUTER JOIN [DecisionEngine_PreProcessor].[dbo].[RequestContentEntities] content on rce.RequestContentId=content.Id    WHERE      rce.Id>=294694807 AND rce.Id<=295399251 ;

--delete from Batch.Backfill where TableNameFQN='DecisionEngine.dbo.RequestContentEntities'; -- 10208


select *
from 
	Batch.Backfill (nolock) 
where  
	[FileName] in ('dbo.RequestCommunicationEntities_20210107_000000_582.parquet.snappy','dbo.RequestCommunicationEntities_20210106_000000_583.parquet.snappy')
;


SELECT  a.Id, B.Id, a.FromId, a.ToId, b.FromId, b.ToId, a.BatchNo, b.BatchNo
FROM
	(select  *  from Batch.Backfill (nolock) where  tableName='RequestCommunicationEntities' ) A
	INNER JOIN (select  *  from Batch.Backfill (nolock) where  tableName='RequestCommunicationEntities' ) B ON a.Id <> b.Id
WHERE
	(a.FromId < b.FromId and a.ToId >  b.ToId )
;


IF EXISTS (SELECT 1 FROM Batch.Backfill (nolock)  WHERE @myValueLo <= ExistingRangeEnd AND @myValueHi >= ExistingRangeStart)
  print ('Overlaps')
ELSE
  print ('Doesnt overlap')
;

select *
from 
	Batch.Backfill (nolock) 
where  
	BatchNo in ('65F0C501-0E45-4A8C-992E-2C4564B2538E')
Order by 
	Id
;



select * from ETL_Orchestrator.Batch.Backfill (nolock) where DatabaseName='DecisionEngine' and tableName='RequestContentEntities' order by ID;

select * from Batch.Backfill (nolock) where tableName='RequestCommunicationEntities' order by ID;



167736598	167757150
167708068	167736597

select 167757150-167708068; --49082

167757152

56752765	56927583
56557802	56752818

select 56927583 -56557802; 

--56752808
--189069901

select * from Batch.Backfill (nolock) where  [FileName] in (
'dbo.RequestCommunicationEntities_20210107_000000_582.parquet.snappy'
,'dbo.RequestCommunicationEntities_20210106_000000_583.parquet.snappy'
);


--'raw/DecisionEngine_PreProcessor/dbo.RequestCommunicationEntities/backfill/2021/2021_01/2021_01_07/dbo.RequestCommunicationEntities_20210107_000000_582.parquet.snappy'
--,'raw/DecisionEngine_PreProcessor/dbo.RequestCommunicationEntities/backfill/2021/2021_01/2021_01_06/dbo.RequestCommunicationEntities_20210106_000000_583.parquet.snappy'

-- raw/DecisionEngine_PreProcessor/dbo.RequestCommunicationEntities/backfill/2021/2021_01/2021_01_07/dbo.RequestCommunicationEntities_20210107_000000_582.parquet.snappy
-- raw/DecisionEngine_PreProcessor/dbo.RequestCommunicationEntities/backfill/2021/2021_01/2021_01_06/dbo.RequestCommunicationEntities_20210106_000000_583.parquet.snappy


select * from DECISIONENGINE.DBO.REQUESTCONTENTENTITIES where ID= 43627970; -- 2021-01-01 01:00:01.0866667
select * from DECISIONENGINE.DBO.REQUESTCONTENTENTITIES where ID= 175356456; -- 2021-12-16 16:00:01.0133333
select * from DECISIONENGINE.DBO.REQUESTCONTENTENTITIES where ID= 111512332;

use ETL_DataExtraction;
EXECUTE [DecisionEngine].[Get_dbo_RequestContentEntities] 111512332, 111561434;

-- =========================
SELECT 
		1
		,'DecisionEngine' 
		,'DBO' 
		,'RequestContentEntities'
		,MIN(Id) From_ID 
		,MAX(Id)+1 To_ID 
		,CONVERT(VARCHAR(10),CreateDate,121) As TransactionDate
		,CONVERT(VARCHAR(02),CreateDate,108) + '0000' As TransactionTime
		,0 as ProcessedFlag
		,COUNT(*) as RecordCount
	FROM
			DecisionEngine.dbo.RequestContentEntities
	WHERE
		Id >= 167404898	
		AND Id <= 175404898 
		--AND CONVERT(VARCHAR(10),CreateDate,121)=
	GROUP BY
		CONVERT(VARCHAR(10),CreateDate,121), CONVERT(VARCHAR(02),CreateDate,108)
	ORDER BY 
		MIN(Id) DESC;

