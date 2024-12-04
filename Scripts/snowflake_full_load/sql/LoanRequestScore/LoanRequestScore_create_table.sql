CREATE OR REPLACE TABLE STAGING.DBO_LoanRequestScore(
	ID NUMBER(38,0) NOT NULL,
	LoanRequestId NUMBER(38,0) NOT NULL,
	ScoreType NUMBER(38,0) NOT NULL,
	ScoreValue NUMBER(9,4) NOT NULL,
	IsActive NUMBER(38,0) NOT NULL,
	CreateDate TIMESTAMP_NTZ(9) NOT NULL,
	RSCreditCategory VARCHAR(100) NULL,
    /* MetaData Columns*/
	Source_System varchar(100) null,
	Snapshot_Date TIMESTAMP_NTZ(9) null,	
	hash_key varchar(200) NOT NULL,
	PRIMARY KEY (ID)
);