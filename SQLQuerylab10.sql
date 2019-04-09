--DECLARE @date DATETIME2
SET @date=SYSDATETIME();
PRINT @date

EXEC uspDeleteEngineer 1
SELECT * FROM Engineer
SELECT * FROM TechTeam

SELECT * FROM viewEngineerTechTeam;

INSERT INTO Tests(name) VALUES ('Test1'), ('Test2'), ('Test3');
SELECT * FROM Tests;

SELECT * FROM Tables;
INSERT INTO Tables(name) VALUES ('Pilot'),('Engineer'), ('PilotPlane'),('TechTeam');

SELECT * FROM Views;
INSERT INTO Views(name) VALUES ('viewPilot'),('viewEngineerTechTeam'), ('view3');

SELECT * FROM TestViews;
INSERT INTO TestViews(TestID,ViewID) VALUES ()

DBCC CHECKIDENT (Tables, reseed, 1);


DBCC CHECKIDENT ('dbo.Tables', RESEED, 0);     


INSERT INTO TestViews(TestID,ViewID) VALUES (1,1), (2,2),(3,3);
SELECT * FROM TestViews;

INSERT INTO TestTables(TestID,TableID,NoOfRows,Position) VALUES (1,1,10000,1), (1,2,10000,2),(2,1,50000,1), (2,3,50000,2),(3,2,100000,1),(3,3,100000,2);
SELECT * FROM TestTables;
SELECT * FROM Pilot;
exec uspDeletePilot 4;
exec uspInsertPilot 6;