--4 inserts
insert into Airport(code, name, city) values 
('BCN','El Prat', 'Barcelona'), 
('ATL','Hartsfield-Jackson', 'Atlanta'),
('PEK','Capital International', 'Beijing'),  
('HND','Haneda', 'Tokio'), 
('LAX','LA International', 'Los Angeles'),
 ('ORD', 'O-Hare International', 'Chicago');

insert into Flight(departure,arrival, planeId) values 
(1,5, 3),
(3,2, 4), 
(1,6, 5), 
(4,3, 6);   --6 doesn't exists as id in the Plane table

insert into Stewardess([name],age) values
 ('Linda Carrol',23), 
('Raisa Al-Merah',27), 
('Mylenna Castillo',25), 
('Liu Wen',20),
 ('Behati Prinsloo',22);
 
insert into TechTeam([name],size, airpId) values 
('Team1',100,3),
 ('Team2',65,3),
 ('Team2',125,5);

--3 updates 
SELECT * FROM Pilot;
UPDATE Pilot
SET salary=salary+400 
WHERE (salary<1000) AND name IS NOT NULL;

UPDATE TechTeam
SET size=size+20
WHERE (id>=2) OR (size>90) OR (airpId=5);
SELECT * FROM TechTeam;

UPDATE TechTeam
SET size=size+20
WHERE ((id>=2) OR (size>90) OR (airpId=5)) AND (name LIKE 'Team%');
SELECT *FROM TechTeam;

--2 deletes
DELETE FROM Pilot
WHERE NOT(salary<=3000) and (degree BETWEEN 2 AND 5); 

DELETE FROM Stewardess
WHERE (age<>34) AND name NOT IN('Raisa');

--A)     2 queries using UNION operators
--The director wants to see all the employees
SELECT name FROM Pilot
UNION ALL
SELECT name FROM Stewardess
UNION ALL
SELECT name FROM Engineer;

--The manager wants to see the stewardesses younger than 20  and older than 30 
SELECT name, age FROM Stewardess 
WHERE (age<20) OR (age>30);

--B)    2 queris using INTERSECTION operators
--all the airports id that are departure and also destination with id>2
SELECT departure FROM Flight
INTERSECT
SELECT arrival  FROM Flight
WHERE arrival>2;

--see the names of techteams working in airports 4 and 5
SELECT name FROM TechTeam
WHERE airpId IN (4,5);

--C)     2 queries using difference operators
--see the stewardesses that have the age > 22 don't attend any of the flights 4 and 5
SELECT id FROM Stewardess
WHERE age >22
EXCEPT
SELECT stid FROM StewardessFlight
WHERE flid  IN (4,5);
 
-- See the code and name of the airports that aren't located in Barcelona and Tokio 
SELECT TOP 3 code, name FROM Airport
WHERE city NOT IN ('Barcelona', 'Tokio')
ORDER BY name;


--D)    4 queries using Joins
--see the name and the size of techteams
SELECT TOP 2  t.name,size FROM 
TechTeam t INNER JOIN Engineer e
ON t.id=e.tid
ORDER BY size DESC;

SELECT type,capacity,departure,arrival FROM 
Plane p FULL JOIN Flight f
ON p.id=f.planeId AND p.capacity>160;

--join 3 tables
SELECT t.name,a.name FROM
TechTeam t LEFT OUTER JOIN Airport a
ON t.airpId=a.id 
INNER JOIN Terminal ter 
ON a.id=ter.airpId;
 
--inner join between 2 many to many relations
SELECT * FROM StewardessFlight;
SELECT s.name, a.name,a.city 
FROM Stewardess s INNER JOIN StewardessFlight sf 
ON s.id=sf.stid RIGHT JOIN Flight f 
ON f.id=sf.flid INNER JOIN Airport a 
ON a.id=f.arrival;

--E)     2 queries using IN 
SELECT coordinates FROM Terminal 
WHERE airpId  IN (SELECT id FROM Airport WHERE city LIKE 'B___%' );

SELECT DISTINCT code FROM Airport 
WHERE id IN (SELECT id FROM Airport WHERE city IN (SELECT city FROM Airport WHERE city LIKE 'B__%') );

--F)      2 queries using EXISTS 
SELECT DISTINCT [type] FROM Plane pl
WHERE EXISTS(
	SELECT planeId FROM Flight f WHERE pl.id=f.planeId);

SELECT DISTINCT [name] FROM TechTeam t
WHERE EXISTS(
			SELECT e.tid FROM Engineer e
			WHERE (e.tid=t.id) OR (e.name='Gianny'));

--G)      2 queries with a subquery in the FROM clause
SELECT SUM(salary) AS Total FROM(
			SELECT salary FROM Pilot WHERE salary>800) AS salary;

SELECT AVG(age) AS Average FROM(
			SELECT age FROM Stewardess	WHERE age>21) AS age; 
--H)       4 queries with GROUP BY clause
SELECT s.nationality, MIN(s.age) AS themin FROM Stewardess s
WHERE (s.age>21)
GROUP BY s.nationality
HAVING not(COUNT(*)<1)
ORDER BY themin;

SELECT MAX(age) as maxage, nationality FROM Stewardess
GROUP BY nationality
ORDER BY maxage, nationality DESC;

SELECT AVG(salary) AS the_sum 
FROM Pilot p
WHERE degree>2
GROUP BY nationality
HAVING SUM(SALARY)< (SELECT MAX(salary)*5 FROM Pilot);

SELECT MAX(salary) AS maximum
FROM Pilot p
GROUP BY degree
HAVING MAX(salary)>(SELECT AVG(salary)+100 FROM Pilot);

--I)   4 queries using ANY and ALL
--1ST
SELECT * FROM Pilot p
WHERE p.salary>ANY(
					SELECT p2.salary FROM Pilot p2
					WHERE p2.name='Vicente Fernandez');
     --rewritten
SELECT * FROM Pilot p
WHERE p.salary>(
					SELECT MIN(p2.salary)-1 FROM Pilot p2
					WHERE p2.name='Vicente Fernandez');


--2ND
SELECT s.name,s.age FROM Stewardess s
WHERE s.age=ANY(
				SELECT s2.age FROM Stewardess s2
				WHERE s2.nationality='Spanish');

     --rewritten
SELECT s.name,s.age FROM Stewardess s
WHERE s.age IN (SELECT s2.age FROM Stewardess s2
                WHERE s2.nationality='Spanish');

--3RD
SELECT p.type FROM Plane p
WHERE P.capacity<>ALL(
					SELECT p2.capacity FROM Plane p2
					WHERE p2.type='Bombardier CSeries');
     --rewritten
SELECT p.type FROM Plane p
WHERE P.capacity NOT IN (
					SELECT p2.capacity FROM Plane p2
					WHERE p2.type='Bombardier CSeries');

--4TH
SELECT t.name FROM TechTeam t
WHERE t.size>ALL(
				SELECT t2.size FROM TechTeam t2
				INNER JOIN Engineer e ON t2.id=e.tid AND t2.airpId<5);

--rewritten
SELECT t.name FROM TechTeam t
WHERE t.size >(
				SELECT MAX(t2.size) FROM TechTeam t2
				INNER JOIN Engineer e ON t2.id=e.tid AND t2.airpId<5);