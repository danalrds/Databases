CREATE PROC usptoVersion @version INT
AS 
DECLARE @crt INT;
DECLARE @procname VARCHAR(40);
SET @crt=(SELECT crt FROM Version);
IF (@version >7) OR (@version<0)
   BEGIN
		PRINT 'INVALID VERSION!';
		RETURN;
   END
IF (@crt<@version)
  BEGIN
	WHILE (@crt<@version)
	   BEGIN
	      SET @crt=@crt+1;	      
		  SET @procname=(SELECT [name] FROM Procedures WHERE (id=@crt));
		  EXEC @procname;	
		  UPDATE Version
	      SET crt=@crt;
		  PRINT CAST(@crt AS VARCHAR(3))+' '+ @procname;	  
	   END	
  END
ELSE
  BEGIN
    WHILE (@crt>@version)
	   BEGIN	      
	      SET @procname=(SELECT [name] FROM Reverses WHERE (id=@crt));
	      SET @crt=@crt-1;
		  EXEC @procname;	
		  UPDATE Version
	      SET crt=@crt;
		  PRINT CAST(@crt+1 AS VARCHAR(3))+' '+ @procname;	   
	   END
	   
  END