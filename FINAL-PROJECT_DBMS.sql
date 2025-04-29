use DBMSfinalproject;

                                                -- CREATE TABLES - STARTED --
CREATE TABLE University (
		UniversityId		VARCHAR(20)	PRIMARY KEY,
		UniversityName		VARCHAR(100)	NOT NULL
	);

CREATE TABLE Department (
		DepartmentId	VARCHAR(20)	PRIMARY KEY,
		DepartmentName	VARCHAR(100)	NOT NULL
	);

CREATE TABLE StudentStatus (
		StudentStatusId	INT		PRIMARY KEY IDENTITY(1,1),
		StudentStatus	VARCHAR(50)	NOT NULL
	);

CREATE TABLE StudentType (
		StudentTypeId	INT		PRIMARY KEY IDENTITY(1,1),
		StudentType		VARCHAR(20)
	);

CREATE TABLE States (
		StateId			VARCHAR(20)	PRIMARY KEY,
		StateName		VARCHAR(100)	NOT NULL
	);

CREATE TABLE Country (
		CountryId			VARCHAR(20)	PRIMARY KEY,
		CountryName			VARCHAR(100)	NOT NULL
	);

CREATE TABLE CourseLevel (
		LevelId			INT		PRIMARY KEY IDENTITY(1,1),
		LevelNum		VARCHAR(20)		NOT NULL
	);

CREATE TABLE Gender (
		GenderId		INT		PRIMARY KEY IDENTITY(1,1),
		GenderType		VARCHAR(20)	NOT NULL
	);

CREATE TABLE Race (
		RaceId			INT		PRIMARY KEY IDENTITY(1,1),
		RaceType		VARCHAR(20)	NOT NULL
	);

CREATE TABLE EnrollmentStatus (
		EnrollmentStatusId		INT		PRIMARY KEY IDENTITY(1,1),
		StatusType				VARCHAR(20)	NOT NULL
	);

CREATE TABLE SemesterText (
		SemesterTextId			INT		PRIMARY KEY IDENTITY(1,1),
		SemesterType			VARCHAR(20)	NOT NULL
	);

CREATE TABLE ProjectorInfo (
		ProjectorId			INT		PRIMARY KEY IDENTITY(1,1),
		ProjectorText		VARCHAR(20)	NOT NULL
	);

CREATE TABLE Buildings (
		BuildingId			INT		PRIMARY KEY IDENTITY(1,1),
		BuildingName		VARCHAR(20)	NOT NULL
	);


CREATE TABLE JobTypeDetail (
		JobTypeDetailId		INT		PRIMARY KEY IDENTITY(1,1),
		JobDetail			VARCHAR(100)
	);

CREATE TABLE BenefitType (
		BenefitTypeId	INT		PRIMARY KEY IDENTITY(1,1),
		Benefit			VARCHAR(20)
	);

CREATE TABLE BenefitCoverage (
		BenefitCoverageId	INT		PRIMARY KEY IDENTITY(1,1),
		Coverage			VARCHAR(70)
	);

CREATE TABLE Addresses (
		AddressId	INT	PRIMARY KEY IDENTITY(1,1),
		Street1		VARCHAR(100) NOT NULL,
		Street2		VARCHAR(100),
		City		VARCHAR(50) NOT NULL,
		StateName	VARCHAR(20) FOREIGN KEY REFERENCES States(StateId) NOT NULL,
		ZIP			VARCHAR(20) NOT NULL,
		Country     VARCHAR(20) FOREIGN KEY REFERENCES Country(CountryId)
);

CREATE TABLE MajorMinor (
		MajorMinorId	INT	PRIMARY KEY IDENTITY(1,1),
		UniversityId		VARCHAR(20) FOREIGN KEY REFERENCES University(UniversityId) NOT NULL,
		StudyTitle		VARCHAR(50)
);

CREATE TABLE PersonInfo (
		PersonId		INT	PRIMARY KEY IDENTITY(1,1),
		NTID			VARCHAR(20),
		FirstName		VARCHAR(50) NOT NULL,
		LastName		VARCHAR(50) NOT NULL,
		MiddleName		VARCHAR(50),
		PasswordText	VARCHAR(50),
		GenderId		INT FOREIGN KEY REFERENCES Gender(GenderId) NOT NULL,
		RaceId			INT FOREIGN KEY REFERENCES Race(RaceId) NOT NULL,
		DOB				VARCHAR(20) NOT NULL,
		SSN				VARCHAR(20),
		HomeAddressId	INT FOREIGN KEY REFERENCES Addresses(AddressId) NOT NULL,
		MailingAddressId	INT FOREIGN KEY REFERENCES Addresses(AddressId),
		CellPhone		VARCHAR(20),
		Email			VARCHAR(100) NOT NULL
);

CREATE TABLE StudentInfo (
		StudentId		INT	PRIMARY KEY IDENTITY(1,1),
		StudentTypeId	INT FOREIGN KEY REFERENCES StudentType(StudentTypeId) NOT NULL,
		StudentStatusId	INT FOREIGN KEY REFERENCES StudentStatus(StudentStatusId) NOT NULL,
		IsGraduate		BIT NOT NULL, --Note: 0 is false and 1 is true
		FOREIGN KEY(StudentId) REFERENCES PersonInfo(PersonId)
);

CREATE TABLE StudentAreaOfStudy (
		StudentId		INT	NOT NULL,
		AreaId			INT,
		IsMajor			BIT NOT NULL, --Note: 0 is false and 1 is true
		FOREIGN KEY(StudentId) REFERENCES StudentInfo(StudentId),
		FOREIGN KEY(AreaId) REFERENCES MajorMinor(MajorMinorId),
		PRIMARY KEY (StudentId, AreaId)
);

CREATE TABLE EmployeeInfo (
		EmployeeId		INT	PRIMARY KEY NOT NULL,
		AnnualSalary	INT NOT NULL,
		FOREIGN KEY(EmployeeId) REFERENCES PersonInfo(PersonId)
);

CREATE TABLE EmployeeBenefits (
		EmployeeId		INT NOT NULL,
		BenefitTypeId	INT NOT NULL,
		BenefitCoverId	INT NOT NULL,
		EmployeePremium INT NOT NULL,
		EmployerPremium INT NOT NULL,
		PRIMARY KEY (EmployeeId, BenefitTypeId, BenefitCoverId),
		FOREIGN KEY(EmployeeId) REFERENCES EmployeeInfo(EmployeeId),
		FOREIGN KEY(BenefitTypeId) REFERENCES BenefitType(BenefitTypeId),
		FOREIGN KEY(BenefitCoverId) REFERENCES BenefitCoverage(BenefitCoverageId)
);

CREATE TABLE JobInfo (
		JobId		INT PRIMARY KEY IDENTITY(1,1),
		JobTitle	VARCHAR(50) NOT NULL,
		JobDescription VARCHAR(100), 
		JobRequirements VARCHAR(100) NOT NULL,
		MinPay		INT NOT NULL,
		MaxPay		INT NOT NULL,
		IsFaculty	BIT NOT NULL, --Note: 0 is false and 1 is true
		JobTypeDetailId INT FOREIGN KEY REFERENCES JobTypeDetail(JobTypeDetailId) NOT NULL
);

CREATE TABLE EmployeeJobs (
		JobId		INT NOT NULL,
		EmployeeId	INT NOT NULL,
		PRIMARY KEY (JobId, EmployeeId),
		FOREIGN KEY (JobId) REFERENCES JobInfo(JobId),
		FOREIGN KEY (EmployeeId) REFERENCES EmployeeInfo(EmployeeId)
);

CREATE TABLE SemesterInfo (
		SemesterId	INT PRIMARY KEY IDENTITY(1,1),
		SemesterTextId	INT FOREIGN KEY REFERENCES SemesterText(SemesterTextId) NOT NULL,
		YearInfo	INT NOT NULL,
		FirstDay	VARCHAR(20) NOT NULL,
		LastDay		VARCHAR(20) NOT NULL
);

CREATE TABLE CourseCatalog (
		CourseCode		VARCHAR(5) NOT NULL,
		CourseNumber	INT NOT NULL,
		CourseTitle		VARCHAR(50) NOT NULL,
		CourseDesc		VARCHAR(100),
		DepartmentId	VARCHAR(20) FOREIGN KEY REFERENCES Department(DepartmentId) NOT NULL,
		CourseLevelId	INT FOREIGN KEY REFERENCES CourseLevel(LevelId) NOT NULL,
		CreditHours		INT NOT NULL,
		PRIMARY KEY (CourseCode, CourseNumber)
);

CREATE TABLE Prerequisites (
		PrereqId		INT PRIMARY KEY IDENTITY(1,1),
		ParentCode		VARCHAR(5) NOT NULL,
		ParentNumber	INT NOT NULL,
		ChildCode		VARCHAR(5) NOT NULL,
		ChildNumber		INT NOT NULL,
		FOREIGN KEY (ParentCode, ParentNumber) REFERENCES CourseCatalog(CourseCode, CourseNumber),
		FOREIGN KEY (ChildCode, ChildNumber) REFERENCES CourseCatalog(CourseCode, CourseNumber)
);

CREATE TABLE ClassRoom (
		ClassRoomId		INT PRIMARY KEY IDENTITY(1,1),
		BuildingId		INT FOREIGN KEY REFERENCES Buildings(BuildingId) NOT NULL,
		LevelNumber		INT NOT NULL,
		RoomNumber		INT NOT NULL,
		ProjectorId		INT FOREIGN KEY REFERENCES ProjectorInfo(ProjectorId),
		WhiteBoardCount	INT NOT NULL,
		MaximumSeating	INT NOT NULL,
		TypeIndicator	VARCHAR(20)
);

CREATE TABLE CourseSchedule (
		CRN				INT PRIMARY KEY,
		CourseCode		VARCHAR(5) NOT NULL,
		CourseNumber	INT NOT NULL,
		Section			VARCHAR(10) NOT NULL,
		SemesterId		INT FOREIGN KEY REFERENCES SemesterInfo(SemesterId) NOT NULL,
		LocationId		INT FOREIGN KEY REFERENCES ClassRoom(ClassRoomId),
		FOREIGN KEY (CourseCode, CourseNumber) REFERENCES CourseCatalog(CourseCode, CourseNumber)
);

CREATE TABLE CourseEnrollment (

		StudentId		INT NOT NULL,
		CRN				INT NOT NULL,
		EnrollmentStatusId	INT FOREIGN KEY REFERENCES EnrollmentStatus(EnrollmentStatusId) NOT NULL,
		MidtermGrade	INT,
		FinalGrade		INT,
		PRIMARY KEY (StudentId, CRN),
		FOREIGN KEY (StudentId) REFERENCES StudentInfo(StudentId),
		FOREIGN KEY (CRN) REFERENCES CourseSchedule(CRN),
);

CREATE TABLE CourseDailySchedule (

		DailyId		INT PRIMARY KEY IDENTITY(1,1),
		CRN			INT FOREIGN KEY REFERENCES CourseSchedule(CRN) NOT NULL,
		DayOfTheWeek	VARCHAR(10),
		StartHour		INT, --Chose INT to express time in military time(24 hour clock)
		StartMinute		INT,
		EndHour			INT,
		EndMinute		INT
);

CREATE TABLE EmployeeCourse (

		CRN			INT NOT NULL,
		EmployeeId	INT NOT NULL,
		PRIMARY KEY (CRN, EmployeeId),
		FOREIGN KEY (CRN) REFERENCES CourseSchedule(CRN),
		FOREIGN KEY (EmployeeId) REFERENCES EmployeeInfo(EmployeeId)
);


                                                    -- INSETIONS - STARTED --

INSERT INTO University VALUES('1 Eng','Engineering'),
							('2 arc','Architecture'), 
							('3 as','Arts & Science'), 
							('4 ba', 'Business'), 
							('5 new','NewHouse'), 
							('6 it','itSchool');


INSERT INTO Department VALUES	('1 adv','Advertising'), 
								('2 acc','Accounting'), 
								('3 art','Art'), 
								('4 its','Information Technology'), 
								('5 arc','Architecture'), 
								('6 cs','Computer Science');


INSERT INTO StudentStatus VALUES('active'),
								('suspended'),
								('inactive');


INSERT INTO StudentType VALUES	('New Freshmen'),
								('Continue'),
								('Transfer'),
								('Re-Admitted'),
								('New Graduate'),
								('Continue Graduate');


INSERT INTO States VALUES	('NY','New York'),
							('CA','California'),
							('VT','Vermont'),
							('OH','Ohio'),
							('NJ','New Jersey'),
							('FL','Florida');


INSERT INTO Country VALUES	('USA','United States of America'),
							('CHN','China'),
							('MEX','Mexico'),
							('SKR','South Korea'),
							('CAN','Canada'),
							('GER','Germany');


INSERT INTO CourseLevel VALUES	('Undergraduate'),
								('Graduate'),
								('Doctorate'),
								('Super-Genius');


INSERT INTO Gender VALUES	('Male'),
							('Female'),
							('Transgender'),
							('Pan');


INSERT INTO Race VALUES	('White'),
						('Black'),
						('Hispanic'),
						('Asian'),
						('Native American');


INSERT INTO EnrollmentStatus VALUES	('Full-Time'),
									('Half-Time'),
									('Part-Time');


INSERT INTO SemesterText VALUES	('Fall'),
								('Spring'),
								('SS1'),
								('SS2'),
								('Combined SS');


INSERT INTO ProjectorInfo VALUES('Pojector1'),
								('Projector2'),
								('Projector3'),
								('Projector4'),
								('Projector5');


INSERT INTO Buildings VALUES	('Link Hall'),
								('Carnegie Library'),
								('Bird Library'),
								('Lyman Hall'),
								('Sci-Tech');


INSERT INTO JobTypeDetail VALUES('Lecturer'),
								('Assist. Prof.'),
								('Assoc. Prof.'),
								('Full Prof.'),
								('Staff');


INSERT INTO BenefitType VALUES('Self Only'),
								('With Children'),
								('With Spouse'),
								('With Family');


INSERT INTO BenefitCoverage VALUES	('Health'),
									('Vision'),
									('Dental'),
									('Emergency');


INSERT INTO Addresses VALUES('123 Sesame Street', NULL, 'Barney City','NY', '12345', 'USA' ),
							('456 University Place', '100 Comstock Ave.', 'Syracuse','NY', '13210', 'USA' ),
							('201 Ernie Stree', NULL, 'Columbus','OH', '99999', 'USA' ),
							('12 Gangnam Street', NULL, 'Seoul','NJ', '12345', 'SKR' ),
							('765 Where Ave.', 'Waldo Street', 'Sienna','FL', '12345', 'CHN' ),
							('432 Space Ave.', NULL, 'Los Angeles','CA', '12332', 'USA' );


INSERT INTO MajorMinor VALUES	('1 Eng', 'Computer Science'),
								('2 arc', 'Accounting'),
								('3 as', 'Communications'),
								('4 ba','Civil Engineering'),
								( '5 new','Drawing'),
								('6 it','Information Technology');


INSERT INTO PersonInfo VALUES	('jsy101', 'Jaesuk', 'Yoo', NULL, 'grasshoppa99', 1, 1, '03-28-1965', '123-01-4567', 1, NULL, '1002561111', 'grasshopper123@gmail.com'),
								('kjk102', 'Jong Kook', 'Kim', NULL, 'sparta98', 1, 2, '01-01-1970', '163-56-3278', 2, 4, '1002561112', 'spartakjk123@gmail.com'),
								('sjh103', 'Jihyo', 'Song', NULL, 'blank97', 2, 2, '07-03-1975', '934-23-7654', 3, NULL, '1002561113', 'mongji123@gmail.com'),
								('lks104', 'Kwang Soo', 'Lee', NULL, 'girafe96', 1, 4, '12-12-1978', '163-14-9534', 4, NULL, '1002561114', 'girafe123@gmail.com'),
								('hdh105', 'Dong Hoon', 'Ha', NULL, 'pororo95', 1, 4, '03-11-1970', '146-12-7467', 5, NULL, '1002561115', 'pororo123@gmail.com'),
								('kg106', 'Gary', 'Kang', NULL, 'monday94', 1, 3, '08-21-1973', '568-14-9246', 6, NULL, '1002561116', 'mondaycouple123@gmail.com'),
								('jsj107', 'Suk', 'Ji', 'Jin', 'impala93', 1, 4, '06-02-1960', '193-15-3209', 4, 1, '1002561117', 'impala123@gmail.com'),
								('khn108', 'Hanna', 'Kang', NULL, 'hanna92', 2, 4, '06-12-1969', '133-15-6509', 4, 1, '1002561118', 'hanna123@gmail.com'),
								('khd109', 'Ho', 'Kang', 'Dong', 'piggy91', 1, 4, '04-02-1960', '673-45-3609', 4, 1, '1002561119', 'piggy123@gmail.com');


INSERT INTO StudentInfo VALUES	(1,1, 0),
								(2,1, 0),
								(3,2, 0),
								(4,1, 1),
								(5,3, 1),
								(6,2, 1);


INSERT INTO StudentAreaOfStudy VALUES(1,1,1),
									(2,2,1),
									(3,3,1),
									(4,4,1),
									(5,5,1),
									(6,6,1);


INSERT INTO EmployeeInfo VALUES	(6, 65000),
								(7, 70000),
								(8, 75000),
								(9, 80000);


INSERT INTO EmployeeBenefits VALUES	(6,1,1,1100, 5000),
								(7,2,2,2000, 7500),
								(8,3,3,5340, 11823),
								(9,4,4, 100, 1000);


INSERT INTO JobInfo VALUES	('Dean of Engineering', 'Oversees engineer curriculum and teaches courses', 'PhD in any engineering field and 5+ years of experience',80000, 150000, 1, 4 ),
							('CS Professor', 'Teaches CS courses', 'PhD in any engineering field and 5+ years of experience',60000, 100000, 1, 4 ),
							('Market Analyst', 'Research markets and teach part-time', 'PhD in education or 5+ years of market experience',50000, 90000, 1, 2 ),
							('Career Counselor', 'Guides students in their careers', '5+ years of counseling experience and BA in Education',60000, 110000, 1, 5 );


INSERT INTO EmployeeJobs VALUES	(1,6),
								(2,7),
								(3,8),
								(4,9);


INSERT INTO SemesterInfo VALUES	(1,2018, 'August 28th', 'December 12th'),
								(2,2019, 'January 16th', 'May 9th'),
								(3,2019, 'May 12th', 'June 12th'),
								(4,2019, 'June 16', 'August 16th'),
								(5,2019, 'May 20th', 'August 16th');


INSERT INTO CourseCatalog VALUES('CIS', 102, 'Intro to Programming', 'Basics of coding and oop principles using Java', '1 adv', 1, 4),
								('ADV', 488, 'Entrepreneurial Marketing', 'Business management and marketing principles to succeed in starting a business', '2 acc', 2, 3),
								('IST', 344, 'Information Reporting', 'Lean how to present data and improve public speaking', '3 art', 1, 3),
								('CIS', 544, 'Object Oriented C++', 'Learn C++ syntax and oop principles', '4 its', 1, 3),
								('ADV', 788, 'CEO Training', 'Learn how to sucessfuly advertise and market to consumers and clients', '5 arc', 4, 4),
								('ART', 101, 'Intro to Drawing', 'Learn how to do basic sketches and familiarize students with proper terminology', '6 cs', 1, 4);


INSERT INTO Prerequisites VALUES('CIS', 102, 'CIS', 102),
								('ADV', 488, 'ADV', 488),
								('IST', 344, 'IST', 344),
								('CIS', 544, 'CIS', 544),
								('ADV',788,'ADV',788),
								('ART',101,'ART',101);


INSERT INTO ClassRoom VALUES(1, 1, 100, 1, 3, 50, 'ClassRoom'),
							(2, 2, 214, 2, 2, 46, 'LibraryRoom'),
							(3, 3, 302, 3, 4, 15, 'Tech-Team Room'),
							(4, 4, 410, 4, 2, 48, 'Lecture Hall'),
							(5, 5, 500, 5, 1, 35, 'Computer Lab');


INSERT INTO CourseSchedule VALUES	(900805, 'CIS', 102, 'M100', 1, 1),
									(900815, 'ADV', 488, 'M100', 1, 2),
									(900825, 'IST', 344, 'M100', 5, 5),
									(900835, 'CIS', 544, 'M100', 2, 1),
									(900845, 'ADV', 788, 'M100', 2, 2),
									(900855, 'ART', 101, 'M100', 3, 3);


INSERT INTO CourseEnrollment VALUES	(1, 900805, 1, 98, 93),
									(2, 900815, 1, 90, 89),
									(3, 900825, 1, 85, 91),
									(1, 900835, 1, 98, 98),
									(2, 900845, 1, 73, 90),
									(4, 900855, 1, 80, 95);


INSERT INTO CourseDailySchedule VALUES	(900805, 'Mon-Wed', 9, 30, 11, 35),
										(900815, 'T-TH', 9, 30, 11, 35),
										(900825, 'Mon-Wed', 11, 45, 1, 05),
										(900835, 'Mon-Wed', 8, 00, 9, 20),
										(900845, 'Wed-Fri', 15, 45, 17, 05),
										(900855, 'Mon-Fri', 15, 45, 17, 05);


INSERT INTO EmployeeCourse VALUES	(900805, 6),
									(900815, 6),
									(900825, 8),
									(900835, 7),
									(900845, 8),
									(900855, 8);



                                                       -- QUERIES - STARTED --

SELECT * FROM University;
SELECT * FROM Department;
SELECT * FROM StudentStatus;
SELECT * FROM StudentType;
SELECT * FROM States;
SELECT * FROM Country;
SELECT * FROM CourseLevel;
SELECT * FROM Gender;
SELECT * FROM Race;
SELECT * FROM EnrollmentStatus;
SELECT * FROM SemesterText;
SELECT * FROM ProjectorInfo;
SELECT * FROM Buildings;
SELECT * FROM JobTypeDetail;
SELECT * FROM BenefitType;
SELECT * FROM BenefitCoverage;
SELECT * FROM Addresses;
SELECT * FROM MajorMinor;
SELECT * FROM PersonInfo;
SELECT * FROM StudentInfo;
SELECT * FROM StudentAreaOfStudy;
SELECT * FROM EmployeeInfo;
SELECT * FROM EmployeeBenefits;
SELECT * FROM JobInfo;
SELECT * FROM EmployeeJobs;
SELECT * FROM SemesterInfo;
SELECT * FROM CourseCatalog;
SELECT * FROM Prerequisites;
SELECT * FROM ClassRoom;
SELECT * FROM CourseSchedule;
SELECT * FROM CourseEnrollment;
SELECT * FROM CourseDailySchedule;
SELECT * FROM EmployeeCourse;

Select * From
PersonInfo
Where FirstName Like 'j%';

Select * From 
PersonInfo
Where LastName Like '%g';


Select Distinct Country
From Addresses;

Select Distinct CourseTitle
From CourseCatalog;


Select FirstName
From PersonInfo
Where PersonId=1 And GenderId=1;

Select *,*
From PersonInfo ,ClassRoom
Where PersonId=1 OR ClassRoomId=1

Select StudentId
From CourseEnrollment
UNION
Select PersonId
From PersonInfo;

Select MIN(AnnualSalary) As Salary
from EmployeeInfo;

Select Max(AnnualSalary) As Salary
From EmployeeInfo;

Select AVG(AnnualSalary) As Salary
From EmployeeInfo;

Select Room.ClassRoomId,Room.MaximumSeating
From ClassRoom Room
Inner Join Buildings Build ON Room.BuildingId=Build.BuildingId;

Select Emp.*
From EmployeeInfo Emp
Left Join EmployeeCourse Cour ON Cour.EmployeeId= Emp.EmployeeId;

Select CDS.*
From CourseDailySchedule CDS
Right Join CourseEnrollment CE ON CDS.CRN=CE.CRN

Select Sem.SemesterId, Sem.YearInfo, CourS.CourseNumber, CourS.Section
From SemesterInfo Sem
full outer join CourseSchedule CourS on Sem.SemesterId=Cours.SemesterId; 

select CourS.CourseCode, CourS.Section, CourDS.DayOfTheWeek, CourDS.StartMinute
from CourseSchedule CourS, CourseDailySchedule CourDS
Where CourS.CRN <> CourDS.CRN;

CREATE VIEW Benefits AS 
SELECT E.EmployeeId, P.FirstName, P.LastName, BT.BenefitTypeId, BC.BenefitCoverageId, E.EmployerPremium, E.EmployeePremium
FROM EmployeeBenefits E JOIN PersonInfo P ON  P.PersonId = E.EmployeeId
JOIN BenefitType BT ON BT.BenefitTypeId = E.BenefitTypeId JOIN BenefitCoverage BC ON BC.BenefitCoverageId = E.BenefitCoverId;
SELECT * from Benefits

                                                   -- FUNCTION - STARTED --

CREATE FUNCTION [dbo].[GetAverageCourseGrade] (@CRN AS INT) 
	RETURNS FLOAT AS
		BEGIN
			DECLARE @result FLOAT, @count INT;
			SELECT @count = COUNT(CRN) FROM CourseEnrollment WHERE CRN = @CRN;
		IF @count = 0
			BEGIN 
				SET @result = 0.00
			END

		ELSE
			BEGIN
				SELECT @result =  AVG(FinalGrade) FROM CourseEnrollment WHERE CRN = @CRN
			END

		RETURN @result
	END

GO
select * from CourseEnrollment;
GO
select [dbo].[GetAverageCourseGrade](900845);


                                                  -- PROCEDURES - STARTED --

												           -- 1 --
CREATE PROCEDURE CheckMinCap (@CRN AS INT,@MinCap AS INT)
	AS
	DECLARE @TotalCap INT
	DECLARE @CheckCRN INT
	SELECT @TotalCap = (SELECT COUNT(*) FROM CourseEnrollment WHERE @CRN = CRN)
	SELECT @CheckCRN = (SELECT MAX(CRN) FROM CourseEnrollment WHERE @CRN = CRN )
	
	IF @CheckCRN IS NULL
		BEGIN
		Print 'CRN does not exist'
		END

	ELSE IF @TotalCap >= @MinCap
		BEGIN
		Print 'Minimum course capacity is reached.'
		END;

	ELSE
		BEGIN
		DELETE FROM EmployeeCourse WHERE @CRN = CRN;
		DELETE FROM CourseDailySchedule WHERE @CRN = CRN;
		DELETE FROM CourseEnrollment WHERE @CRN = CRN;
		DELETE FROM CourseSchedule WHERE @CRN = CRN;
		Print 'Minimum capacity not met: Course is removed from the schedule.'
		END;

GO
select count(*) from CourseEnrollment where CRN = 900815;
GO
select * from CourseEnrollment
exec CheckMinCap 900000, 10;
exec CheckMinCap 900815, 10;
exec CheckMinCap 900805, 1;

GO
select count(*) from CourseEnrollment where CRN = 900815;
select * from CourseEnrollment;
select * from EmployeeCourse;
select * from CourseDailySchedule;
select * from CourseSchedule;

                                                               -- 2 --

CREATE PROCEDURE  EnrollStudent(@CRN AS INT,@EnrollmentStatus INT,@StudentId AS INT) 
	AS
	DECLARE @EnrolledStudent VARCHAR(20)
	DECLARE @Course INT
	DECLARE @MaxSeats INT
	DECLARE @CurrentSeats INT
	SELECT @EnrolledStudent = (SELECT StudentId FROM CourseEnrollment WHERE StudentId = @StudentId AND CRN = @CRN)
	SELECT @Course = (SELECT CRN FROM CourseEnrollment WHERE CRN = @CRN AND StudentId = @StudentId)
	SELECT @MaxSeats = (SELECT MaximumSeating FROM CourseSchedule JOIN ClassRoom ON CourseSchedule.LocationId = ClassRoom.ClassRoomId WHERE CourseSchedule.CRN = @CRN)
	SELECT @CurrentSeats = (SELECT count(*) FROM CourseEnrollment WHERE CRN = @CRN)

	IF @StudentId = @EnrolledStudent AND @CRN = @Course
		BEGIN
		Print 'The student is already enrolled.'
		END;

	ELSE IF @EnrolledStudent IS NULL 
		BEGIN
		IF @CurrentSeats >= @MaxSeats
			BEGIN
			Print 'Maximum Seat Capacity Reached. Cannot Enroll'
			END
		ELSE
			BEGIN
			INSERT INTO CourseEnrollment (StudentId, EnrollmentStatusId ,CRN)
			VALUES (@StudentId, @EnrollmentStatus,@CRN) 
			Print 'Student Enrolled.'
			END
		END;

GO
select count(*) as 'Current Seat Count' from CourseEnrollment where CRN = 900805;

GO
exec EnrollStudent 900805, 1, 2;
exec EnrollStudent 900805, 1, 1;
exec EnrollStudent 900815, 1, 1;

GO
select * from CourseSchedule;
select * from ClassRoom;
select * from CourseEnrollment;


                                                              -- 3 --

CREATE PROCEDURE EnterFinalGrade(@CRN AS INT,@StudentId AS INT,@Grade AS INT) 
	AS
	IF @Grade > 100
		BEGIN
		UPDATE CourseEnrollment
		SET FinalGrade = 100
		WHERE StudentId = @StudentId AND CRN = @CRN  
		END
	ELSE
		BEGIN
		UPDATE CourseEnrollment
		SET FinalGrade = @Grade
		WHERE StudentId = @StudentId AND CRN = @CRN  
		END;

GO
select * from CourseEnrollment;
exec EnterFinalGrade 900805, 1, 93;

GO
select * from CourseEnrollment;
exec EnterFinalGrade 900805, 1, 105;

GO
select * from CourseEnrollment;

                                                                -- 4 --

CREATE PROCEDURE AnnualRaise(@Rate AS FLOAT) 
		AS
		DECLARE @total INT
		DECLARE @current INT
		DECLARE @salary INT
		DECLARE PayCursor CURSOR FOR
		SELECT EmployeeId from EmployeeInfo
		OPEN PayCursor;
		FETCH NEXT FROM PayCursor INTO @current
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @salary = (SELECT AnnualSalary FROM EmployeeInfo WHERE EmployeeId = @current)
			SET @total = @salary + ROUND(@salary * @Rate, 0)
			UPDATE EmployeeInfo
			SET AnnualSalary = @total
			WHERE EmployeeId = @current
			FETCH NEXT FROM PayCursor INTO @current
		END
		CLOSE PayCursor
		DEALLOCATE PayCursor

GO
exec AnnualRaise 0.02;
select * from EmployeeInfo;