-- create tables --

CREATE TABLE University.Faculty (
	FacultyID smallint IDENTITY(1, 1),
	Name varchar(50) NOT NULL,

	CONSTRAINT PK_Faculty_FacultyID
	PRIMARY KEY(FacultyID),

	CONSTRAINT UQ_Faculty_Name
	UNIQUE(Name)
);

CREATE TABLE University.AcademicDegree (
	AcademicDegreeID tinyint IDENTITY(1, 1),
	Name varchar(30) NOT NULL,

	CONSTRAINT PK_AcademicDegree_AcademicDegreeID
	PRIMARY KEY(AcademicDegreeID),

	CONSTRAINT UQ_AcademicDegree_Name
	UNIQUE(Name)
);

CREATE TABLE University.StudyField (
	StudyFieldID smallint IDENTITY(1, 1),
	FacultyID smallint NOT NULL,
	AcademicDegreeID tinyint NOT NULL,
	Name varchar(50) NOT NULL,

	CONSTRAINT PK_StudyField_StudyFieldID
	PRIMARY KEY(StudyFieldID),

	CONSTRAINT FK_StudyField_Faculty_FacultyID
	FOREIGN KEY(FacultyID)
	REFERENCES University.Faculty(FacultyID)
	ON DELETE CASCADE ON UPDATE CASCADE,

	CONSTRAINT FK_StudyField_AcademicDegree_AcademicDegreeID
	FOREIGN KEY(AcademicDegreeID)
	REFERENCES University.AcademicDegree(AcademicDegreeID)
	ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Person.Lecturer (
	LecturerID smallint,
	FirstName varchar(25) NOT NULL,
	LastName varchar(25) NOT NULL,

	CONSTRAINT PK_Lecturer_LecturerID
	PRIMARY KEY(LecturerID)
);

CREATE TABLE Person.AcademicLecturerDegree (
	AcademicDegreeID tinyint,
	LecturerID smallint,
	
	CONSTRAINT PK_AcademicLecturerDegree_AcademicDegreeID_LecturerID
	PRIMARY KEY(AcademicDegreeID, LecturerID),

	CONSTRAINT FK_AcademicLecturerDegree_AcademicDegree_LecturerID
	FOREIGN KEY(AcademicDegreeID)
	REFERENCES University.AcademicDegree(AcademicDegreeID)
	ON DELETE CASCADE ON UPDATE CASCADE, 

	CONSTRAINT FK_AcademicLecturerDegree_Lecturer_LecturerID
	FOREIGN KEY(LecturerID)
	REFERENCES Person.Lecturer(LecturerID)
	ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Thesis.Keyword (
	KeywordID int IDENTITY(1, 1),
	Name varchar(50) NOT NULL,

	CONSTRAINT PK_Keyword_KeywordID
	PRIMARY KEY(KeywordID),

	CONSTRAINT UQ_Keyword_Name
	UNIQUE(Name)
);

CREATE TABLE Thesis.Thesis (
	ThesisID int IDENTITY(1, 1),
	PromoterID smallint,
	Name varchar(100),

	CONSTRAINT PK_Thesis_ThesisID
	PRIMARY KEY(ThesisID),

	CONSTRAINT FK_Thesis_Lecturer_LecturerID
	FOREIGN KEY(PromoterID)
	REFERENCES Person.Lecturer(LecturerID)
	ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE Thesis.ThesisKeyword (
	KeywordID int,
	ThesisID int,

	CONSTRAINT PK_ThesisKeyword_KeywordID_ThesisID
	PRIMARY KEY(KeywordID, ThesisID),

	CONSTRAINT FK_ThesisKeyword_Keyword_KeywordID
	FOREIGN KEY(KeywordID)
	REFERENCES Thesis.Keyword(KeywordID)
	ON DELETE CASCADE ON UPDATE CASCADE,

	CONSTRAINT FK_ThesisKeyword_Thesis_ThesisID
	FOREIGN KEY(ThesisID)
	REFERENCES Thesis.Thesis(ThesisID)
	ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Thesis.Review (
	ReviewID int IDENTITY(1, 1),
	Abstract varchar(200),
	Date date,
	Grade decimal(2, 1) NOT NULL,

	CONSTRAINT PK_Review_ReviewID
	PRIMARY KEY(ReviewID),

	CONSTRAINT CK_Review_Date
	CHECK(Date >= '2020-01-01'),

	CONSTRAINT CK_Review_Grade
	CHECK(grade >= 2.0 AND grade <= 5.5)
);

CREATE TABLE Person.Reviewer (
	ThesisID int,
	LecturerID smallint,
	ReviewID int,

	CONSTRAINT PK_Reviewer_ThesisID_LecturerID
	PRIMARY KEY(ThesisID, LecturerID),

	CONSTRAINT FK_Reviewer_Thesis_ThesisID
	FOREIGN KEY(ThesisID)
	REFERENCES Thesis.Thesis(ThesisID)
	ON DELETE CASCADE ON UPDATE CASCADE,

	CONSTRAINT FK_Reviewer_Lecturer_LecturerID
	FOREIGN KEY(LecturerID)
	REFERENCES Person.Lecturer(LecturerID)
	ON DELETE NO ACTION ON UPDATE NO ACTION,

	CONSTRAINT FK_Reviewer_Review_ReviewID
	FOREIGN KEY(ReviewID)
	REFERENCES Thesis.Review(ReviewID)
	ON DELETE CASCADE ON UPDATE CASCADE,

	CONSTRAINT UQ_Reviewer_ReviewID
	UNIQUE(ReviewID)
);

CREATE TABLE Exam.DiplomaQuestion (
	DiplomaQuestionID smallint IDENTITY(1, 1),
	Question varchar(100) NOT NULL,

	CONSTRAINT PK_DiplomaQuestion_DiplomaQuestionID
	PRIMARY KEY(DiplomaQuestionID),

	CONSTRAINT UQ_DiplomaQuestion_Question
	UNIQUE(Question)
);

CREATE TABLE Exam.ExamCommission (
	ExamCommissionID smallint IDENTITY(1, 1),
	ChairmanID smallint NOT NULL,

	CONSTRAINT PK_ExamCommission_ExamCommissionID
	PRIMARY KEY(ExamCommissionID),

	CONSTRAINT FK_ExamCommition_Lecturer_LecturerID
	FOREIGN KEY(ChairmanID)
	REFERENCES Person.Lecturer(LecturerID)
	ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Exam.CommissionMember (
	ExamCommissionID smallint,
	LecturerID smallint,

	CONSTRAINT PK_CommissionMember_ExamCommissionID_LecturerID
	PRIMARY KEY(ExamCommissionID, LecturerID),

	CONSTRAINT FK_CommissionMember_ExamCommission_ExamCommissionID
	FOREIGN KEY(ExamCommissionID)
	REFERENCES Exam.ExamCommission(ExamCommissionID)
	ON DELETE NO ACTION ON UPDATE CASCADE,

	CONSTRAINT FK_CommissionMember_Lecturer_LecturerID
	FOREIGN KEY(LecturerID)
	REFERENCES Person.Lecturer(LecturerID)
	ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE Exam.DiplomaExam (
	DiplomaExamID smallint IDENTITY(1, 1),
	ExamCommissionID smallint,
	Date date,

	CONSTRAINT PK_DiplomaExam_DiplomaExamID
	PRIMARY KEY(DiplomaExamID),

	CONSTRAINT FK_DiplomaExam_ExamCommission_ExamCommissionID
	FOREIGN KEY(ExamCommissionID)
	REFERENCES Exam.ExamCommission(ExamCommissionID)
	ON DELETE CASCADE ON UPDATE CASCADE,

	CONSTRAINT CK_DiplomaExam_Date
	CHECK(Date >= '2020-01-01'),
);

CREATE TABLE Person.Student (
	StudentID int,
	StudyFieldID smallint NOT NULL,
	ThesisID int NOT NULL,
	DiplomaExamID smallint,
	FirstName varchar(25) NOT NULL,
	LastName varchar(25) NOT NULL,

	CONSTRAINT PK_Student_StudentID
	PRIMARY KEY(StudentID),

	CONSTRAINT FK_Student_StudyField_StudyFieldID
	FOREIGN KEY(StudyFieldID)
	REFERENCES University.StudyField(StudyFieldID)
	ON DELETE NO ACTION ON UPDATE CASCADE,

	CONSTRAINT FK_Student_Thesis_ThesisID
	FOREIGN KEY(ThesisID)
	REFERENCES Thesis.Thesis(ThesisID)
	ON DELETE CASCADE ON UPDATE CASCADE,

	CONSTRAINT FK_Student_DiplomaExam_DiplomaExamID
	FOREIGN KEY(DiplomaExamID)
	REFERENCES Exam.DiplomaExam(DiplomaExamID)
	ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE Exam.DiplomaExamQuestion (
	DiplomaQuestionID smallint,
	StudentID int,
	Grade decimal(2, 1) NOT NULL,

	CONSTRAINT PK_DiplomaExamQuestion_DiplomaQuestionID_StudentID
	PRIMARY KEY(DiplomaQuestionID, StudentID),

	CONSTRAINT FK_DiplomaExamQuestion_DiplomaQuestion_DiplomaQuestionID
	FOREIGN KEY(DiplomaQuestionID)
	REFERENCES Exam.DiplomaQuestion(DiplomaQuestionID)
	ON DELETE NO ACTION ON UPDATE CASCADE,

	CONSTRAINT FK_DiplomaExamQuestion_Student_StudentID
	FOREIGN KEY(StudentID)
	REFERENCES Person.Student(StudentID)
	ON DELETE CASCADE ON UPDATE CASCADE,

	CONSTRAINT CK_DiplomaExamQuestion_Grade
	CHECK(grade >= 2.0 AND grade <= 5.5)
);

GO
