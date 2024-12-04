USE [DEV_ETL_Orchestrator]
GO


ALTER PROCEDURE [Batch].[Update_Backfill_Failure]
	@Id INTEGER
AS
SET NOCOUNT ON;
	DECLARE @RowCount INT

	UPDATE Batch.Backfill 
		SET ProcessedFlag =-1, /*Error*/
			ProcessedDate=GetDate()
	WHERE 
		Id = @Id
		AND ProcessedFlag =0;

	SET @RowCount=@@ROWCOUNT
	IF @RowCount <> 1
	BEGIN
		RAISERROR ('An error occured. Expected 1 record to be updated.', 16,1)
	END

GO
