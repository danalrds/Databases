CREATE PROC cleanAll
AS
	BEGIN		
		DELETE FROM TestRunViews;
		DELETE FROM TestRunTables;
		DELETE FROM TestRuns;		
	END