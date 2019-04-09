CREATE PROC genericInsert @table VARCHAR(30)
AS
	BEGIN
	    DECLARE @table VARCHAR(30);
	    SET @table='Terminal';
		select o.object_id, o.name,c.name
		from sys.objects o INNER JOIN sys.columns c 
		ON o.object_id = c.object_id
		WHERE o.type = 'U'  AND o.name=@table
		order by o.object_id; 
	END