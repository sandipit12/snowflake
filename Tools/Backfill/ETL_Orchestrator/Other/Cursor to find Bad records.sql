SET NOCOUNT ON;

/* Set up variables to hold the current record we're working on */
DECLARE @CurrentID INT, @RequestBody VARBINARY(MAX),  @ResponseBody VARBINARY(MAX)
		,@Temp varchar(max)
		,@TableNameFQN varchar(255) = 'DecisionEngine.dbo.RequestContentEntities'

DECLARE cursor_results CURSOR FOR
  SELECT ID, RequestBody, ResponseBody
  FROM [DecisionEngine].[dbo].[RequestContentEntities] 
  WHERE 
	(Id > 78875624 AND Id <= 78900386)
	OR (Id > 78857236 AND Id <= 78875623)
	OR (Id >79435161 AND Id <= 	79452200)
	OR (Id >79859024 AND Id <= 	79880319)
	OR (Id >79850010 AND Id <= 	79859023)
	OR (Id >80729528 AND Id <= 	80772906)
	OR (Id >80692835 AND Id <= 	80729527)
	OR (Id >80648569 AND Id <= 	80692834)
	OR (Id >80355115 AND Id <= 	80384127)
	OR (Id >80338599 AND Id <= 	80355114)
	OR (Id >80329375 AND Id <= 	80338598)
	OR (Id >80325070 AND Id <= 	80329374)
	OR (Id >80321503 AND Id <= 	80325069)
	OR (Id >80944645 AND Id <= 	80947364)
	OR (Id >81402069 AND Id <= 	81406430)
	OR (Id >81400442 AND Id <= 	81401246)

OPEN cursor_results
FETCH NEXT FROM cursor_results into @CurrentID, @RequestBody, @ResponseBody
WHILE @@FETCH_STATUS = 0
BEGIN 
	
	BEGIN TRY
		SET @Temp=CONVERT(VARCHAR(MAX), DECOMPRESS(@RequestBody)) + CONVERT(VARCHAR(MAX), DECOMPRESS(@ResponseBody)) 
	END TRY
	BEGIN CATCH
		PRINT('Found a bad record')
		INSERT INTO Batch.BadRecords(ID, TableNameFQN) VALUES (@CurrentID, @TableNameFQN)
	END CATCH

FETCH NEXT FROM cursor_results into @CurrentID, @RequestBody, @ResponseBody
END

/* Clean up our work */
CLOSE cursor_results;
DEALLOCATE cursor_results;

GO

SELECT * FROM Batch.BadRecords  ;

