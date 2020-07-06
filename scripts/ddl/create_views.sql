-- create views --

CREATE OR ALTER VIEW
    Thesis.VI_ThesisReport
AS
SELECT
    s.FirstName AS AuthorFirstName,
    s.LastName AS AuthorLastName,
    f.Name AS Faculty,
    sf.Name AS StudyField,
    ac.Name AS Degree,
    p.FirstName AS PromoterFirstName,
    p.LastName AS PromoterLastName,
    t.Name AS ThesisName,
    Thesis.udf_GetThesisGrade(t.ThesisID) AS ThesisGrade
FROM
    Person.Student AS s
    INNER JOIN
    University.StudyField AS sf
        ON s.StudyFieldID = sf.StudyFieldID
    INNER JOIN
    University.Faculty AS f
        ON sf.FacultyID = f.FacultyID
    INNER JOIN
    University.AcademicDegree AS ac
        ON sf.AcademicDegreeID = ac.AcademicDegreeID
    INNER JOIN
    Thesis.Thesis as t
        ON s.ThesisID = t.thesisID
    INNER JOIN
    Person.Lecturer AS p
        ON t.PromoterID = p.LecturerID
ORDER BY
    Faculty,
    StudyField,
    Degree,
    AuthorLastName,
    ThesisGrade DESC
OFFSET 0 ROWS;
GO
    
CREATE OR ALTER VIEW
    Thesis.VI_ReviewReport
AS
SELECT
    s.FirstName AS AuthorFirstName,
    s.LastName AS AuthorLastName,
    p.FirstName AS PromoterFirstName,
    p.LastName AS PromoterLastName,
    t.Name AS ThesisName,
    r.FirstName AS ReviewerFirstName,
    r.LastName AS ReviewerLastName,
    rw.Abstract AS Abstract,
    rw.Date AS Date,
    rw.Grade AS Grade
FROM
    Person.Student AS s
    INNER JOIN
    Thesis.Thesis AS t
        ON s.ThesisID = t.ThesisID
    INNER JOIN
    Person.Lecturer AS p
        ON t.PromoterID = p.LecturerID
    INNER JOIN
    Person.Reviewer AS rr
        ON t.ThesisID = rr.ThesisID
    INNER JOIN
    Person.Lecturer AS r
        ON r.LecturerID = rr.LecturerID
    INNER JOIN
    Thesis.Review AS rw
        ON rr.ReviewID = rw.ReviewID
ORDER BY
    Date DESC,
    Grade DESC,
    AuthorLastName
OFFSET 0 ROWS;
GO

CREATE OR ALTER VIEW
    Exam.VI_ExamReport
AS
SELECT
    s.FirstName AS StudentFirstName,
    s.LastName AS StudentLastName,
    de.Date AS DiplomaExamDate,
    Exam.udf_GetDiplomaExamGrade(s.StudentID) AS DiplomaExamGrade,
    Exam.udf_GetCommissionMembers(s.StudentID) AS CommissionMembers,
    Exam.udf_GetDiplomaQuestions(s.StudentID) AS DiplomaQuestions
FROM
    Person.Student AS s
    INNER JOIN
    Exam.DiplomaExam AS de
        ON s.DiplomaExamID = de.DiplomaExamID
ORDER BY
    DiplomaExamDate DESC,
    StudentLastName,
    DiplomaExamGrade DESC
OFFSET 0 ROWS;
GO
