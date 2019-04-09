create table Plane(id int primary key identity(1,1), [type] varchar(30), capacity int);

create table Pilot(id int primary key identity(1,1), name varchar(30));

create table Terminal(tid int primary key identity(1,1), coordinates varchar(50), airpId int foreign key references Airport(id));


create Table Airport(id int primary key identity(1,1), code varchar(30), name varchar(30), city varchar(30));

create table Flight(id int primary key identity(1,1), departure int foreign key references Airport(id), arrival int foreign key references Airport(id), planeId int foreign key references Plane(id));


 if(exists(select name from sys.tables where name='Stewardess'))
begin
	drop table Stewardess
	end
go
create table Stewardess(stid int primary key identity(1,1), [name] varchar(30), age int);



use MajorAirline
go
select * from Airport a inner join Terminal t on a.id=t.airpId where a.id=2


create table TechTeam(id int primary key identity(1,1), [name] varchar(30),size int, airpId int foreign key references Airport(id));


create table PilotPlane(pilid int foreign key references Pilot(id), plid int foreign key references Plane(id), primary key (pilid,plid));



create table StewardessFlight(stid int foreign key references Stewardess(id),flid int foreign key references Flight(id),primary key(stid,flid) );

CREATE TABLE Engineer(
id INT PRIMARY KEY IDENTITY(1,1),
[name] VARCHAR(30),
tid INT FOREIGN KEY REFERENCES TechTeam(id));

ALTER TABLE Pilot
ALTER COLUMN Name VARCHAR(30) NOT NULL;

--to test if smth exists
IF OBJECT_ID('Trial','U') IS NOT NULL drop table Trial;