CREATE TABLE TrainTypes(ttid INT PRIMARY KEY IDENTITY(1,1), description varchar(30));
CREATE TABLE Trains(tid INT PRIMARY KEY IDENTITY(1,1), tname VARCHAR(30), ttid INT FOREIGN KEY REFERENCES TrainTypes(ttid));
CREATE TABLE Stations(sid INT PRIMARY KEY IDENTITY(1,1), sname VARCHAR(30));
CREATE TABLE Routes(rid INT PRIMARY KEY  IDENTITY(1,1), rname VARCHAR(30), tid INT FOREIGN KEY REFERENCES Trains(tid));
CREATE TABLE StationsRoutes(sid INT FOREIGN KEY REFERENCES Stations(sid), rid INT FOREIGN KEY REFERENCES Routes(rid), arrival TIME, dep TIME);


ALTER TABLE Stations
ADD CONSTRAINT [CT_UniqueS] UNIQUE(sname);
---ROUTE STATION ARRIVAL DEP 

CREATE  OR ALTER PROC   addStationToRoute @rname VARCHAR(30), @stationname VARCHAR(30), @arrival TIME, @dep TIME
AS
DECLARE @rid INT= (SELECT rid FROM Routes WHERE rname=@rname),
        @sid INT=(SELECT sid FROM  Stations WHERE sname=@stationname);
	BEGIN
		IF @rid=NULL OR @sid=NULL  
		   RAISERROR('station or route ides null', 16,1);
		ELSE
			IF EXISTS(SELECT * FROM StationsRoutes WHERE rid=@rid AND sid=@sid)
				RAISERROR('station or route EXISTS', 16,1);
		ELSE
			INSERT INTO StationsRoutes(sid,rid,arrival,dep) 
			VALUES (@sid,@rid,@arrival,@dep);
	END;

INSERT INTO TrainTypes(description)
VALUES ('regio'),('interregio');

INSERT Trains(tname,ttid) VALUES ('t1', 1), ('t2',2), ('t3',2);
INSERT Routes VALUES ('r1', 4), ('r2', 5), ('r3',6);
INSERT INTO Stations VALUES ('s1'),('s2'),('s3');
INSERT StationsRoutes VALUES (1,3,'7:00','7:10');
INSERT StationsRoutes VALUES (2,3,'8:10','8:53'),
							(3,3,'9:45','9:56'),
							(1,4,'9:45','9:50'),
							(2,4,'7:05','7:45'),
							(3,4,'6:25','6:50');

EXEC addStationToRoute 'r3', 's2', '10:10', '11:10';



SELECT sid FROM Stations
EXCEPT
SELECT sid FROM StationsRoutes WHERE rid=2;

--c)
CREATE VIEW allStations
AS
	 SELECT r.rname FROM Routes r
	 WHERE NOT EXISTS(
		SELECT sid FROM Stations 
		EXCEPT 
		SELECT sid FROM StationsRoutes 
		WHERE rid=r.rid);

SELECT * FROM allStations;

--d)function that lists the name of the stations with motre than R routes R is a parameter
CREATE FUNCTION func(@r INT)
RETURNS TABLE
AS
	RETURN SELECT sname 
	FROM Stations s
	WHERE sid IN
	(SELECT sr.sid
	FROM StationsRoutes sr
	GROUP BY sr.sid
	HAVING COUNT(*)>=@r);

SELECT * FROM func(3);