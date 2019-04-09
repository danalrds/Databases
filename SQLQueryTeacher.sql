SELECT * FROM sys.tables t INNER JOIN sys.all_columns c ON  t.
SELECT * FROM sys.tables;


SELECT * FROM sys.columns;
select o.object_id, o.name, c.column_id, c.name, c.system_type_id, c.max_length, c.precision, c.scale 
from sys.objects o INNER JOIN sys.columns c 
  ON o.object_id = c.object_id
WHERE o.type = 'U'     AND o.name='Terminal'
order by o.object_id

select name, system_type_id, user_type_id 
from sys.types t
order by system_type_id

--name like '%int',...