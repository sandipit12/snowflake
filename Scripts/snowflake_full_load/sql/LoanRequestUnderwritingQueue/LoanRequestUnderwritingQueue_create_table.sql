 CREATE OR REPLACE TABLE STAGING.DBO_LoanRequestUnderwritingQueue(
	Id NUMBER(38,0) NOT NULL,
	LoanRequestId NUMBER(38,0) NOT NULL,
	Queue NUMBER(38,0) NOT NULL,
	CreateDate TIMESTAMP_NTZ(9) NULL,
	CreatedByProcess NUMBER(38,0) NULL,
	CreatedByAdminUserId NUMBER(38,0) NULL,
	ModifiedByProcess NUMBER(38,0) NULL,
	ModifiedByAdminUserId NUMBER(38,0) NULL,
	ExitDate TIMESTAMP_NTZ(9) NULL,
  	/* MetaData Columns*/
	Source_System varchar(100) null,
	Snapshot_Date TIMESTAMP_NTZ(9) null,	
	hash_key varchar(200) NOT NULL,
  PRIMARY KEY (Id) 
);