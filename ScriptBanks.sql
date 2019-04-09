IF OBJECT_ID('Transactions','U') IS NOT NULL
DROP TABLE Transactions;
IF OBJECT_ID('Atms','U') IS NOT NULL
DROP TABLE Atms;
IF OBJECT_ID('Cards','U') IS NOT NULL
DROP TABLE Cards;
IF OBJECT_ID('Accounts','U') IS NOT NULL
DROP TABLE Accounts;
IF OBJECT_ID('Customers','U') IS NOT NULL
DROP TABLE Customers;


CREATE TABLE Customers(cid INT PRIMARY KEY IDENTITY(1,1),
	                   name VARCHAR(30),
					   dob DATE);
CREATE TABLE Accounts(aid INT PRIMARY KEY IDENTITY(1,1),
					  IBANcode VARCHAR(30),
					  balance INT,
					  cid INT FOREIGN KEY REFERENCES Customers(cid));
CREATE TABLE Cards(cardid INT PRIMARY KEY IDENTITY(1,1),
				   number INT,
				   CVVcode VARCHAR(30),
				   aid INT FOREIGN KEY REFERENCES Accounts(aid));
CREATE TABLE Atms(atmid INT PRIMARY KEY IDENTITY(1,1),
				  adress VARCHAR(30));
CREATE TABLE Transactions(tid INT PRIMARY KEY IDENTITY(1,1),
						  money INT,	
						  moment DATETIME,
						  atmid INT FOREIGN KEY REFERENCES Atms(atmid),
						  cardid INT FOREIGN KEY REFERENCES Cards(cardid));

INSERT Customers VALUES ('customer1', '1999-04-02'), ('customer2', '1999-05-03'), ('customer3', '1999-06-04');
INSERT Accounts VALUES ('iban1', 1, 1), ('iban2', 2, 2), ('iban3', 3,3);
INSERT Cards VALUES (111, 'cvv1', 1), (222, 'cvv2', 2), (333, 'cvv3', 3);
INSERT Atms VALUES ('ADRESS1'),( 'ADRESS2'), ('ADRESS 3');
INSERT Transactions VALUES (1500, '2018-03-30 12:45:37.333', 1, 3), (400, '2018-01-30 12:45:37.333', 3, 3), (4990, '2018-01-30 12:45:37.333', 3, 1);


CREATE OR ALTER PROC deleteTransactions @cardnumber INT
AS
DECLARE @cardid INT, @nr INT;
	BEGIN
		SET @nr=(SELECT COUNT(*) FROM Cards WHERE number=@cardnumber);
		IF (@nr>0)
			BEGIN
				SET @cardid=(SELECT cardid FROM Cards WHERE number=@cardnumber);
				DELETE FROM Transactions
				WHERE cardid=@cardid;
			END
	END

SELECT * FROM Transactions;
EXEC deleteTransactions 111;
SELECT * FROM Transactions;



CREATE OR ALTER VIEW listCards
AS
	SELECT number FROM Cards
	WHERE cardid IN
		(SELECT cardid
		FROM Transactions 
		GROUP BY cardid
		HAVING COUNT(DISTINCT atmid)=(SELECT COUNT(*) FROM Atms));


SELECT * FROM listCards;


SELECT * FROM Transactions;


CREATE OR ALTER FUNCTION listCardsMoney()
RETURNS TABLE
AS
RETURN
	SELECT number, CVVcode 
	FROM Cards
	WHERE cardid IN
		(SELECT cardid
		FROM Transactions
		GROUP BY cardid
		HAVING SUM(money)>2000);

SELECT * FROM listCardsMoney();