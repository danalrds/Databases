CREATE PROC RunTables @testname VARCHAR(30),@description VARCHAR(40)
AS
DECLARE @date DATETIME2, @datefinal DATETIME2, @firstdate DATETIME2;
DECLARE @testid INT, @current INT=1,@viewid INT, @viewname  VARCHAR(30),@testrunid INT,@position INT=1,@tableid INT, @tablename VARCHAR(30), @procname VARCHAR(30),
        @nrrows INT,@command varchar(50);
	BEGIN	
		 SET @firstdate=SYSDATETIME();
	     INSERT INTO TestRuns(Description,StartAt) VALUES (@description,@firstdate);	
		 set @testrunid=IDENT_CURRENT(N'TestRuns');
		 SET @testid=(SELECT TestID FROM Tests WHERE name=@testname);
		 --insert
		 WHILE EXISTS(SELECT  TableId FROM TestTables WHERE TestID=@testid AND Position=@position)
			BEGIN
			    select @nrrows=NoOfRows,@tableid=TableID  from TestTables where TestID=@testid and Position=@position
				SET @tablename=(SELECT Name FROM Tables WHERE TableID=@tableid);
				SET @position=@position+1;
				SET @date=SYSDATETIME();
				SET @procname='uspInsert'+@tablename;
				SET @command=@procname +' ' + convert(varchar(20),@nrrows);
				EXEC (@command);
				SET @datefinal=SYSDATETIME();
				INSERT INTO TestRunTables(TestRunID,TableID,StartAt,EndAt) VALUES (@testrunid,@tableid,@date,@datefinal);									
			END	
		 --view
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
		 --delete	
		 SET @position=@position-1;
		 WHILE EXISTS(SELECT  TableId FROM TestTables WHERE TestID=@testid AND Position=@position)
			BEGIN
			    select @nrrows=NoOfRows,@tableid=TableID  from TestTables where TestID=@testid and Position=@position
				SET @tablename=(SELECT Name FROM Tables WHERE TableID=@tableid);
				SET @position=@position-1;				
				SET @procname='uspDelete'+@tablename;
				SET @command=@procname +' ' + convert(varchar(20),@nrrows);
				EXEC (@command);												
			END	  		 		 
	END
EXEC cleanAll;
select * from TestViews
EXEC RunTables 'Test1', 'firsttest'
EXEC RunTables 'Test2', '2ndtest'
exec RunTables 'Test3', 'THIrdLAST2'
SELECT * FROM TestRuns;
SELECT * FROM TestRunTables;
SELECT * FROM TestRunViews;
SELECT * FROM Pilot;
SELECT * FROM TestViews;
EXEC uspDeletePilot 10000;
EXEC uspInsertEngineer 100;
EXEC uspDeleteEngineer 100;
SELECT * FROM Engineer;
DELETE FROM Tables WHERE TableID=4;
SELECT * FROM Tables;
SELECT * FROM Pilot;
exec uspInsertPilot 10000
SELECT * FROM Plane WHERE id=4;
EXEC sp_helpindex Plane;