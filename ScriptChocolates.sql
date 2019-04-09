IF OBJECT_ID('PresentsChocolates','U') IS NOT NULL
DROP TABLE PresentsChocolates;
IF OBJECT_ID('CustomersPresents','U') IS NOT NULL
DROP TABLE CustomersPresents;
IF OBJECT_ID('Presents','U') IS NOT NULL
DROP TABLE Presents;
IF OBJECT_ID('Customers','U') IS NOT NULL
DROP TABLE Customers;
IF OBJECT_ID('PresentTypes','U') IS NOT NULL
DROP TABLE PresentTypes;
IF OBJECT_ID('Chocolates','U') IS NOT NULL
DROP TABLE Chocolates;



CREATE TABLE Chocolates(chocoid INT PRIMARY KEY IDENTITY(1,1),
					    choconame VARCHAR(30),
						price INT);
CREATE TABLE PresentTypes(typeid INT PRIMARY KEY IDENTITY(1,1),
				          tname VARCHAR(30));
CREATE TABLE Customers(cid INT PRIMARY KEY IDENTITY(1,1),
					   cname VARCHAR(30),
					   dob DATE);
CREATE TABLE Presents(pid INT PRIMARY KEY IDENTITY(1,1),
					  color VARCHAR(30),
					  wight INT,
					  typeid INT FOREIGN KEY REFERENCES PresentTypes(typeid));
CREATE TABLE CustomersPresents(cpid INT PRIMARY KEY IDENTITY(1,1), 
							   cid INT FOREIGN KEY REFERENCES Customers(cid),
							   pid INT FOREIGN KEY REFERENCES Presents(pid));
CREATE TABLE PresentsChocolates(pid INT FOREIGN KEY REFERENCES Presents(pid),
								chocoid INT FOREIGN KEY REFERENCES Chocolates(chocoid),
								quantity INT,
								PRIMARY KEY(pid,chocoid));

INSERT Chocolates VALUES ('choco1', 100), ('choco2', 200), ('choco3', 300);
INSERT PresentTypes VALUES ('type1'), ('type2'), ('type3');
INSERT Customers VALUES ('customer1', '1999-04-02'), ('customer2', '1999-05-03'), ('customer3', '1999-06-04');
INSERT Presents VALUES ('color1', 10, 1), ('color2', 20,2), ('colo3', 30,3);
INSERT CustomersPresents VALUES (1,1), (2,2), (3,3);
INSERT CustomersPresents VALUES (1,2), (1,3);

CREATE OR ALTER PROC addChocolate @choconame VARCHAR(30), @presentid INT, @quantity INT
AS	
DECLARE @chocoid INT, @counter INT;
	BEGIN
		  SET @counter=(SELECT COUNT(*) FROM Chocolates WHERE @choconame=choconame);
		  IF ((@counter>0) AND (@quantity>0))
			BEGIN
				SET @chocoid=(SELECT chocoid FROM Chocolates WHERE choconame=@choconame);
				INSERT PresentsChocolates 
				VALUES (@presentid, @chocoid,@quantity);
			END
	END

SELECT * FROM PresentsChocolates;
EXEC addChocolate 'choco2', 3, 40;
SELECT * FROM PresentsChocolates;


SELECT * FROM CustomersPresents;

CREATE OR ALTER VIEW listCustomers
AS
	SELECT cname as CustomerName
	FROM Customers
	WHERE cid IN
		(SELECT cid
		FROM CustomersPresents
		GROUP BY cid
		HAVING COUNT(*)=3);


SELECT * FROM listCustomers;

--SELECT * FROM PresentsChocolates;

CREATE OR ALTER FUNCTION listPresents()
RETURNS TABLE
AS
	RETURN 
		  SELECT pid, color
		  FROM Presents
		  WHERE pid IN
				(SELECT pid
				FROM PresentsChocolates
				GROUP BY pid
				HAVING COUNT(*)=(SELECT COUNT(*) FROM Chocolates));

SELECT * FROM listPresents();