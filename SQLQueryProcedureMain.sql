CREATE PROC usptoVersion @version INT
AS 
DECLARE @crt INT;
DECLARE @procname VARCHAR(30);
SET @crt=(SELECT crt FROM Version);
IF (@crt<@version)
  BEGIN
	WHILE (@crt<@version)
	   BEGIN
	      SET @crt=@crt+1;
	      SET @procname='version_'+CAST(@crt AS VARCHAR(3));
		  EXEC @procname;	
		  PRINT @procname;	  
	   END
	UPDATE Version
	SET crt=@version;
  END
ELSE
  BEGIN
    WHILE (@crt>@version)
	   BEGIN	      
	      SET @procname='reverse_'+CAST(@crt AS VARCHAR(3));
		  SET @crt=@crt-1;
		  EXEC @procname;	
		  PRINT @procname;	  
	   END
	   UPDATE Version
	   SET crt=@version;
  END