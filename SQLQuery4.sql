DECLARE @fname varchar(20)='version_'
exec @fname

exec usptoVersion 0

select * 
from sys.objects
where type = 'F'

DECLARE @fname varchar(30)='modifyColumnTypeReverse'
exec @fname

UPDATE Version
SET crt=5;

CREATE TABLE Version(crt INT);
INSERT INTO Version(crt) values (0);
SELECT * FROM Version;

ALTER TABLE Airport
ADD CONSTRAINT [CT_Unique] UNIQUE(code);

CREATE TABLE Procedures(id INT PRIMARY KEY IDENTITY(1,1),name VARCHAR(40));
INSERT INTO Procedures([name]) 
	VALUES ('modifyColumnType'), ('addColumn'),('addDefaultConstraint'), ('removePrimaryKey'), ('removeCandidateKey'),('removeForeignKey'),('createTable');

CREATE TABLE Reverses(id INT PRIMARY KEY IDENTITY(1,1), name VARCHAR(40));
INSERT INTO Reverses(name) 
	VALUES
			('modifyColumnTypeReverse'),('removeColumn'), ('removeDefaultConstraint'), ('addPrimaryKey'), ('addCandidateKey'), ('addForeignKey'), ('removeTable');

SELECT * FROM Reverses;