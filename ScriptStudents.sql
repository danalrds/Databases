CREATE TABLE Groups(grip INT PRIMARY KEY IDENTITY(1,1), name VARCHAR(30));
CREATE TABLE Students(stid INT PRIMARY KEY IDENTITY(1,1), name VARCHAR(30), grip INT FOREIGN KEY REFERENCES Groups(grip));
CREATE TABLE Tasks(tid INT PRIMARY KEY IDENTITY(1,1), name VARCHAR(30));
CREATE TABLE Grades(gradeid INT PRIMARY KEY IDENTITY(1,1), 
				    tid INT FOREIGN KEY REFERENCES Tasks(tid), 
					stid INT FOREIGN KEY REFERENCES Students(stid), 
					value FLOAT);
CREATE TABLE Comments(cid INT PRIMARY KEY IDENTITY(1,1), gradeid INT FOREIGN KEY REFERENCES Grades(gradeid), status VARCHAR(30));

ALTER TABLE Grades ADD CONSTRAINT  unique_index UNIQUE(tid, stid);
INSERT INTO Groups(name) VALUES ('Group921'), ('Group922'), ('Group923');
INSERT INTO Students(name, grip) VALUES ('Silvana',1), ('Johnatan', 2), ('Raysa', 3);
INSERT INTO Tasks(name) VALUES ('Task1'), ('Task2'), ('Task3');
INSERT INTO Grades(tid, stid, value) VALUES (1, 1, 8), (1,2,9), (1, 3,7), (2,1,8), (2,3,10), (3,1,7), (3,3,10);
INSERT INTO Comments(gradeid,status) VALUES (1,'opened'), (2,'resolved'), (3,'resolved'), (4,'opened'), (4, 'resolved'), (5,'opened'), (6,'opened'), (7,'resolved');

--b)
CREATE PROC insertStudentGrade @studentname VARCHAR(30), @taskname VARCHAR(30), @grade FLOAT, @comment VARCHAR(30)
AS
DECLARE @studentid INT, @taskid INT,@gradeid INT=0;
	BEGIN		
		SET @studentid=(SELECT stid FROM Students WHERE name=@studentname);
		SET @taskid=(SELECT tid FROM Tasks WHERE name=@taskname);
		IF EXISTS (SELECT 1 FROM Grades WHERE tid=@taskid AND stid=@studentid)
		    BEGIN
				SET @gradeid= (SELECT gradeid FROM Grades WHERE tid=@taskid AND stid=@studentid);
				UPDATE Grades
				SET value=@grade
				WHERE tid=@taskid AND stid=@studentid;
				INSERT INTO Comments(gradeid, status) VALUES (@gradeid, @comment);
		    END
		ELSE
		    BEGIN
				INSERT INTO Grades(tid,stid,value) VALUES (@taskid, @studentid,@grade);
				SET @gradeid=IDENT_CURRENT(N'Grades');	
				INSERT INTO Comments(gradeid, status) VALUES (@gradeid, @comment);			
			END;	   
	END
	

EXEC insertStudentGrade 'Silvana', 'Task3',9, 'resolved';
SELECT * FROM Grades;
SELECT * FROM Comments;
--c)
CREATE VIEW openedComments
AS
	SELECT s.[name] FROM Students s WHERE s. stid IN (SELECT DISTINCT s.stid FROM Students s 
	INNER JOIN Grades g ON s.stid= g.stid 
	INNER JOIN Comments c ON c.gradeid=g.gradeid
	WHERE c.status='opened') ;

SELECT * FROM openedComments;

--d)
SELECT * FROM Grades;
SELECT s.name, h.value FROM Students s 
					INNER JOIN (SELECT g.stid, AVG(g.value) FROM Grades g  INNER JOIN Tasks t ON t.tid=g.tid GROUP BY g.stid) AS h(stid, value) ON h.stid=s.stid;
