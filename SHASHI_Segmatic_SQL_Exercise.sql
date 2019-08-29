---CREATING FIRST TABEL dbo.Coursedata for the coursedata
IF EXISTS (SELECT * FROM dbo.Coursedata)
	DROP TABLE dbo.Coursedata

CREATE TABLE dbo.Coursedata (
	
	CourseName VARCHAR(50) NOT NULL,
	CourseCode VARCHAR(50) NULL,
	ModuleName VARCHAR(50) NULL,		
	CourseStartDate DATE,
	CourseEndDate DATE,
	LecturerName VARCHAR(50)
	)
GO
declare @Counter int
set @Counter = 1

While (@Counter <= 3)
BEGIN
	INSERT INTO [dbo].[Coursedata] (
		
		CourseName,
		ModuleName,
		CourseCode,
		CourseStartDate,
		CourseEndDate,
		LecturerName
		)
		--- Values are given manually for first 10 rows in this table
	VALUES
		('Mathematics', 'Stastistics', 'MAST', '2018-09-01', '2019-02-03', 'John Graunt' ),
		('Mathematics', 'Probability', 'MAPR', '2018-10-01', '2019-03-03', ' Al-Khalil' ),
		('Mathematics', 'Calculus', 'MACA', '2018-11-01', '2019-04-03', 'Isaac Newton' ),
		('Computers', 'Python', 'CSPY', '2018-09-01', '2019-02-03', 'Guido Van Rossum' ),
		('Computers', 'Sql', 'CSSQ', '2018-10-01', '2019-04-03', 'Donald D. Chamberlin' ),
		('Computers', 'Data Analysis', 'CSDA', '2018-11-01', '2019-05-03', 'Google' ),
		('Physics', 'Spectroscopy', 'CSPY', '2018-09-01', '2019-02-03', 'Athanasius Kircher ' ),
		('Physics', 'Quantum', 'PHQU', '2018-10-01', '2019-03-03', 'Albert Einstein' ),
		('Physics', 'Semiconductors', 'PHSC', '2018-01-01', '2019-04-03', 'William Shockley' ),
		('Sports', 'Rugby', 'SORU', '2018-09-01', '2019-05-03', 'Donald Trump' );
	set @Counter = @Counter + 1
END

---CREATING SECOND TABLE

IF EXISTS (SELECT * FROM dbo.GradesRough)
DROP TABLE dbo.GradesRough

CREATE TABLE dbo.GradesRough (
	Age INT  NULL,
	StudentNumber INT NOT NULL,
	Semester INT NOT NULL,
	FirstName VARCHAR(50) NULL,		
	LastName VARCHAR(50) NOT NULL,
	ModuleScore INT NOT NULL,
	CourseName VARCHAR (50) NOT NULL,
	CourseCode VARCHAR (50) NOT NULL,
	ModuleName VARCHAR (50) NOT NULL,
	CourseStartDate DATE NOT NULL,
	CourseEndDate DATE NOT NULL,
	LecturerName VARCHAR(50) NULL
	
	)
GO
--- Declaring all the values that are necessary for generating values for each iteration
declare @UpperLimitForAge int = 21
declare @LowerLimitForAge int = 17
declare @UpperLimitForStudentNumber int = 21456786
declare @LowerLimitForStudentNumber int = 17456786
declare @UpperLimitForSemester int = 5
declare @LowerLimitForSemester int = 2
declare @UpperLimitForScore int = 95
declare @LowerLimitForScore int = 45
declare @RandomAge int
declare @RandomScore int
declare @RandomStudentNumber int
declare @RandomSemester int
declare @a varchar(50)
declare @b varchar(50)
declare @C varchar(50) 
declare @D varchar(50) 
declare @coursename varchar(50)
declare @coursecode varchar(50)
declare @ModuleName varchar (50)
declare @coursestartdate DATE
declare @courseenddate DATE
declare @lecturername varchar (50)
--Insert Sample data into [dbo].[StudentGradesSegmatic]

declare @Counter int
set @Counter = 1
---Iterating for 30 times because 30 rows is a requirement
While (@Counter <= 30)
Begin
	---Values for columns Age, StudentNumber, ModuleScore and Semester are generated 
	SELECT @RandomAge = ROUND(((@UpperLimitForAge - @LowerLimitForAge)*RAND() + @LowerLimitForAge),0)
	SELECT @RandomStudentNumber = ROUND(((@UpperLimitForStudentNumber - @LowerLimitForStudentNumber)*RAND() + @LowerLimitForStudentNumber),0)
	SELECT @RandomScore = ROUND(((@UpperLimitForScore - @LowerLimitForScore)*RAND() + @LowerLimitForScore),0)
	SELECT @RandomSemester = ROUND(((@UpperLimitForSemester - @LowerLimitForSemester)*RAND() + @LowerLimitForSemester),0)
	--- Vlaues for column FirstName is generated
	SET @a = (SELECT TOP 1 FirstName 
    FROM (SELECT 'John' AS FirstName 
    UNION SELECT 'Tim' AS FirstName 
    UNION SELECT 'Laura' AS FirstName
    UNION SELECT 'Jeff' AS FirstName
	UNION SELECT 'Melissa' AS FirstName
    UNION SELECT 'Sara' AS FirstName) AS First_Names ORDER BY CHECKSUM(NEWID()))
	--- Values for column LastName is generated
	SET @b =
    (SELECT TOP 1 LastName 
    FROM (SELECT 'Johnson' AS LastName 
    UNION SELECT 'Hudson' AS LastName 
    UNION SELECT 'Jackson' AS LastName
    UNION SELECT 'Ranallo' AS LastName
    UNION SELECT 'Curry' AS LastName) AS Last_Names ORDER BY CHECKSUM(NEWID()))

	--- Values for the columns CourseName, CourseCode, ModuleName, CourseStartDate, CourseEndDate, LecturerName are generated
	--- These values are taken from the table  [dbo].[CourseData]
	SELECT TOP (1) @coursename = CourseName, @coursecode = CourseCode,
		@ModuleName = ModuleName, @coursestartdate = CourseStartDate,
		@courseenddate = CourseEndDate, @lecturername = LecturerName
	FROM [dbo].[Coursedata]
	ORDER BY CHECKSUM(NEWID())

	--- Values are inserted into the table [dbo].[GradesRough]. 
	--- THIS IS THE TABLE ASKED IN TASK 1 AND 2 OF SQL QUESTIONS
	INSERT INTO [dbo].[GradesRough] (
	Age,
	StudentNumber,
	Semester,
	FirstName,
	LastName,	
	ModuleScore,
	CourseName,
	CourseCode,
	ModuleName,
	CourseStartDate,
	CourseEndDate,
	LecturerName
	)
	VALUES (@RandomAge, @RandomStudentNumber, @RandomSemester, @a, @b, @RandomScore, @coursename,  @coursecode, 
		@ModuleName, @coursestartdate, @courseenddate, @lecturername)
	print @Counter
	set @Counter = @Counter + 1
END

--- New table is created to create columns FullName and ModuleGrade for using them in Data Visualization exercise
IF EXISTS (SELECT * FROM dbo.StudentGradesSegmatic_EDIT)
	DROP TABLE dbo.StudentGradesSegmatic_EDIT
SELECT rtrim(concat(G.FirstName + '  ',  G.LastName )) AS FullName,
	G.FirstName,
	G.LastName,
	G.StudentNumber,
	G.Age,
	G.ModuleName,
	G.CourseCode,
	G.Semester,		
	G.CourseName,	
	G.CourseStartDate,
	G.CourseEndDate,
	G.LecturerName,
	G.ModuleScore,
	CASE WHEN G.ModuleScore >= 80 
	THEN 'A'
	WHEN G.ModuleScore <= 79 AND G.ModuleScore >= 65
	THEN 'B'
	WHEN G.ModuleScore <= 64 AND G.ModuleScore >= 50
	THEN 'C'
	WHEN G.ModuleScore <= 49 AND G.ModuleScore >= 40
	THEN 'D'	
	
	END AS ModuleGrade
INTO StudentGradesSegmatic_EDIT
FROM [dbo].[GradesRough] AS G

---Printing of the resulting tables
SELECT TOP 1 * FROM dbo.Coursedata
SELECT TOP 1 * FROM dbo.GradesRough
SELECT TOP 1 * FROM dbo.StudentGradesSegmatic_EDIT
SELECT * FROM StudentGradesSegmatic_EDIT

