CREATE OR REPLACE TABLE STAGING.DBO_ApplicationStatus(
    PK_ApplicationStatus NUMBER(38,0) NOT NULL,
	FK_LoanRequest NUMBER(38,0) NOT NULL,
	ActivityTime TIMESTAMP_NTZ(9) NOT NULL,
	Status NUMBER(38,0) NOT NULL,
	FK_AdminUser NUMBER(38,0) NULL,
	isCreditUpdate NUMBER(38,0) NULL,
	UpdateType NUMBER(38,0) NULL,
	APR NUMBER(38,0) NULL,
	/* MetaData Columns*/
	Source_System varchar(100) null,
	Snapshot_Date TIMESTAMP_NTZ(9) null,	
	hash_key varchar(200) NOT NULL,
	PRIMARY KEY (PK_ApplicationStatus)
);