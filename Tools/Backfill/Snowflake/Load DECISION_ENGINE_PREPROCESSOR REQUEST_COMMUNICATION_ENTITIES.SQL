/*
Load DECISION_ENGINE_PREPROCESSOR REQUEST_COMMUNICATION_ENTITIES

*/
USE ROLE ETL_ROLE;
USE DATABASE DECISION_ENGINE_PREPROCESSOR;
USE WAREHOUSE DATA_TEAM_WH;

create or replace TABLE STAGING.DBO_REQUEST_COMMUNICATION_ENTITIES_TEMP (
	ID NUMBER(38,0) NOT NULL,
	EXTERNAL_REQUEST_CONTENT_ID NUMBER(38,0),
	FABRIC_URI VARCHAR(16777216),
	PATH VARCHAR(16777216),
	REQUEST_CONTENT_ID NUMBER(38,0),
	FILE_NAME VARCHAR(200) NOT NULL
);

/*Scale up the warehouse. Done in another window*/
--ALTER WAREHOUSE "DATA_TEAM_WH" SET WAREHOUSE_SIZE = 'LARGE' ;


/*Copy into staging transient table
Note the path includes /backfill/ directory
*/

COPY INTO STAGING.DBO_REQUEST_COMMUNICATION_ENTITIES_TEMP
    FROM (
      SELECT
        $1:Id,
        $1:ExternalRequestContentId,
        $1:FabricUri,
        $1:Path,
        $1:RequestContentId,
        METADATA$FILENAME          
      FROM @STAGING.STAGE_DECISION_ENGINE_PREPROCESSOR_PARQUET/dbo.RequestCommunicationEntities/backfill/
    ) PATTERN = ".*.parquet.snappy"
    FILE_FORMAT = (
        FORMAT_NAME = STAGING.PARQUET_SNAPPY_SPACE_TRIM
    ) ON_ERROR = 'SKIP_FILE';


/* Merge data into RAW
Note the Staging table has _TEMP in the name!
ALSO the NOT EXISTS clause
*/

 INSERT INTO RAW.DBO_REQUEST_COMMUNICATION_ENTITIES
      (Id,
       External_Request_Content_ID,
       Fabric_Uri,
       Path,
       Request_Content_ID,
       File_Name,
       Audit_Added_Date,
       Audit_Updated_Date)   
  SELECT Id,
       External_Request_Content_ID,
       Fabric_Uri,
       Path,
       Request_Content_ID,
       File_Name,
       SYSDATE(),
       SYSDATE()
 FROM STAGING.DBO_REQUEST_COMMUNICATION_ENTITIES_TEMP 
 WHERE Id NOT in (SELECT ID FROM RAW.DBO_REQUEST_COMMUNICATION_ENTITIES)
;