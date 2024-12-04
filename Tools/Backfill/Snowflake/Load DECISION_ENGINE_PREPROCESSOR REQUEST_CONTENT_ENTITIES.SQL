/*
Load DECISION_ENGINE_PREPROCESSOR REQUEST_CONTENT_ENTITIES

*/
USE ROLE ETL_ROLE;
USE DATABASE DECISION_ENGINE_PREPROCESSOR;
USE WAREHOUSE DATA_TEAM_WH;

/*1. Create TEMP staging table
Note the Staging table has _TEMP in the name!
*/
create or replace transient TABLE STAGING.DBO_REQUEST_CONTENT_ENTITIES_TEMP (
	ID NUMBER(38,0) NOT NULL,
	CORRELATION_ID VARCHAR(450),
	CREATE_DATE TIMESTAMP_NTZ(9) NOT NULL,
	REQUEST_METADATA VARCHAR(16777216),
	RESPONSE_METADATA VARCHAR(16777216),
	REQUEST_BODY VARCHAR(16777216),
	RESPONSE VARCHAR(16777216),
	FILE_NAME VARCHAR(200) NOT NULL
);

/*Scale up the warehouse. Done in another window*/
--ALTER WAREHOUSE "DATA_TEAM_WH" SET WAREHOUSE_SIZE = 'LARGE' ;

/*Copy into staging transient table
Note the path includes /backfill/ directory
*/

COPY INTO STAGING.DBO_REQUEST_CONTENT_ENTITIES_TEMP
    FROM (
      SELECT
        $1:Id,
        $1:CorrelationId,            
        $1:CreateDate,
        $1:RequestMetaData,
        $1:ResponseMetaData,
        $1:RequestBodyJson,
        $1:ResponseBodyJson,
        METADATA$FILENAME
            
      FROM @STAGING.STAGE_DECISION_ENGINE_PREPROCESSOR_PARQUET/dbo.RequestContentEntities/backfill/
    ) PATTERN = ".*.parquet.snappy"
    FILE_FORMAT = (
        FORMAT_NAME = STAGING.PARQUET_SNAPPY_SPACE_TRIM
    ) ON_ERROR = 'SKIP_FILE';



/* Merge data into RAW
Note the Staging table has _TEMP in the name!
ALSO the NOT EXISTS clause
*/

 INSERT INTO RAW.DBO_REQUEST_CONTENT_ENTITIES
      (Id,
       Correlation_ID,
       Create_Date,
       Request_MetaData,
       Response_MetaData,
       Request_Body,
       Response,
       File_Name,
       Audit_Added_Date,
       Audit_Updated_Date)   
  SELECT Id,
       Correlation_ID,
       Create_Date,
       Request_MetaData,
       Response_MetaData,
       IFNULL(TRY_PARSE_JSON(LOWER(Request_Body)),TO_VARIANT(Request_Body)),
       IFNULL(TRY_PARSE_JSON(LOWER(Response)),TO_VARIANT(Response)),
       File_Name,
       SYSDATE(),
       SYSDATE()
 FROM STAGING.DBO_REQUEST_CONTENT_ENTITIES_TEMP 
 WHERE Id NOT IN (SELECT ID FROM RAW.DBO_REQUEST_CONTENT_ENTITIES)
;

