IF OBJECT_ID('BooksAuthors','U') IS NOT NULL
DROP TABLE BooksAuthors;
IF OBJECT_ID('Books','U') IS NOT NULL
DROP TABLE Books;
IF OBJECT_ID('Domaines','U') IS NOT NULL
DROP TABLE Domaines;
IF OBJECT_ID('Shops','U') IS NOT NULL
DROP TABLE Shops;
IF OBJECT_ID('Authors','U') IS NOT NULL
DROP TABLE Authors;

CREATE TABLE Authors(aid INT PRIMARY KEY IDENTITY(1,1),
	                 aname VARCHAR(30));

CREATE TABLE Shops(sid INT PRIMARY KEY IDENTITY(1,1),
	                 sname VARCHAR(30),
					 adress VARCHAR(30));

CREATE TABLE Domaines(did INT PRIMARY KEY IDENTITY(1,1),
	                 description VARCHAR(30));

CREATE TABLE Books(bid INT PRIMARY KEY IDENTITY(1,1),
	                 title VARCHAR(30),
					 pubdate DATE,
					 did INT FOREIGN KEY REFERENCES Domaines(did),
					 sid INT FOREIGN KEY REFERENCES Shops(sid));
CREATE TABLE BooksAuthors(bid INT FOREIGN KEY REFERENCES Books(bid),
						aid INT FOREIGN KEY REFERENCES Authors(aid),
						PRIMARY KEY (bid,aid));


INSERT Authors VALUES ('a1'), ('a2'), ('a3');
INSERT Shops VALUES ('s1','adress1'), ('s2', 'sdress2'), ('s3', 'adress3');
INSERT Domaines VALUES ('domain1'), ('domain2'), ('domain3');
INSERT Books VALUES ('b1', '2017-12-12', 1,1), ('b2', '2018-01-03', 2,2), ('b3','2018-05-15', 3,3);
INSERT Books VALUES ('b7', '2017-12-12', 1,1);
INSERT Books VALUES ('b8', '2017-12-12', 1,2);

CREATE OR ALTER PROC addBookAuthor @bookname VARCHAR(30),@authorname VARCHAR(30)
AS
DECLARE @bookid INT, @authorid INT, @nr INT;
	BEGIN
		SET @bookid=(SELECT bid FROM Books WHERE title=@bookname);		
		SET @nr=(SELECT COUNT(*) FROM Authors WHERE aname=@authorname);
		IF (@nr =0)	
			BEGIN
				INSERT Authors VALUES (@authorname);
			END
		SET @authorid=(SELECT aid FROM Authors WHERE aname=@authorname);
		IF EXISTS( SELECT * FROM BooksAuthors WHERE bid=@bookid AND  aid=@authorid)
			BEGIN
				PRINT 'this association has already been made!';
			END
		ELSE
			BEGIN
				INSERT BooksAuthors VALUES (@bookid, @authorid);
			END
		
	END

SELECT * FROM BooksAuthors;
EXEC addBookAuthor 'b2', 'a4';
SELECT * FROM BooksAuthors;


CREATE OR ALTER VIEW listShops
AS
	SELECT sname FROM Shops
	WHERE sid IN
		(SELECT sid FROM Books
		GROUP BY sid
		HAVING COUNT(*)>1)
	ORDER BY sname DESC OFFSET 0 ROWS;


SELECT * FROM listShops;


SELECT * FROM BooksAuthors;

CREATE OR ALTER FUNCTION listBooks (@nrAuthors INT)
RETURNS TABLE
AS 
RETURN 
SELECT b.title, s.sname, s.adress, helper.nr AS nr FROM Books b
INNER JOIN Shops s
ON  b.sid=s.sid
INNER JOIN
	(SELECT bid, COUNT(*) FROM BooksAuthors
	GROUP BY bid
	HAVING COUNT(*)=@nrAuthors) AS helper(bid, nr)
ON b.bid=helper.bid;

SELECT * FROM listBooks(2);