IF OBJECT_ID('ConferenceSpeakers','U') IS NOT NULL
DROP TABLE ConferenceSpeakers;
IF OBJECT_ID('Speakers','U') IS NOT NULL
DROP TABLE Speakers;
IF OBJECT_ID('Conferences','U') IS NOT NULL
DROP TABLE Conferences;
IF OBJECT_ID('Companies','U') IS NOT NULL
DROP TABLE Companies;
IF OBJECT_ID('ConferenceTypes','U') IS NOT NULL
DROP TABLE ConferenceTypes;

CREATE TABLE Companies(cid INT PRIMARY KEY IDENTITY(1,1),
						cname VARCHAR(30),
						description VARCHAR(30),
						website VARCHAR(30),
						nremployees INT);
CREATE TABLE	 Speakers(sid INT PRIMARY KEY IDENTITY(1,1),
						  name VARCHAR(30),
						  email VARCHAR(30),
						  dob DATE,
						  companyid INT FOREIGN KEY REFERENCES Companies(cid));
CREATE TABLE ConferenceTypes(tid INT PRIMARY KEY IDENTITY(1,1),
							 name VARCHAR(30),
							 popularity INT);
CREATE TABLE Conferences(confid INT PRIMARY KEY IDENTITY(1,1),
						 name VARCHAR(30),
						 location VARCHAR(30),
						 startdate DATE,
						 enddate DATE,
						 typeid INT FOREIGN KEY REFERENCES ConferenceTypes(tid));
CREATE TABLE ConferenceSpeakers(confid INT FOREIGN KEY REFERENCES Conferences(confid),
							    speakerid INT FOREIGN KEY REFERENCES Speakers(sid),
								speachlength INT,
								PRIMARY KEY (confid, speakerid));
GO

INSERT Companies VALUES ('company1', 'desc1', 'web1', 100),('company2', 'desc2', 'web2', 50);
INSERT ConferenceTypes VALUES ('type1', 5), ('type2', 10);
INSERT Speakers VALUES ('speaker1', 'email1', '1999-04-02', 1),('speaker2', 'email2', '1998-04-02', 2);
INSERT Conferences VALUES ('conf1', 'Beyjing', '2018-12-06', '2018-12-10', 1), ('conf2', 'Seul', '2018-11-06', '2018-11-10', 2);
INSERT ConferenceSpeakers VALUES (1, 1, 30), (2,2,40), (1,2,40);
INSERT Speakers VALUES ('speaker3', 'email3', '1997-04-02', 1);
INSERT ConferenceSpeakers VALUES (1, 3, 30);
INSERT Speakers VALUES ('speaker4', 'email4', '1996-04-02', 1);
GO

---2)
CREATE OR ALTER PROC addSpeaker @speakername VARCHAR(30), @confname VARCHAR(30), @speachlength INT
AS
DECLARE @speakerid INT,@confid INT;
	BEGIN
		SET @speakerid=(SELECT sid FROM Speakers WHERE name=@speakername);
		SET @confid=(SELECT confid FROM Conferences WHERE name=@confname);
		IF EXISTS(SELECT * FROM ConferenceSpeakers WHERE confid=@confid AND  speakerid=@speakerid)
			BEGIN
				UPDATE ConferenceSpeakers
				SET speachlength=@speachlength
				WHERE speakerid=@speakerid AND confid=@confid;
			END
		ELSE
			BEGIN
				INSERT ConferenceSpeakers VALUES (@confid, @speakerid, @speachlength);
			END

	END

SELECT * FROM ConferenceSpeakers;
EXEC addSpeaker 'speaker1', 'conf2', 33;
SELECT * FROM ConferenceSpeakers;

GO

--3)

CREATE OR ALTER VIEW listConferences
AS
   SELECT name,location
   FROM Conferences c
   INNER JOIN 
		(SELECT confid, COUNT(*)
		 FROM ConferenceSpeakers
		 GROUP BY confid) AS helper(confid, nrspeakers)
	ON c.confid=helper.confid
	WHERE helper.nrspeakers>=3;

SELECT * FROM listConferences;

GO

--4)
CREATE OR ALTER FUNCTION listSpeakers()
RETURNS TABLE
AS 
	RETURN
	SELECT c.cname, s.[name], email 
	FROM Speakers s
	INNER JOIN Companies c
	ON s.companyid=c.cid
	WHERE s.sid IN
	   (SELECT sid FROM Speakers
		EXCEPT
		SELECT s.sid
		FROM Speakers s 
		INNER JOIN ConferenceSpeakers cs
		ON cs.speakerid=s.sid);

SELECT * FROM listSpeakers();