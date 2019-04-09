CREATE TABLE yuhu(id INT PRIMARY KEY IDENTITY(1,1),
				  name VARCHAR(30));
INSERT yuhu VALUES ('John'),('Peter');
SELECT * FROM yuhu;
DROP TABLE yuhu;

CREATE TABLE yuhu(id INT PRIMARY KEY,
				  name VARCHAR(30));
INSERT yuhu VALUES (3,'John'),(1,'Peter');
SELECT * FROM yuhu;
INSERT yuhu VALUES (0,'Millan');
SELECT * FROM yuhu;
DROP INDEX yuhu.PK__yuhu__3213E83FDBF35BD4; --error

DROP TABLE yuhu;
CREATE TABLE yuhu(id INT,
				  name VARCHAR(30));
INSERT yuhu VALUES (3,'John'),(1,'Peter');
SELECT * FROM yuhu;
CREATE CLUSTERED INDEX cl_idx ON yuhu(id);
SELECT * FROM yuhu;

DROP INDEX yuhu.cl_idx;
SELECT * FROM yuhu;
INSERT yuhu VALUES (0,'Millan');
SELECT * FROM yuhu;
CREATE CLUSTERED INDEX cl_idx ON yuhu(id);
SELECT * FROM yuhu;

DROP INDEX yuhu.cl_idx;
DELETE FROM yuhu 
WHERE id=0;
SELECT * FROM yuhu;
CREATE NONCLUSTERED INDEX noncl_idx ON yuhu(id);
SELECT * FROM yuhu;
INSERT yuhu VALUES (0,'Millan');
SELECT * FROM yuhu;
DROP INDEX yuhu.noncl_idx;
SELECT * FROM yuhu;
CREATE NONCLUSTERED INDEX noncl_idx ON yuhu(name);
INSERT yuhu VALUES (2,'Arno');
SELECT * FROM yuhu;

SELECT * FROM yuhu y
WHERE y.id> ALL(SELECT id FROM yuhu WHERE id<>y.id);




CREATE TABLE y(nr INT);
INSERT y VALUES (2),(null);
SELECT AVG(nr) FROM y;