USE [ETL_Orchestrator]
GO
-- ====================================
-- Sproc to populate the backfill table
-- ====================================

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES where SPECIFIC_SCHEMA='Batch' AND ROUTINE_NAME = 'Create_Backfill' )
BEGIN
	DROP PROCEDURE Batch.Create_Backfill;
END
GO

CREATE PROC Batch.Create_Backfill(
		@DATABASE_NAME	SYSNAME
		,@SCHEMA_NAME SYSNAME
		,@TABLE_NAME SYSNAME
		,@TABLE_ID_COLUMN_NAME VARCHAR(20)='Id' /* The name of the clustered key column, default Id*/
		,@TABLE_DATE_COLUMN_NAME VARCHAR(20)='CreateDate' /* The name of the Transaction Date column, default CreateDate*/
		,@MIN_ID INT=NULL /* The last ID to backfill. If not specified, the first record is used*/
		,@MAX_ID INT=NULL  /* The most recent ID to backfill. If not specified the latest record s used*/
		,@GROUP_BY_DAY_OR_HOUR VARCHAR(10)='DAY' /*Partition records by Day or Hour*/
		,@CUSTOM_QUERY VARCHAR(8000)=NULL /* custom query or stored procedure */
)
AS
BEGIN
	DECLARE @SQL1 NVARCHAR(MAX)=''
			,@SQL2 NVARCHAR(MAX)=''
			,@SQL3 NVARCHAR(MAX)=''
			,@QUERY NVARCHAR(MAX)=''
			,@AVG_ROW_SIZE_BYTES BIGINT /* Average size of a record in a table*/
			,@TARGET_FILE_SIZE_BYTES BIGINT = 100000000 /* The size of the output file in MB compressed. Ideally not larger than 100 MB*/
			---,@BATCH_SIZE INT /*Rough size of batch = @TARGET_FILE_SIZE_BYTES/@AVG_ROW_SIZE_BYTES*/
			,@ATCH_NO VARCHAR(100)=NEWID() /*Unique hash used to perform an update on a batch of records*/
			,@BATCH_COUNT INT /* Number of records in the batch. Should not exceed 5000 due to ADF ForEach loop limitation*/

	IF @GROUP_BY_DAY_OR_HOUR NOT in ('DAY', 'HOUR')
	BEGIN
		RAISERROR ('@GROUP_BY_DAY_OR_HOUR must be one of DAY or HOUR', 16,1)
		RETURN
	END

	IF @MAX_ID <= @MIN_ID
	BEGIN
		RAISERROR ('@MIN_ID should be smaller than @MAX_ID', 16,1)
		RETURN
	END

	/*If @CUSTOM_QUERY provided, it must contain @FromId and @ToId */
	SELECT CHARINDEX('@FromId',@CUSTOM_QUERY) charindex_fromId, CHARINDEX('@ToId',@CUSTOM_QUERY) charindex_toId

	IF (@CUSTOM_QUERY IS NOT NULL AND @CUSTOM_QUERY !='')
	BEGIN
		PRINT('@CUSTOM_QUERY parameter provided')
		IF (CHARINDEX('@FromId',@CUSTOM_QUERY)=0 OR CHARINDEX('@ToId',@CUSTOM_QUERY)=0)
		BEGIN
			RAISERROR ('@CUSTOM_QUERY must contain @FromID and @ToID', 16,1)
			RETURN
		END
	END


	SELECT @ATCH_NO as Batch_No

	IF @MIN_ID IS NULL
	BEGIN
		SET @SQL1 = N' SELECT @MIN_ID=MIN(ID) FROM ' + @DATABASE_NAME + '.' + @SCHEMA_NAME + '.' + @TABLE_NAME
		PRINT @SQL1

		EXEC sp_executesql @SQL1,
		  N'@MIN_ID INT OUTPUT',
		  @MIN_ID OUTPUT;
	END

	IF @MAX_ID IS NULL
	BEGIN
		SET @SQL1 = N' SELECT @MAX_ID=MAX(ID) FROM ' + @DATABASE_NAME + '.' + @SCHEMA_NAME + '.' + @TABLE_NAME
		PRINT @SQL1

		EXEC sp_executesql @SQL1,
		  N'@MAX_ID INT OUTPUT',
		  @MAX_ID OUTPUT;
	END

	/*Calculate a rough raw size in bytes based on top 1000 records*/
	SET @SQL2= '
	;WITH Bytes AS (
	SELECT TOP 1000
		Bytes = datalength((select x.* from (values(null))data(bar) for xml auto,  BINARY BASE64))
	from ' + @DATABASE_NAME + '.' + @SCHEMA_NAME + '.' + @TABLE_NAME + ' x
	)
	SELECT @AVG_ROW_SIZE_BYTES=AVG(Bytes) from Bytes;'
		
	EXEC sp_executesql @SQL2,
	  N'@AVG_ROW_SIZE_BYTES BIGINT OUTPUT',
	  @AVG_ROW_SIZE_BYTES OUTPUT;


	SELECT @MIN_ID From_Id, @MAX_ID To_Id, @AVG_ROW_SIZE_BYTES Avg_Row_size_Bytes, @TARGET_FILE_SIZE_BYTES Target_file_size_Bytes, (@TARGET_FILE_SIZE_BYTES/@AVG_ROW_SIZE_BYTES) as Batch_Size

	IF @GROUP_BY_DAY_OR_HOUR='DAY'
	BEGIN
		SET @SQL3 = N'
		INSERT INTO [Batch].[Backfill]
				([BATCHNO]
				,[DatabaseName]
				,[SchemaName]
				,[TableName]
				,[FromId]
				,[ToId]
				,[TransactionDate]
				,[TransactionHour]
				,ProcessedFlag
				,RecordCount
				)

		SELECT 
				@ATCH_NO
				,@DATABASE_NAME 
				,@SCHEMA_NAME 
				,@TABLE_NAME
				,MIN('+ @TABLE_ID_COLUMN_NAME +') From_ID 
				,MAX('+@TABLE_ID_COLUMN_NAME +') To_ID 
				,CONVERT(VARCHAR(10),'+@TABLE_DATE_COLUMN_NAME+',121) As TransactionDate
				,''000000'' as TransactionHour
				,0 as ProcessedFlag
				,COUNT(*) as RecordCount
		FROM
			 ' + @DATABASE_NAME + '.' + @SCHEMA_NAME + '.' + @TABLE_NAME + ' 
		WHERE
			' + @TABLE_ID_COLUMN_NAME + ' >= @MIN_ID
			AND ' + @TABLE_ID_COLUMN_NAME +' <= @MAX_ID 
		GROUP BY
			CONVERT(VARCHAR(10),'+@TABLE_DATE_COLUMN_NAME+',121)
		ORDER BY 
			CONVERT(VARCHAR(10),'+@TABLE_DATE_COLUMN_NAME+',121) DESC
		;'
	END

	IF @GROUP_BY_DAY_OR_HOUR='HOUR'
	BEGIN
		SET @SQL3 = N'
		INSERT INTO [Batch].[Backfill]
				([BATCHNO]
				,[DatabaseName]
				,[SchemaName]
				,[TableName]
				,[FromId]
				,[ToId]
				,[TransactionDate]
				,[TransactionHour]
				,ProcessedFlag
				,RecordCount
				)

		SELECT 
				@ATCH_NO
				,@DATABASE_NAME 
				,@SCHEMA_NAME 
				,@TABLE_NAME
				,MIN('+ @TABLE_ID_COLUMN_NAME +') From_ID 
				,MAX('+@TABLE_ID_COLUMN_NAME +') To_ID 
				,CONVERT(VARCHAR(10),'+@TABLE_DATE_COLUMN_NAME+',121) As TransactionDate
				,CONVERT(VARCHAR(02),'+@TABLE_DATE_COLUMN_NAME+',108) + ''0000'' As TransactionTime
				,0 as ProcessedFlag
				,COUNT(*) as RecordCount
		FROM
			 ' + @DATABASE_NAME + '.' + @SCHEMA_NAME + '.' + @TABLE_NAME + ' 
		WHERE
			' + @TABLE_ID_COLUMN_NAME + ' >= @MIN_ID
			AND ' + @TABLE_ID_COLUMN_NAME +' <= @MAX_ID 
		GROUP BY
			CONVERT(VARCHAR(10),'+@TABLE_DATE_COLUMN_NAME+',121), CONVERT(VARCHAR(02),'+@TABLE_DATE_COLUMN_NAME+',108)
		ORDER BY 
			CONVERT(VARCHAR(10),'+@TABLE_DATE_COLUMN_NAME+',121), CONVERT(VARCHAR(02),'+@TABLE_DATE_COLUMN_NAME+',108) DESC
		;'
	END

	PRINT @SQL3
	EXEC sp_executesql @SQL3,
	N'@ATCH_NO VARCHAR(100), @TABLE_ID_COLUMN_NAME VARCHAR(20), @TABLE_DATE_COLUMN_NAME VARCHAR(20), @DATABASE_NAME SYSNAME, @SCHEMA_NAME SYSNAME, @TABLE_NAME SYSNAME, @MIN_ID INT, @MAX_ID INT ',
	 @ATCH_NO=@ATCH_NO
	,@TABLE_ID_COLUMN_NAME=@TABLE_ID_COLUMN_NAME
	,@TABLE_DATE_COLUMN_NAME=@TABLE_DATE_COLUMN_NAME
	,@DATABASE_NAME=@DATABASE_NAME
	,@SCHEMA_NAME=@SCHEMA_NAME
	,@TABLE_NAME=@TABLE_NAME
	,@MIN_ID=@MIN_ID
	,@MAX_ID=@MAX_ID ;

	SET @BATCH_COUNT=@@ROWCOUNT 
	SELECT @BATCH_COUNT as BATCH_COUNT

	/* For batches > 5000, need to run the ADF pipeline multiple times.*/
	--IF @BATCH_COUNT >=5000 
	--BEGIN
	--	UPDATE [Batch].[Backfill] SET ProcessedFlag=-2 WHERE BatchNo=@ATCH_NO;
	--	RAISERROR ('MAX records in a batch should be <5000 due to ADF ForEach loop limitation. Please use @MIN_ID to reduce the number of records in a batch', 16,1)
	--	RETURN
	--END

	/*
	-- =========================================================
	-- Start updating the remaining columns based on the BatchNo
	-- =========================================================
	*/
	IF (@CUSTOM_QUERY IS NULL or @CUSTOM_QUERY='')
	BEGIN
		UPDATE [Batch].[Backfill]
		SET
			TableNameFQN =CONCAT_WS('.', DatabaseName, SchemaName, TableName)
			,Query=	N'SELECT * FROM ' + CONCAT_WS('.', DatabaseName, SchemaName, TableName) + ' WHERE '+ @TABLE_ID_COLUMN_NAME + ' >=' + FromId + ' AND ' + @TABLE_ID_COLUMN_NAME  + '<= ' + ToId + ' ORDER BY '+ @TABLE_ID_COLUMN_NAME +';'
			,DirectoryName= REPLACE(CONCAT_WS('/','raw', DatabaseName,SchemaName + '.' + TableName,'backfill', CONVERT(VARCHAR(4),TransactionDate,121),CONVERT(VARCHAR(7),TransactionDate,121),CONVERT(VARCHAR(10),TransactionDate,121)),'-','_')
			,[FileName]= CONCAT(SchemaName,'.',TableName,'_', CONVERT(VARCHAR(08),TransactionDate,112),'_',TransactionHour ,'_',Id,'.','parquet.snappy')
			,FileSizeKB=(RecordCount * (@AVG_ROW_SIZE_BYTES /1024.00))
		WHERE
			BatchNo=@ATCH_NO
			;
	END
	ELSE
	BEGIN
		UPDATE [Batch].[Backfill]
		SET
			TableNameFQN =CONCAT_WS('.', DatabaseName, SchemaName, TableName)
			--,Query=	@CUSTOM_QUERY + ' ' + fromId + ', ' + ToId + ';'
			,Query=	REPLACE( REPLACE(@CUSTOM_QUERY,'@FromId',fromId),'@ToId', ToId)
			,DirectoryName= REPLACE(CONCAT_WS('/','raw', DatabaseName,SchemaName + '.' + TableName,'backfill', CONVERT(VARCHAR(4),TransactionDate,121),CONVERT(VARCHAR(7),TransactionDate,121),CONVERT(VARCHAR(10),TransactionDate,121)),'-','_')
			,[FileName]= CONCAT(SchemaName,'.',TableName,'_', CONVERT(VARCHAR(08),TransactionDate,112),'_',TransactionHour ,'_',Id,'.','parquet.snappy')
			,FileSizeKB=(RecordCount * (@AVG_ROW_SIZE_BYTES /1024.00))
		WHERE
			BatchNo=@ATCH_NO
			;
	END

END
GO

