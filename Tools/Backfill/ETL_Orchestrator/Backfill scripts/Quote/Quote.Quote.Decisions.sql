USE [ETL_Orchestrator]
GO
-- select top 10 * from Quote.quote.Decisions;
-- ALTER TABLE [Batch].[Backfill] ALTER COLUMN Query VARCHAR(MAX);
/*

Notes:
=================

In live:
ETL_Orchestrator: database runs on 10.32.30.31,1971 (Venus primary). This database contain the metadata about the backfill progress. A copy of ETL_Orchistrator is running
on UKS-RS-DW01 as a staging area used for creating the backfill records that are then copied into live.
ETL_DataExtraction: database runs on UKS-RS-DW01.ratesetter.local,1897. This database contains the Stored procedures to Get data from the source databases 
The source databases (example DecisionEngine) is restored on UKS-RS-DW01.

--==========================



Steps:
------
1. Restore the Source database on UKS-RS-DW01. For example DecisionEngine
2. Restore ETL_DataExtraction and ETL_Orchestrator on UKS-RS-DW01
3. Deploy the following objects to [ETL_Orchestrator]
	a. [Batch].[Backfill] table
	b. Batch.Create_Backfill stored procedure
4. Get the Minimum ID of the table you are backfiling from Production. This will become the MAX ID in the procedure 
e.g. in Snowflake Live, run the following to ge the Min(ID).
	select min(ID) from DECISION_ENGINE.raw.dbo_request_content_entities;  -- 175404898


5. Copy the data from [Batch].[Backfill] table into production database on LDC.
use script [Copy Backfill data.sql]

select * from Batch.Backfill;

6. Execute the ADF to land the data into the lake as parquet files
7. Load data from the lake into staging area in Snowflake.
8. Merge the data into Raw



WARNING:
There is a limitation in ADF ForEach loop which processes a maximum of 500 records. 
If a table contain more than 500 records, it should be broken down into smaller batches for example, one year at a time.

*/
-- ================
--- truncate table [Batch].[Backfill];
-- select * from [Batch].[Backfill] where TableNameFQN='Quote.Quote.Decisions';
DECLARE
	@DATABASE_NAME	SYSNAME
	,@SCHEMA_NAME SYSNAME
	,@TABLE_NAME SYSNAME
	,@TABLE_ID_COLUMN_NAME VARCHAR(20)='Id' /* The name of the clustered key column, default Id*/
	,@TABLE_DATE_COLUMN_NAME VARCHAR(20)='CreateDateUtc' /* The name of the Transaction Date column, default CreateDate*/
	,@MIN_ID INT=NULL /* The last ID to backfill. If not specified, the first record is used*/
	,@MAX_ID INT=NULL  /* The most recent ID to backfill. If not specified the latest record is used*/
	,@GROUP_BY_DAY_OR_HOUR VARCHAR(10)='DAY'
	,@CUSTOM_QUERY NVARCHAR(MAX) =N'
	SELECT	*
	FROM	[Quote].[Quote].[Decisions]
	WHERE	
		Id >= @FromId 
		AND Id <= @ToId
	;'
	,@PreviousWaterMark INT -- This is the Min ID in Snowflake live table.
	,@Batch_size INT -- number of records to backfill in each batch
	,@Break_flag int=0

	/* The following variables need to be set per table*/
	SET @DATABASE_NAME='Quote'
	SET @SCHEMA_NAME='Quote'
	SET @TABLE_NAME='Decisions'
	SET @PreviousWaterMark=4730318 -- Got this from Snowflake live table using MIN(ID) From table.
	SET @Batch_size=100000 -- This is different in each table, experiment as long as the number of records is <=500 in backfill table.

	SET @MIN_ID=@PreviousWaterMark-@Batch_size
	SET @MAX_ID=@PreviousWaterMark

	WHILE (@Break_flag=0)
	BEGIN
		PRINT('loop')
		EXECUTE [Batch].[Create_Backfill] 
		   @DATABASE_NAME
		  ,@SCHEMA_NAME
		  ,@TABLE_NAME
		  ,@TABLE_ID_COLUMN_NAME
		  ,@TABLE_DATE_COLUMN_NAME
		  ,@MIN_ID
		  ,@MAX_ID
		  ,@GROUP_BY_DAY_OR_HOUR
		  ,@CUSTOM_QUERY

		SET @MAX_ID=@MIN_ID-1
		SET @MIN_ID=@MIN_ID-@Batch_size
	
		IF ((SELECT ISNULL(MIN(TransactionDate),GETDATE()) FROM [Batch].[Backfill] WHERE DatabaseName=@DATABASE_NAME and TableName=@TABLE_NAME)  < '2021-01-01')
		OR (@MIN_ID < 0 AND @MAX_ID <0)
		BEGIN
			SET @Break_flag=1;
			PRINT ('Break loop')
		END

	END

-- Fix gap in data
-- =======================
UPDATE B
	SET B.ToId= a.FromId -1
FROM
	Batch.Backfill  A
	LEFT OUTER JOIN Batch.Backfill B on a.ID=(b.ID-1)
where
	A.DatabaseName=B.DatabaseName
	AND A.SchemaName=B.SchemaName
	AND A.tableName=B.TableName
	AND A.DatabaseName=@DATABASE_NAME
	AND A.SchemaName=@SCHEMA_NAME
	AND A.TableName=@TABLE_NAME
	AND (CAST(b.ToId as int) +1 - cast(A.FromId as int)) > 0
;

	
		 