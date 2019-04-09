CREATE PROC Run @testname VARCHAR(30),@description VARCHAR(40)
AS
DECLARE @date DATETIME2, @datefinal DATETIME2, @firstdate DATETIME2;
DECLARE @testid INT, @current INT=1,@viewid INT, @viewname  VARCHAR(30),@testrunid INT;
	BEGIN	
		 SET @firstdate=SYSDATETIME();
	     INSERT INTO TestRuns(Description,StartAt) VALUES (@description,@firstdate);	
		 set @testrunid=IDENT_CURRENT(N'TestRuns');
		 SET @testid=(SELECT TestID FROM Tests WHERE name=@testname);
		 WHILE EXISTS(SELECT  ViewId FROM TestViews WHERE TestID=@testid ORDER BY ViewID ASC offset @current-1 rows)
			BEGIN
			    SET @viewid=(SELECT TOP 1 t.ViewId FROM (SELECT  ViewId FROM TestViews WHERE TestID=@testid ORDER BY ViewID ASC offset @current-1 rows) as t);
				SET @current=@current+1;
				SET @viewname=(SELECT Name FROM Views WHERE ViewID=@viewid);
				SET @date=SYSDATETIME();
				exec ('SELECT * FROM '+@viewname);
				SET @datefinal=SYSDATETIME();
				INSERT INTO TestRunViews(TestRunID,ViewID,StartAt,EndAt) VALUES (@testrunid,@viewid,@date,@datefinal);

			END	
		 UPDATE TestRuns
		 SET EndAt=SYSDATETIME() WHERE TestRunID=@testrunid;		 		 
	END


SELECT * FROM Pilot;
SELECT * FROM TestRuns;
SELECT * FROM TestRunViews;
EXEC Run 'Test1', 'firsttest';
EXEC cleanAll;
EXEC uspInsertPilot 10000;
DELETE FROM TestViews WHERE TestId=1 AND ViewID=3;
INSERT INTO TestViews(TestID,ViewID) VALUES (1,2), (1,3);
SELECT * FROM TestViews;
DELETE FROM TestTables;
INSERT INTO TestTables(TestID,TableID,NoOfRows,Position) VALUES (1,1,10000,1), (2,1,50000,1);