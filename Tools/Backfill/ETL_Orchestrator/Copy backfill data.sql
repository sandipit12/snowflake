-- Copy backfill data
USE [ETL_Orchestrator]
GO

DECLARE @QT VARCHAR(5)=CHAR(39)

PRINT @QT
SELECT 

	'INSERT INTO [Batch].[Backfill]
           ([BatchNo]
           ,[DatabaseName]
           ,[SchemaName]
           ,[TableName]
           ,[TableNameFQN]
           ,[FromId]
           ,[ToId]
           ,[Query]
           ,[DirectoryName]
           ,[FileName]
           ,[TransactionDate]
           ,[TransactionHour]
           ,[RecordCount]
           ,[FileSizeKB]
		   ,[ProcessedFlag]
		   ) VALUES ('

	+ @QT + CONVERT(VARCHAR(200), BatchNo,2) + @QT
	+ ',' + @QT + DatabaseName + @QT
	+ ',' + @QT + SchemaName + @QT
	+ ',' + @QT + TableName + @QT
	+ ',' + @QT + TableNameFQN + @QT
	+ ',' + CONVERT(VARCHAR(20), FromId)
	+ ',' + CONVERT(VARCHAR(20),ToId )
	+ ',' + @QT + Query + @QT
	+ ',' + @QT + DirectoryName + @QT
	+ ',' + @QT + FileName + @QT
	+ ',' + @QT + CONVERT(VARCHAR(10), TransactionDate) + @QT
	+ ',' + @QT + TransactionHour + @QT
	+ ',' + CONVERT(VARCHAR(20),RecordCount)
	+ ',' + @QT + FileSizeKB + @QT
	+ ',' + CONVERT(VARCHAR(2), ProcessedFlag)
	+ ');'
--select *
FROM 
	[Batch].[Backfill]
where  TableNameFQN ='Venus_Live.dbo.FinancialTransactions'  
ORDER BY
	ID
;

go
