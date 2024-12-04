CREATE OR REPLACE TABLE  STAGING.DBO_ENUMMAPREADONLY(
	ID varchar(300) NOT NULL, /* THis is a madeup filed to aid merge joins*/
	EnumTypeFullyQualifiedName varchar(200) NOT NULL,
	EnumItemNumber int NOT NULL,
	EnumItemKey varchar(100) NULL,
	EnumItemDescription varchar (1000) NULL,
	LastModifiedDate datetime NULL,
	/* MetaData Columns*/
	Source_System varchar(100) null,
	Snapshot_Date datetime null,	
	hash_key varchar(200) NOT NULL,
    PRIMARY KEY (ID)
);
