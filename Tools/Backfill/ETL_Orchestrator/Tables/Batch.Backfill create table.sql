USE [ETL_Orchestrator]
GO

drop table Batch.Backfill;

CREATE TABLE Batch.Backfill(
	Id int IDENTITY(1,1) NOT NULL,
	BatchNo varchar (100) NOT NULL, /*Index on this column?*/
	DatabaseName varchar(100) NOT NULL,
	SchemaName varchar(100) NOT NULL,
	TableName varchar(100) NOT NULL,
	TableNameFQN varchar(255) NULL, /*Index on this column ?*/
	FromId VARCHAR(20) NOT NULL,
	ToId VARCHAR(20) NOT NULL,
	Query VARCHAR(8000) NULL,
	DirectoryName varchar(255) NULL,
	[FileName] varchar(255) NULL,
	TransactionDate DATE,
	TransactionHour VARCHAR(6),
	RecordCount INT,
	FileSizeKB VARCHAR(20),
	CreateDate DateTime not null CONSTRAINT DF_Backfill_CreateDate  DEFAULT GETDATE()  ,
	ProcessedFlag INT not null,
	ProcessedDate DateTime null,
	CONSTRAINT PK_Clus_Backfill_Id PRIMARY KEY CLUSTERED (Id)

) ON [PRIMARY]
GO


CREATE INDEX IX_Backfill_TableNameFQN_ProcessedFlag ON Batch.Backfill(TableNameFQN, ProcessedFlag);
GO
sp_helpIndex 'Batch.Backfill'
Go

SELECT * FROM Batch.Backfill;
