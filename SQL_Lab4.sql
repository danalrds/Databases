
INSERT INTO Tables([Name]) values ('Pilot'), ('Engineer'),('PilotPlane');
DELETE FROM Tables;
DELETE FROM dbo.Tables;
DELETE FROM dbo.Tests;
select * from Stewardess order by id desc offset 1 rows
EXEC uspInsertPilot 3 
SELECT *FROM Pilot;

EXEC uspInsertEngineer 3 
SELECT *FROM Engineer;
DELETE FROM Engineer WHERE id>=3;

EXEC uspInsertPilotPlane 2 
SELECT *FROM PilotPlane;

EXEC uspdeletePilot 3 
SELECT *FROM Pilot;

