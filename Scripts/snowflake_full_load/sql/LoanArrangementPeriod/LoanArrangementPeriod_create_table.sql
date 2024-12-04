CREATE OR REPLACE TABLE STAGING.DBO_LoanArrangementPeriod (
Id int NOT NULL,
LoanId int NOT NULL,
PeriodType tinyint NOT NULL,
PeriodStartDate TIMESTAMP_NTZ(9) NOT NULL,
PeriodEndDate TIMESTAMP_NTZ(9) NULL,
CreationDate TIMESTAMP_NTZ(9) NOT NULL,
/* MetaData Columns*/
Source_System varchar(100) null,
Snapshot_Date TIMESTAMP_NTZ(9) null,	
hash_key varchar(200) NOT NULL,
PRIMARY KEY (ID)
);