IF OBJECT_ID('ProductsBills','U') IS NOT NULL
DROP TABLE ProductsBills;
IF OBJECT_ID('Bills','U') IS NOT NULL
DROP TABLE Bills;
IF OBJECT_ID('Products','U') IS NOT NULL
DROP TABLE Products;
IF OBJECT_ID('Agents','U') IS NOT NULL
DROP TABLE Agents;
IF OBJECT_ID('Clients','U') IS NOT NULL
DROP TABLE Clients;

CREATE TABLE Clients(cid INT PRIMARY KEY IDENTITY(1,1),
					name VARCHAR(30),
					code VARCHAR(30));
CREATE TABLE Agents(aid INT PRIMARY KEY IDENTITY(1,1),
					name VARCHAR(30));
CREATE TABLE Products(pid INT PRIMARY KEY IDENTITY(1,1),
					name VARCHAR(30),
					measure VARCHAR(30));
CREATE TABLE Bills( bid INT PRIMARY KEY IDENTITY(1,1),
					number INT,
					date DATE,
					clientid INT FOREIGN KEY REFERENCES Clients(cid),
					agentid INT FOREIGN KEY REFERENCES Agents(aid));
CREATE TABLE ProductsBills(ordernumber INT,
						   price INT,
						   quantity INT,
						   productid INT FOREIGN KEY REFERENCES Products(pid),	
						   billid INT FOREIGN KEY REFERENCES Bills(bid));	
					

INSERT Clients VALUES ('client1', 'code1'),
					  ('client2', 'code2'),
					  ('client3', 'code3'); 

INSERT Agents VALUES ('agent1'),
					  ('agent2'),
					  ('agent3');

INSERT INTO Products VALUES ('product1', 'kilo'),
							('product2', 'litre'),
							('product3', 'livre');	
							
INSERT Bills VALUES (10, '2018-01-30', 1,1),
                    (11, '2018-03-20', 2,2),
					(12,'2018-05-14', 3,3); 	

GO

--2)
CREATE OR ALTER PROC insertBill @number INT, @productname VARCHAR(30), @ordernumber INT,@price INT, @quantity INT
AS 
DECLARE @productid INT,
        @billid INT,
		@pricefound INT,
		@quantityfound INT;
    BEGIN
		SET @productid=(SELECT pid FROM Products WHERE @productname=name);
		SET @billid=(SELECT bid FROM Bills WHERE @number=number);
		IF EXISTS(SELECT * FROM ProductsBills WHERE @productid=productid AND billid=@billid)
			BEGIN
				SET @pricefound=(SELECT price FROM ProductsBills WHERE @productid=productid AND billid=@billid);
				SET @quantityfound=-(SELECT quantity FROM ProductsBills WHERE @productid=productid AND billid=@billid);
				INSERT ProductsBills VALUES (@ordernumber,@pricefound,@quantityfound,@productid,@billid);
			END
		ELSE
			BEGIN
				INSERT ProductsBills VALUES (@ordernumber,@price, @quantity, @productid, @billid);
			END

	END


EXEC insertBill 11, 'product2', 3,45,100;

SELECT *   FROM ProductsBills;
	
INSERT Products VALUES ('Shaorma', 'gram');
INSERT ProductsBills VALUES (1,10,45,4,1), (1,20,10,4,2);
INSERT ProductsBills VALUES (1,10,50,3,1);



--3)
CREATE VIEW listShaorma
AS
SELECT client.name, bill.number, bill.date, helper.totalvalue
FROM Bills bill INNER JOIN 
	(SELECT pb.billid, SUM(pb.price*pb.quantity)
	FROM ProductsBills pb 
	WHERE pb.billid IN 
				(SELECT pb.billid 
				 FROM ProductsBills pb
				 INNER JOIN Products p 
		         ON pb.productid=p.pid 
			     WHERE p.name='Shaorma')

	GROUP BY pb.billid
	HAVING SUM(pb.price*pb.quantity)>300) helper(billid,totalvalue)
ON bill.bid=helper.billid
INNER JOIN Clients client
ON client.cid=bill.clientid;
  
SELECT * FROM listShaorma;



--4)
CREATE OR ALTER FUNCTION billsAgents(@year INT)
RETURNS TABLE
AS 
	RETURN SELECT MONTH(bill.date) AS Month, agent.name AS AgentName,  SUM(pb.price*pb.quantity) AS TotalValue
		   FROM Agents agent 
		   INNER JOIN Bills bill
		   ON bill.agentid=agent.aid
		   INNER JOIN ProductsBills pb
		   ON pb.billid=bill.bid
		   WHERE YEAR(bill.date)=@year
		   GROUP BY MONTH(bill.date), agent.name
		   ORDER BY MONTH(bill.date), agent.name
		   OFFSET 0 ROWS;


SELECT * FROM billsAgents(2018);


SELECT * FROM Bills;
SELECT * FROM ProductsBills;
INSERT ProductsBills VALUES (4,100,2,3,1), (5,200,1,3,3);
INSERT Bills VALUES (13,'2018-01-15', 2,2);
INSERT ProductsBills VALUES (4,99,1,2,4);