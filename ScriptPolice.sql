CREATE TABLE Sections(sectionid INT PRIMARY KEY IDENTITY(1,1), name VARCHAR(30), adress VARCHAR(30));
CREATE TABLE Ranks(rid INT PRIMARY KEY IDENTITY(1,1), name VARCHAR(30));
CREATE TABLE Sectors(sectorid INT PRIMARY KEY IDENTITY(1,1), name VARCHAR(30));
CREATE TABLE Policemen(pid INT PRIMARY KEY IDENTITY(1,1), name VARCHAR(30), sectionid INT FOREIGN KEY REFERENCES Sections(sectionid), rankid INT FOREIGN KEY REFERENCES Ranks(rid));
CREATE TABLE Patrols(pid INT FOREIGN KEY REFERENCES Policemen(pid), sectorid INT FOREIGN KEY REFERENCES Sectors(sectorid), starttime DATETIME2, endtime DATETIME2, PRIMARY KEY(pid,sectorid));

INSERT INTO Ranks(name) VALUES ('Rank1'), ('Rank2'), ('Rank3');
INSERT INTO Sections(name) VALUES ('LosAngelesSection'), ('SanFranciscoSection'), ('AtalantaSection');
INSERT INTO Sectors(name) VALUES ('North'), ('South'), ('East'), ('West');
INSERT INTO Policemen(name, sectionid, rankid) VALUES ('Mark Miller', 1, 2),
													  ('John Smith', 2, 1),
													  ('Miguel Lopez', 3,3);
INSERT INTO Policemen(name, sectionid, rankid) VALUES ('Hing Yuan', 1, 2);

ALTER TABLE Patrols
ADD CONSTRAINT patrol_duration
CHECK (DATEDIFF(HOUR,  starttime, endtime)=8);
		
--a)
CREATE PROC insertPatrol @polname VARCHAR(30), @sectorname VARCHAR(30), @starttime DATETIME2, @endtime DATETIME2	
AS
DECLARE @policemanid INT, @sectorid INT;
	BEGIN
		SET @policemanid=(SELECT p.pid FROM Policemen p WHERE p.name=@polname);
		SET @sectorid=(SELECT sectorid FROM Sectors WHERE name=@sectorname);
		IF EXISTS(SELECT 1 FROM Patrols WHERE pid=@policemanid AND sectorid=@sectorid)
			BEGIN
				UPDATE Patrols
				SET starttime=@starttime, endtime=@endtime
				WHERE pid=@policemanid AND sectorid=@sectorid;
			END
		ELSE
			BEGIN
				INSERT INTO Patrols(pid,sectorid,starttime,endtime) VALUES (@policemanid,@sectorid,@starttime, @endtime);
			END
	END		
	
EXEC insertPatrol 'Hing Yuan', 'East', '2018-01-30 12:45:37.333', '2018-01-30 20:45:37.333'  

SELECT * FROM Patrols;	
DECLARE @date1 DATETIME2, @date2 DATETIME2;
SET @date1='2018-01-30 12:45:37.333';
SET @date2='2018-01-30 20:45:37.333';
PRINT (DATEDIFF(HOUR,  @date1, @date2)); 

select DATEDIFF(MILLISECOND, cast('20010101 23:45:21.12347' as datetime2), 
                             cast('20010105 12:35:15.56786' as datetime2))
--b)
CREATE VIEW  totalSorted
AS
	SELECT p.name, helper.suma  FROM Policemen p INNER JOIN 
		(SELECT p.pid,SUM(8) FROM Patrols patrol 
		INNER JOIN Policemen p ON patrol.pid=p.pid 
		INNER JOIN Sections s ON p.sectionid=s.sectionid
		GROUP BY p.pid) as helper(pid,suma) 
	ON p.pid=helper.pid INNER JOIN Sections s ON p.sectionid=s.sectionid
	ORDER BY s.name,p.name
	OFFSET 0 ROWS;		
			
SELECT * FROM totalSorted;  

--c)
CREATE FUNCTION manyTimes()
RETURNS TABLE
AS
	RETURN SELECT p.name FROM Policemen p
		INNER JOIN
		(SELECT p.pid, Count(*) FROM Policemen p 
				INNER JOIN Patrols patrol ON p.pid=patrol.pid
				GROUP BY p.pid) as helper(pid,counter)
		ON helper.pid=p.pid
		WHERE helper.counter>1;

SELECT * FROM manyTimes();
