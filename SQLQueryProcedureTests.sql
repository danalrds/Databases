CREATE PROC uspInsertPilot @nr INT 
AS
DECLARE @crt INT=1, @name VARCHAR(30),@number INT;
	BEGIN	   
		IF EXISTS( SELECT 1 FROM Pilot)
		  BEGIN
			SET @number=(SELECT MAX(id) FROM Pilot);
			PRINT @number;
		  END
		  ELSE
			SET @number=0;
	    DBCC CHECKIDENT ('dbo.Pilot', RESEED, @number);  		  
		WHILE (@crt<=@nr)
			BEGIN
				SET @name='Pilot'+CAST(@number+@crt AS VARCHAR(10));
				INSERT INTO Pilot(name,salary,degree,nationality) VALUES(@name,2000,3,'Spanish');
				SET @crt=@crt+1;
			END		
	END

go

CREATE PROC uspInsertEngineer @nr INT 
AS
DECLARE @crt INT=1, @name VARCHAR(30),@tid INT,@number INT;
	BEGIN	    
	    SET @number=(SELECT MAX(id) FROM Engineer);
		IF EXISTS( SELECT 1 FROM Engineer)
		  BEGIN
			SET @number=(SELECT MAX(id) FROM Engineer);
			PRINT @number;
		  END
		  ELSE
			SET @number=0;
	    DBCC CHECKIDENT ('dbo.Engineer', RESEED, @number); 
	    SET @tid=(SELECT TOP 1 id FROM TechTeam ORDER BY id);
		WHILE (@crt<=@nr)
			BEGIN
				SET @name='Engineer'+CAST(@number+@crt AS VARCHAR(10));				
				INSERT INTO Engineer(name,tid) VALUES(@name,@tid);
				SET @crt=@crt+1;
			END		
	END

go

CREATE PROC uspInsertPilotPlane @nr INT 
AS
DECLARE @crt INT=1,@pilotId INT,@planeId INT;
	BEGIN	    
	    SET @planeId=(SELECT TOP 1 id FROM Plane ORDER BY id);
		WHILE (@crt<=@nr)
			BEGIN	
			    SET @pilotId=(SELECT TOP 1 t.id FROM (SELECT * FROM Pilot ORDER BY id DESC offset @crt-1 rows) as t);						
				INSERT INTO PilotPlane(pilid,plid) VALUES(@pilotId,@planeId);
				SET @crt=@crt+1;
			END		
	END

go

CREATE PROC uspDeletePilot @nr INT 
AS
DECLARE @crt INT=1,@last INT;
	BEGIN      
		WHILE (@crt<=@nr)
			BEGIN
				SET @last=(SELECT MAX(id) FROM Pilot);
				DELETE FROM Pilot WHERE id=@last;
				SET @crt=@crt+1;
			END	
	END
go

CREATE PROC uspDeleteEngineer @nr INT 
AS
DECLARE @crt INT=1,@last INT;
	BEGIN	 	    
		WHILE (@crt<=@nr)
			BEGIN
				SET @last=(SELECT MAX(id) FROM Engineer);
				DELETE FROM Engineer WHERE id=@last;
				SET @crt=@crt+1;
			END		
	END
go

CREATE PROC uspDeletePilotPlane @nr INT 
AS
DECLARE @crt INT=1,@last INT,@planeId INT;
	BEGIN	 	    
		SET @planeId=(SELECT TOP 1 id FROM Plane ORDER BY id)
		WHILE (@crt<=@nr)
			BEGIN
				SET @last=(SELECT MAX(pilid) FROM PilotPlane);
				DELETE FROM PilotPlane WHERE pilid=@last AND plid=@planeId;
				SET @crt=@crt+1;
			END		
	END


CREATE VIEW viewPilot
AS
	SELECT name, nationality FROM Pilot
	WHERE salary >1000;
GO

CREATE VIEW viewEngineerTechTeam
AS
	SELECT e.[name],t.airpId FROM Engineer e INNER JOIN TechTeam t
	ON  t.id=e.tid AND t.size>100;
GO

CREATE VIEW viewPilotPlaneGroupBy
AS
	SELECT  plane.[type] FROM PilotPlane pp
	INNER JOIN Plane plane ON pp.plid=plane.id
	GROUP BY plane.[type];
	
	SELECT * FROM PilotPlane;
	INSERT INTO PilotPlane(pilid,plid) VALUES (1,1),(1,2), (1,3),(2,5), (2,4),(2,3);

SELECT * FROM Views;
UPDATE Views
  SET Name='viewPilotPlaneGroupBy' WHERE ViewID=3;

exec uspInsertPilotPlane 10
exec uspDeletePilotPlane 10
SELECT * FROM TestTables;
SELECT * FROM TestViews;
UPDATE TestTables
SET TableID=1 WHERE TestID=3 ;
SELECT * FROM Pilot;
INSERT INTO TestTables(TestID,TableID,NoOfRows,Position) VALUES (3, 3,10000,2);