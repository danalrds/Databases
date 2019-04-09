select * from Stewardess;
select * from StewardessFlight;
SELECT DISTINCT name FROM Stewardess s, StewardessFlight sf
WHERE (s.id=sf.stid);
SELECT DISTINCT name, age FROM Stewardess, StewardessFlight 
WHERE (Stewardess.id=StewardessFlight.stid)  and (age<28);
INSERT INTO Stewardess(name,age) values ('Mar',27), ('Cony',25);
SELECT DISTINCT name, age, age+2 AS plusage FROM Stewardess 
WHERE (name LIKE 'L___%') OR (name LIKE 'M___%');
SELECT COUNT (*) FROM Stewardess;
SELECT AVG (p.salary) FROM Pilot p;
SELECT AVG (s.age) FROM Stewardess s 
WHERE (s.name LIKE 'L%'); 
SELECT COUNT(DISTINCT s.age)
FROM Stewardess s
WHERE (s.name LIKE 'M__%');
SELECT name FROM Stewardess s
WHERE s.age=ANY(SELECT MAX(s.age) FROM Stewardess s);