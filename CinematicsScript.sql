IF OBJECT_ID('CinematicHeroes','U') IS NOT NULL
DROP TABLE CinematicHeroes;
IF OBJECT_ID('Cinematics','U') IS NOT NULL
DROP TABLE Cinematics;
IF OBJECT_ID('Games','U') IS NOT NULL
DROP TABLE Games;
IF OBJECT_ID('Companies','U') IS NOT NULL
DROP TABLE Companies;
IF OBJECT_ID('Heroes','U') IS NOT NULL
DROP TABLE Heroes;


CREATE TABLE Heroes(hid INT PRIMARY KEY IDENTITY(1,1),
					hname VARCHAR(30),
					hdesc VARCHAR(30),
					importance INT);

CREATE TABLE Companies(cid INT PRIMARY KEY IDENTITY(1,1),
						cname VARCHAR(30),
						cdes VARCHAR(30),
						web VARCHAR(30));

CREATE TABLE Games(gid INT PRIMARY KEY IDENTITY(1,1),
					gname VARCHAR(30),
					releasedate date,
					cid INT FOREIGN KEY REFERENCES Companies(cid));

CREATE TABLE Cinematics(cinid INT PRIMARY KEY IDENTITY(1,1),
						cinname VARCHAR(30),
						gid INT FOREIGN KEY REFERENCES Games(gid));

CREATE TABLE CinematicHeroes(cinid INT FOREIGN KEY REFERENCES Cinematics(cinid),
							 hid INT FOREIGN KEY REFERENCES Heroes(hid),
							 entrymomemt TIME, PRIMARY KEY (cinid,hid));


INSERT Heroes VALUES('h1', 'desc1',1), ('h2', 'desc2', 2), ('h3', 'desc3', 3);
INSERT Companies VALUES ('company1', 'cdesc1', 'web1'), ('company2', 'cdesc2', 'web2'),('company3', 'cdesc3', 'web3');
INSERT Games VALUES ('g1', '2018-03-14', 1), ('g2', '2018-01-30',2), ('g3', '2018-06-15',3);
INSERT Cinematics VALUES ('cin1', 1), ('cin2', 2), ('cin3', 3);
INSERT Games VALUES ('g1', '2015-03-14', 1);
INSERT Cinematics VALUES ('cin4', 4);
GO

CREATE OR ALTER PROC addCinematicHeroe @heroname VARCHAR(30), @cinname VARCHAR(30), @entrymoment TIME
AS
DECLARE @heroid INT, @cinid INT;
	BEGIN
		SET @heroid=(SELECT hid FROM Heroes WHERE hname=@heroname);
		SET @cinid=(SELECT cinid FROM Cinematics WHERE cinname=@cinname);
		IF EXISTS(SELECT * FROM CinematicHeroes WHERE hid=@heroid AND cinid=@cinid)
			BEGIN
				UPDATE CinematicHeroes
				SET entrymomemt=@entrymoment
				WHERE hid=@heroid AND  cinid=@cinid;
			END
		ELSE
			BEGIN
				INSERT CinematicHeroes VALUES (@cinid,@heroid,@entrymoment);
			END
	END


SELECT * FROM CinematicHeroes;
EXEC  addCinematicHeroe 'h1', 'cin2', '09:45';
SELECT * FROM CinematicHeroes;

GO

CREATE OR ALTER VIEW listHeroes 
AS
	SELECT hname, importance 
	FROM Heroes 
	WHERE hid IN
		(SELECT ch.hid FROM Cinematics C INNER JOIN CinematicHeroes ch
		ON ch.cinid=c.cinid
		GROUP BY hid
		HAVING COUNT(*)>= ( SELECT COUNT(*)FROM Cinematics));

SELECT * FROM listHeroes;

GO

CREATE OR ALTER FUNCTION theGames()
RETURNS TABLE
AS
RETURN
SELECT g.gname, c.cname, cin.cinname FROM Games g 
INNER JOIN Companies c
ON c.cid=g.cid
INNER JOIN Cinematics cin
ON cin.gid=g.gid
WHERE g.releasedate BETWEEN '2000-12-02' AND '2016-01-01';

SELECT * FROM theGames();