-- create functions

CREATE OR ALTER FUNCTION
    Thesis.udf_GetThesisGrade(@thesis_id int)
RETURNS decimal(2, 1)
AS
BEGIN
    DECLARE @thesis_grade decimal(2, 1) = (
        SELECT
            AVG(rw.Grade)
        FROM
            Thesis.Thesis AS t
            INNER JOIN
            Person.Reviewer AS r
                ON t.ThesisID = r.ThesisID
            INNER JOIN
            Thesis.Review AS rw
                ON r.ReviewID = rw.ReviewID
        WHERE
            t.ThesisID = @thesis_id
    );

    RETURN @thesis_grade;
END
GO

CREATE OR ALTER FUNCTION
    Exam.udf_GetDiplomaExamGrade(@student_id int)
RETURNS decimal(2, 1)
AS
BEGIN
    DECLARE @diploma_exam_grade decimal(2, 1) = (
        SELECT
            AVG(deq.Grade)
        FROM
            Person.Student AS s
            INNER JOIN
            Exam.DiplomaExamQuestion AS deq
                ON deq.StudentID = s.StudentID
        WHERE
            s.StudentID = @student_id
    );

    RETURN @diploma_exam_grade;
END
GO

CREATE OR ALTER FUNCTION
    Exam.udf_GetCommissionMembers(@student_id int)
RETURNS varchar(100)
AS
BEGIN
    DECLARE @commission_id smallint;
    DECLARE @commission_members varchar(100);

    SELECT
        @commission_id = ec.ExamCommissionID,
        @commission_members = c.LastName
    FROM
        Person.Student AS s
        INNER JOIN
        Exam.DiplomaExam AS de
            ON s.DiplomaExamID = de.DiplomaExamID
        INNER JOIN
        Exam.ExamCommission AS ec
            ON ec.ExamCommissionID = de.ExamCommissionID
        INNER JOIN
        Person.Lecturer AS c
            ON ec.ChairmanID = c.LecturerID
    WHERE
        s.StudentID = @student_id;

    SET @commission_members = CONCAT(
        @commission_members,
        ', ',
        (
            SELECT
                STRING_AGG(l.LastName, ', ')
            FROM
                Exam.CommissionMember AS cm
                INNER JOIN
                Person.Lecturer AS l
                    ON l.LecturerID = cm.LecturerID AND
                       cm.ExamCommissionID = @commission_id
        ));

    RETURN @commission_members;
END
GO

CREATE OR ALTER FUNCTION
    Exam.udf_GetDiplomaQuestions(@student_id int)
RETURNS varchar(300)
AS
BEGIN
    DECLARE @diploma_questions varchar(300) = (
        SELECT
            STRING_AGG(dq.Question, CHAR(13))
        FROM
            Person.Student AS s
            INNER JOIN
            Exam.DiplomaExamQuestion AS deq
                ON deq.StudentID = s.StudentID
            INNER JOIN
            Exam.DiplomaQuestion AS dq
                ON dq.DiplomaQuestionID = deq.DiplomaQuestionID
        WHERE
            s.StudentID = @student_id
    );

    RETURN @diploma_questions;
END
GO
