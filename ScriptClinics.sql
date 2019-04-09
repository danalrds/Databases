IF OBJECT_ID('DoctorsPacients','U') IS NOT NULL
DROP TABLE DoctorsPacients;
IF OBJECT_ID('Doctors','U') IS NOT NULL
DROP TABLE Doctors;
IF OBJECT_ID('Diagnostics','U') IS NOT NULL
DROP TABLE Diagnostics;
IF OBJECT_ID('Specialities','U') IS NOT NULL
DROP TABLE Specialities;
IF OBJECT_ID('Pacients','U') IS NOT NULL
DROP TABLE Pacients;

CREATE TABLE Pacients(pid INT PRIMARY KEY IDENTITY(1,1),
					  pfname VARCHAR(30),
					  plname VARCHAR(30),
					  adress VARCHAR(30));
CREATE TABLE Specialities(sid INT PRIMARY KEY IDENTITY(1,1),
					  sname VARCHAR(30));
CREATE TABLE Diagnostics(diagid INT PRIMARY KEY IDENTITY(1,1),
					  diagname VARCHAR(30),
					 description VARCHAR(30));
CREATE TABLE Doctors(did INT PRIMARY KEY IDENTITY(1,1),
					  dfname VARCHAR(30),
					  dlname VARCHAR(30),
					  sid INT FOREIGN KEY REFERENCES Specialities(sid));
CREATE TABLE DoctorsPacients(did INT FOREIGN KEY REFERENCES Doctors(did),
					  pid INT FOREIGN KEY REFERENCES Pacients(pid),
					  diagid INT FOREIGN KEY REFERENCES Diagnostics(diagid),
					  thetime DATETIME,
					  obs VARCHAR(30),
					  PRIMARY KEY (did,pid));

INSERT Pacients VALUES ('firstname1', 'lastname1', 'adress1'),('firstname2', 'lastname2', 'adress2'),('firstname3', 'lastname3', 'adress3');
INSERT Specialities VALUES ('special1'), ('special2'), ('special3');
INSERT Diagnostics VALUES ('diag1', 'desc1'), ('diag2', 'desc2'), ('diag3', 'desc3');
INSERT Doctors VALUES ('d1firstname', 'd1lastname', 1), ('d2firstname', 'd2lastname', 2),('d3firstname', 'd3lastname', 3);
INSERT DoctorsPacients VALUES (1,1,1,'2018-12-12 12:45:30', 'obs1');

CREATE OR ALTER PROC addConsultation @pfname VARCHAR(30), @plname  VARCHAR(30), @dfname  VARCHAR(30), @dlname  VARCHAR(30), @diagname  VARCHAR(30),@obs  VARCHAR(30), @thetime DATETIME
AS 
DECLARE @pid INT, @did INT, @diagid INT, @countp INT, @countd INT, @countdiag INT;
	BEGIN
		SET @pid=(SELECT pid FROM Pacients WHERE pfname=@pfname AND @plname=plname);
		SET @did=(SELECT did FROM Doctors WHERE dfname=@dfname AND @dlname=dlname);
		SET @diagid=(SELECT diagid FROM Diagnostics WHERE diagname=@diagname)
		SET @countd=(SELECT COUNT(*) FROM Doctors WHERE dfname=@dfname AND @dlname=dlname);
		SET @countp=(SELECT COUNT(*) FROM Pacients WHERE pfname=@pfname AND @plname=plname);
		SET @countdiag=(SELECT COUNT(*) FROM Diagnostics WHERE diagname=@diagname);
		IF @countp=0 OR @countd=0 OR @countdiag=0   
		   RAISERROR('doctorid, or pacientid, or diagid null', 16,1);
	    ELSE
		BEGIN
		IF EXISTS(SELECT * FROM DoctorsPacients WHERE did=@did AND @pid=pid)
			BEGIN
				UPDATE DoctorsPacients
				SET diagid=@diagid, obs=@obs, thetime=@thetime
				WHERE did=@did AND  @pid=@pid;
			END
		ELSE
			BEGIN
				INSERT DoctorsPacients VALUES (@did, @pid,@diagid,@thetime,@obs);
			END
		END
	END


SELECT * FROM DoctorsPacients;
EXEC addConsultation 'firstname1', 'lastname1', 'd3firstname', 'd3lastname', 'diag1', 'ob1', '2019-01-06 12:45:45';
SELECT * FROM DoctorsPacients;


CREATE OR ALTER VIEW listDoctors
AS
	SELECT dfname, dlname FROM Doctors
	WHERE did IN
		(SELECT did FROM DoctorsPacients
		WHERE MONTH(thetime)=MONTH(SYSDATETIME())
		GROUP BY did
		HAVING COUNT(*)>1)
	ORDER BY dfname,dlname OFFSET 0 ROWS;

SELECT * FROM listDoctors;



CREATE OR ALTER FUNCTION listDoctorsMore(@thetime DATETIME)
RETURNS TABLE
AS
	RETURN
		SELECT dfname,dlname FROM Doctors d
		INNER JOIN 
		(SELECT did, thetime FROM DoctorsPacients
		WHERE thetime=@thetime
		GROUP BY did, thetime
		HAVING COUNT(*)>1) AS helper(did, thetime)
		ON d.did=helper.did;


SELECT * FROM listDoctorsMore('2019-01-06 12:45:45');
SELECT * FROM DoctorsPacients;