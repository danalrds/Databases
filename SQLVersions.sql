--A)
--modifyColumnType
CREATE PROC modifyColumnType AS
ALTER TABLE Engineer
ALTER COLUMN name  VARCHAR(40) NOT NULL;

--reversed operation
--modifyColumnTypeReverse
CREATE PROC modifyColumnTypeReverse AS
ALTER TABLE Engineer
ALTER COLUMN name  VARCHAR(30) NOT NULL;

--B)
--addColumn 
CREATE PROC addColumn AS
ALTER TABLE TechTeam
ADD rewards VARCHAR(50);
--reversed
--removeColumn
CREATE PROC  removeColumn AS
ALTER TABLE TechTeam
DROP COLUMN rewards;

--C) FIRST
--addConstraint 
CREATE PROC addDefaultConstraint AS
ALTER TABLE Engineer
ADD CONSTRAINT df_engineer
DEFAULT 'empty' FOR[name];
--reversed
--removeConstraint
CREATE PROC removeDefaultConstraint AS
ALTER TABLE Engineer
DROP CONSTRAINT df_engineer;

--D)

--removePrimaryKey
CREATE PROC  removePrimaryKey AS
ALTER TABLE Engineer
DROP CONSTRAINT [PK__Engineer__3213E83FF967A499];
--reversed 
--addPrimaryKey
CREATE PROC addPrimaryKey AS
ALTER TABLE Engineer
ADD CONSTRAINT [PK__Engineer__3213E83FF967A499]
PRIMARY KEY (id);


--E)
--removeCandidateKey
CREATE PROC removeCandidateKey AS
ALTER TABLE Airport
DROP CONSTRAINT [CT_Unique];
--
--addCandidateKey
CREATE PROC addCandidateKey AS
ALTER TABLE Airport
ADD CONSTRAINT [CT_Unique] UNIQUE(code);

--F)
--remove ForeignKey
CREATE PROC removeForeignKey AS
ALTER TABLE TechTeam
DROP CONSTRAINT [FK__TechTeam__airpId__693CA210];

--reversed
--addForeignKey
CREATE PROC  addForeignKey AS
ALTER TABLE TechTeam
ADD CONSTRAINT [FK__TechTeam__airpId__693CA210] 
FOREIGN KEY (airpId) REFERENCES Airport(id) ;


--G)
--addTable
CREATE PROC createTable AS
CREATE TABLE Continent(id INT PRIMARY KEY IDENTITY(1,1), name VARCHAR(30), surface INT);
--reversed
--removeTable
CREATE PROC removeTable AS
DROP TABLE Continent;

