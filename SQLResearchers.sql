CREATE TABLE Researchers(rid INT PRIMARY KEY IDENTITY(1,1),
					     name VARCHAR(30),
						 impactFactor INTEGER,
						 age INTEGER);
CREATE TABLE Papers(pid INT PRIMARY KEY IDENTITY(1,1),
					title VARCHAR(30),
					conference VARCHAR(30));
CREATE TABLE AuthorContribution(rid INTEGER FOREIGN KEY REFERENCES Researchers(rid),
							    pid INTEGER FOREIGN KEY REFERENCES Papers(pid),
								year INTEGER,
								PRIMARY KEY(rid,pid));


INSERT Researchers VALUES ('Pop',1,24),('Pop',2,25),('Ionescu', 5,46);
INSERT Papers VALUES ('title1','conf1'),('title2','conf2'), ('title3','conf3');
INSERT AuthorContribution VALUES (1,1,2004),(2,2,2005),(3,3,2006);
INSERT AuthorContribution VALUES (2,1,2004);

SELECT * FROM AuthorContribution;

SELECT  P.Conference
FROM Researchers R, AuthorContribution A, Papers P
WHERE R.RID = A.RID AND A.PID = P.PID AND R.Name= 'Pop';
