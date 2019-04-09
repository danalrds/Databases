CREATE TABLE Customers(cid INT PRIMARY KEY IDENTITY(1,1), 
						code INT UNIQUE, 
						name VARCHAR(30));
CREATE TABLE Planes(pid INT PRIMARY KEY IDENTITY(1,1), 
					pcode INT, 
					type VARCHAR(30));
CREATE TABLE Rentals(rid INT PRIMARY KEY IDENTITY(1,1), 
					cid INT FOREIGN KEY REFERENCES Customers(cid), 
					pid INT FOREIGN KEY REFERENCES Planes(pid), 
					cost INT);
SELECT * FROM Rentals;
DELETE FROM Rentals;
DELETE FROM Planes;
EXEC uspInsertCustomers 10000;
EXEC uspInsertRentals 100;
EXEC uspInsertPlanes 10000;
SELECT * FROM Planes;


--clustered index seek
SELECT [name] FROM Customers WHERE cid>30;
--clustered index scan
SELECT code,[name] FROM Customers WHERE code<1000;
--non-clustered index seek + key lookup
SELECT cid,[name] FROM Customers WHERE code=77;
--non-clustered index scan
SELECT code FROM Customers GROUP BY code;
--part b)
SELECT type FROM Planes WHERE pcode=50;
CREATE NONCLUSTERED INDEX Idx_Pcode ON Planes(pcode); 
EXEC sp_helpindex Planes;
DROP INDEX Planes.Idx_Pcode;
--part c)
SELECT  c.name FROM Customers c 
INNER JOIN Rentals r ON r.cid=c.cid 
INNER JOIN Planes p ON p.pid=r.pid 
WHERE p.pcode=500;

--this is also good
SELECT SUM(r.cost) 
FROM Customers c INNER JOIN
Rentals r ON c.cid=r.cid
INNER JOIN
	(SELECT p.pid,p.type FROM Planes p 
	WHERE p.pcode=50) AS helper(pid,type)
ON r.pid=helper.pid;


