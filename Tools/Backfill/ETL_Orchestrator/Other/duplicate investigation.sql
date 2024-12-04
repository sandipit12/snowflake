

select * from DECISIONENGINE_PREPROCESSOR.DBO.REQUESTCOMMUNICATIONENTITIES  where ID In (56752808, 189069901);
select * from DECISIONENGINE_PREPROCESSOR.DBO.[vw_RequestCommunicationEntities]  where ID In (56752808, 189069901);

select * from ETL_Orchestrator.Batch.Backfill (nolock) where tableName='RequestContentEntities' order by ID;
select * from ETL_Orchestrator.Batch.Backfill (nolock) where tableName='RequestCommunicationEntities' order by ID;

select * from decisionEngine.dbo.RequestContentEntities where ID=167757152;
select count(*) from decisionEngine.dbo.RequestContentEntities WHERE CreateDate between '2021-01-01' and '2022-01-01' ; --139285105


SELECT 
	1
	,'DE' 
	,'dbo' 
	,'Comm'
	,MIN(Id) From_ID 
	,MAX(Id) To_ID 
	,CONVERT(VARCHAR(10),CreateDate,121) As TransactionDate
	,'000000' as TransactionHour
	,0 as ProcessedFlag
	,COUNT(*) as RecordCount
FROM
		DecisionEngine_PreProcessor.dbo.vw_RequestCommunicationEntities 
WHERE
	Id >= 56927584
	AND Id <= 57090029 
GROUP BY
	CONVERT(VARCHAR(10),CreateDate,121)
ORDER BY 
	CONVERT(VARCHAR(10),CreateDate,121) DESC
;

SELECT ID
	,CONVERT(VARCHAR(10),CreateDate,121) As TransactionDate
	,CreateDate
	--,COUNT(*) as RecordCount
FROM
		DecisionEngine_PreProcessor.dbo.vw_RequestCommunicationEntities 
WHERE
	(Id >= 56752765 AND Id <= 56927583 )
ORDER BY ID;

SELECT 
	1
	,'DE' 
	,'dbo' 
	,'Comm'
	,MIN(Id) From_ID 
	,MAX(Id) To_ID 
	,CONVERT(VARCHAR(10),CreateDate,121) As TransactionDate
	,'000000' as TransactionHour
	,0 as ProcessedFlag
	,COUNT(*) as RecordCount
FROM
		DecisionEngine_PreProcessor.dbo.vw_RequestCommunicationEntities 
WHERE
	(Id >= 56752765 AND Id <= 56927583 )
	--and ID IN (56752768)
GROUP BY
	CONVERT(VARCHAR(10),CreateDate,121)
ORDER BY 
	CONVERT(VARCHAR(10),CreateDate,121) DESC
;

-- returns the following to sets
/*
From_ID		To_ID		TransactionDate	TransactionHour	ProcessedFlag	RecordCount
56752765	56927583	2021-01-07		000000				0		174798
56752767	56752818	2021-01-06		000000				0		21

*/

SELECT * from DecisionEngine_PreProcessor.dbo.vw_RequestCommunicationEntities 
where 	
	Id>= 56752767 and ID <=	56752818 -- 52 records (but count in teh above script is 21!)
	and ID in (
		SELECT ID from DecisionEngine_PreProcessor.dbo.vw_RequestCommunicationEntities 
		where 	
		Id>= 56752765 and ID <=	56927583 -- couunt is 174,819 (but in the above script it is 174,798)... The difference is 21!!!!!!
	)

	
--
SELECT CONVERT(VARCHAR(10),CreateDate,121), count(*) 
from 
	DecisionEngine_PreProcessor.dbo.vw_RequestCommunicationEntities  
where 	
	Id>= 56752767 and ID <=	56752818 
group By 
	CONVERT(VARCHAR(10),CreateDate,121); -- 52 records


SELECT CONVERT(VARCHAR(10),CreateDate,121), count(*) 
from 
	DecisionEngine_PreProcessor.dbo.vw_RequestCommunicationEntities  
where 	
	Id>= 56752765 and ID <=	56927583 
group By 
	CONVERT(VARCHAR(10),CreateDate,121); -- 52 records



select CONVERT(VARCHAR(10),CreateDate,121)
from 
	DecisionEngine_PreProcessor.dbo.vw_RequestCommunicationEntities  
where 
	Id=56752768
GROUP BY
	CONVERT(VARCHAR(10),CreateDate,121)
ORDER BY 
	CONVERT(VARCHAR(10),CreateDate,121) DESC

;


56927584	57090029
56752765	56927583

SELECT A.ID, A.FromId, A.ToId, B.ID, B.FromId, b.ToId
	, CAST(b.ToId as int) - cast(A.FromId as int) as Numberofrecords
	, CAST(b.FromId as int) - cast(A.ToId as int) as gap
	,a.[FileName]
FROM
	(select  *  from ETL_Orchestrator.Batch.Backfill (nolock) where  tableName='vw_RequestCommunicationEntities' ) A
	LEFT OUTER JOIN  (select  *  from ETL_Orchestrator.Batch.Backfill (nolock) where  tableName='vw_RequestCommunicationEntities' ) B on A.Id=B.ID+1
where
	CAST(b.FromId as int) - cast(A.ToId as int) <>0
	and 
	a.[FileName] in ('dbo.RequestCommunicationEntities_20210107_000000_582.parquet.snappy','dbo.RequestCommunicationEntities_20210106_000000_583.parquet.snappy')
;

select  BatchNo, Min(FromId), Min(  
from 
	ETL_Orchestrator.Batch.Backfill (nolock) 
where  
	tableName='vw_RequestCommunicationEntities'
group by
	BatchNo;