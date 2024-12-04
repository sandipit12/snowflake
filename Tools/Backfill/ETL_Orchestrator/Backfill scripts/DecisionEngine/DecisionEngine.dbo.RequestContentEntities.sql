USE [ETL_Orchestrator]
GO
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
-- select * from [Batch].[Backfill];
DECLARE
	@DATABASE_NAME	SYSNAME
	,@SCHEMA_NAME SYSNAME
	,@TABLE_NAME SYSNAME
	,@TABLE_ID_COLUMN_NAME VARCHAR(20)='Id' /* The name of the clustered key column, default Id*/
	,@TABLE_DATE_COLUMN_NAME VARCHAR(20)='CreateDate' /* The name of the Transaction Date column, default CreateDate*/
	,@MIN_ID INT=NULL /* The last ID to backfill. If not specified, the first record is used*/
	,@MAX_ID INT=NULL  /* The most recent ID to backfill. If not specified the latest record is used*/
	,@GROUP_BY_DAY_OR_HOUR VARCHAR(10)='HOUR'
	,@CUSTOM_QUERY NVARCHAR(MAX) =N'SELECT	[Id]
        ,[RequestMetaData]
        ,[ResponseMetaData]
        ,[CorrelationId]
        ,[CreateDate]
        ,CONVERT(VARCHAR(MAX), DECOMPRESS(RequestBody)) AS RequestBodyJson
		,CONVERT(VARCHAR(MAX), DECOMPRESS(ResponseBody)) AS ResponseBodyJson
FROM	[DecisionEngine].[dbo].[RequestContentEntities]
WHERE	
    Id >= @FromId 
	AND Id <= @ToId
	AND Id NOT IN (78865762,78865799,78866138,78866179,78866266,78866296,78866340,78867537,78869128,78869147,78869150,78869166,78869169,78869174,78869263,78869279,78869707,78869727,78870200,78870202,78870875,78871001,78871020,78871923,78872076,78872271,78872481,78872566,78872573,78872586,78874082,78874086,78874138,78874224,78874251,78874846,78874848,78874854,78874859,78878540,78879838,78884210,78884518,78886380,78886448,79437000,79437805,79852209,79852213,79853388,79853398,79853726,79853730,79853743,79857033,79859626,79859939,79862970,79862980,79863539,79863549,79864615,79865217,79865669,79865713,80324453,80324456,80325108,80326075,80327898,80329711,80331122,80331244,80331246,80331582,80332324,80333849,80334097,80335205,80335359,80335360,80336429,80338867,80340186,80340914,80341008,80341286,80343048,80343437,80343445,80343447,80345033,80346571,80347098,80347276,80347808,80347992,80348539,80348544,80348734,80348875,80351271,80351272,80351601,80351783,80353506,80355888,80356253,80356405,80358192,80358193,80676699,80677464,80680794,80681119,80681120,80681125,80681537,80681576,80681835,80681869,80683814,80683817,80684219,80684398,80684662,80685024,80685030,80687062,80687063,80687064,80687191,80687338,80690860,80690866,80692187,80692317,80692430,80694318,80694403,80694404,80694504,80694708,80694852,80695212,80695217,80695411,80695620,80696823,80697817,80698977,80698978,80700361,80702480,80705221,80705237,80705240,80705430,80705435,80705601,80705603,80706149,80706378,80707004,80707007,80707249,80708501,80709492,80711358,80711438,80715546,80716372,80717140,80717388,80717412,80718301,80719032,80719170,80719427,80719978,80719991,80720461,80723445,80727022,80727026,80727201,80729288,80729297,80729300,80729429,80729964,80730169,80730175,80730213,80732681,80735044,80735686,80735691,80735693,80947168,80947312,81400865,81402372,81403791)
;'
	,@PreviousWaterMark INT -- This is the Min ID in Snowflake live table.
	,@Batch_size INT -- number of records to backfill in each batch
	,@Break_flag int=0

	/* The following variables need to be set per table*/
	SET @DATABASE_NAME='DecisionEngine'
	SET @SCHEMA_NAME='dbo'
	SET @TABLE_NAME='RequestContentEntities'
	SET @PreviousWaterMark=175404898 -- Got this from Snowflake live table using MIN(ID) From table.
	SET @Batch_size=8000000 -- This is different in each table, experiment as long as the number of records is <=500 in backfill table.

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
	
		IF (SELECT ISNULL(MIN(TransactionDate),GETDATE()) FROM [Batch].[Backfill] WHERE DatabaseName=@DATABASE_NAME and TableName=@TABLE_NAME)  < '2021-01-01'
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

	
		 