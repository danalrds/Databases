/*
Select the names of all stewardesses who flew at least 2 times with any of the pilots who have the highest rank. 
*/
SELECT s.name 
FROM Stewardess s
WHERE s.id IN( 
	SELECT sf.stid 
	FROM StewardessFlight sf 
	INNER JOIN
	(SELECT DISTINCT f.id AS flight_id 
		FROM Flight f
		INNER JOIN Plane p 
		ON p.id=f.planeId
		INNER JOIN PilotPlane pp
		ON pp.plid=p.id 
		INNER JOIN Pilot pilot
		ON pilot.id=pp.pilid
		WHERE pilot.degree=
			(SELECT MAX(degree) FROM Pilot)) AS flight_table
	ON sf.flid=flight_table.flight_id
	GROUP BY sf.stid
	HAVING COUNT(*)>=2) ;


--SELECT * FROM Flight;