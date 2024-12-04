CREATE OR REPLACE TABLE STAGING.DBO_BorrowerLoanRequestStates(
	PK_BorrowerLoanRequestStates NUMBER(38,0) NULL, 
	StatusName VARCHAR(50) NULL,
	Action NUMBER(38,0) NOT NULL,
	IsFirstContact NUMBER(38,0) NULL,
	/* MetaData Columns*/
	Source_System VARCHAR(100) null,
	Snapshot_Date TIMESTAMP_NTZ(9) null,
	hash_key VARCHAR(200) NOT NULL,
    PRIMARY KEY (PK_BorrowerLoanRequestStates)
);