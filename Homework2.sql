insert into Plane([type], capacity) values 
('Airbus A32Oneo', 180),
('Boeing 777X',220),
('Comac C919',196), 
('Irkut MC-21', 160), 
('Bombardier CSeries',200);

insert into Pilot([name]) values 
('Serghei Molotov'),
 ('Vicente Fernandez');

insert into Terminal(coordinates,airpId) values 
('46° 46'' 13.5804'' N 23° 35'' 29.1228'' E',1), 
('41° 16'' 13.4'' S 18° 45'' 4.28'' E',3), 
('35° 16'' 13.4'' N 38° 58'' 4.28'' V',2),
 ('25° 26'' 13.4'' S 38° 38'' 4.28'' E',5), 
('30° 16'' 13.4'' N 49° 18'' 4.28'' V',2);

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
(4,3, 1);

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

insert into PilotPlane(pilid,plid) values 
(1,5), 
(2,5), 
(1,3), 
(2,4);

insert into StewardessFlight(stid, flid) values 
(1,4), 
(2,3), 
(1,2), 
(2,4);

INSERT INTO Pilot([name]) values
('Simon Gasquet'), 
(NULL);

INSERT INTO PilotPlane(pilid,plid) VALUES
(1,6),(2,7);

UPDATE Pilot
SET salary=salary+400 
WHERE (salary<1000) AND name IS NOT NULL;

UPDATE Flight
SET arrival=2
WHERE (departure<>2) AND (arrival BETWEEN 4 AND 7);

DELETE FROM Pilot
WHERE NOT(salary<=3000) AND name IN('Lorenzo');
  SELECT *FROM Pilot;

--In order to gain performance, any team with <90 members will receive another 20, and also all the teams
--from airp 5 which is new and needs more members
UPDATE TechTeam
SET size=size+20
WHERE ((id>=2) OR (size>90) OR (airpId=5)) AND (name LIKE 'Team%');
SELECT *FROM TechTeam;


--The director wants to see all the employees
SELECT name FROM Pilot
UNION ALL
SELECT name FROM Stewardess
UNION ALL
SELECT name FROM Engineer;

--The manager wants to see the stewardesses younger than 20  and older than 30 
SELECT name, age FROM Stewardess 
WHERE (age<20) OR (age>30);

--all the airports id that are departure and destination 
SELECT departure FROM Flight
INTERSECT
SELECT arrival  FROM Flight
WHERE arrival>2;

--see the names of techteams working in airports 4 and 5
SELECT name FROM TechTeam
WHERE airpId IN (4,5);

--see the stewardesses that have the age > 22 don't attend any of the flights 4 and 5
SELECT id FROM Stewardess
WHERE age >22
EXCEPT
SELECT stid FROM StewardessFlight
WHERE flid  IN (4,5);



UPDATE TechTeam
SET name='Team3' 
WHERE size=185;

INSERT INTO Engineer(name,tid) 
VALUES ('Morellato',1), ('Gianny',3);

SELECT t.name,size FROM 
TechTeam t INNER JOIN Engineer e
ON t.id=e.tid; 



SELECT type,capacity,departure,arrival FROM 
Plane p FULL JOIN Flight f
ON p.id=f.planeId AND p.capacity>160;

SELECT t.name,a.name FROM
TechTeam t LEFT JOIN Airport a
ON t.airpId=a.id 
INNER JOIN Terminal ter 
ON a.id=ter.airpId; 

SELECT s.name, a.name,a.city 
FROM Stewardess s INNER JOIN StewardessFlight sf 
ON s.id=sf.stid RIGHT JOIN Flight f 
ON f.id=sf.flid INNER JOIN Airport a 
ON a.id=f.arrival;


SELECT coordinates FROM Terminal 
WHERE airpId  IN (SELECT id FROM Airport WHERE city LIKE 'B___%' );

SELECT [type] FROM Plane
WHERE capacity IN (200,220);

SELECT [type] FROM Plane pl
WHERE EXISTS(
	SELECT planeId FROM Flight f WHERE pl.id=f.planeId);

SELECT [name] FROM TechTeam t
WHERE EXISTS(
			SELECT e.tid FROM Engineer e
			WHERE e.tid=t.id AND e.name='Gianny');

SELECT AVG(salary) AS Average FROM(
			SELECT salary FROM Pilot WHERE salary>800) AS salary;

SELECT AVG(age) AS Average FROM(
			SELECT age FROM Stewardess	WHERE age>21) AS age; 


SELECT s.nationality, MIN(s.age) AS themin FROM Stewardess s
WHERE (s.age>21)
GROUP BY s.nationality
HAVING COUNT(*)>1
ORDER BY themin;

SELECT MAX(age) as maxage, nationality FROM Stewardess
GROUP BY nationality
ORDER BY maxage, nationality DESC;

SELECT AVG(salary) AS the_sum FROM Pilot p
WHERE degree>2
GROUP BY nationality
HAVING SUM(SALARY)< (SELECT MAX(salary)*5 FROM Pilot);