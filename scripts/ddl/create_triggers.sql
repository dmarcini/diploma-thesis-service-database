-- create triggers --

CREATE TRIGGER
	Person.TR_Student_Limit1DiplomaAuthors_DML
ON
	Person.Student
AFTER INSERT, UPDATE
AS
BEGIN
	DECLARE @thesis_id int;
	
	DECLARE cursor_student CURSOR
	FOR	SELECT
			ThesisID
		FROM
			inserted;
		
	OPEN cursor_student;

	FETCH NEXT FROM
		cursor_student
	INTO
		@thesis_id;

    EXEC Person.usp_CheckThesisAuthorsNumber @thesis_id;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		FETCH NEXT FROM
			cursor_student
		INTO
			@thesis_id;

        EXEC Person.usp_CheckThesisAuthorsNumber @thesis_id;
	END

	CLOSE cursor_student;
	DEALLOCATE cursor_student;
END
GO

CREATE TRIGGER
    Exam.TR_CommissionMember_LimitMembers1Comission_DML
ON
    Exam.CommissionMember
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @exam_commission_id smallint;

    DECLARE cursor_commission_member CURSOR
    FOR SELECT
            ExamCommissionID
        FROM
            inserted;

    OPEN cursor_commission_member;

    FETCH NEXT FROM
        cursor_commission_member
    INTO
        @exam_commission_id;

    EXEC Exam.usp_CheckCommissionMembersNumber @exam_commission_id;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        FETCH NEXT FROM
            cursor_commission_member
        INTO
            @exam_commission_id;

        EXEC Exam.usp_CheckCommissionMembersNumber @exam_commission_id;
    END

    CLOSE cursor_commission_member;
    DEALLOCATE cursor_commission_member;
END
GO

CREATE TRIGGER
    TR_CommissionMember_PreventChairmanBeRegularCommissionMember_DML
ON
    Exam.CommissionMember
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @exam_commission_id smallint;
    DECLARE @lecturer_id smallint;

    DECLARE cursor_commission_member CURSOR
    FOR SELECT
            ExamCommissionID,
            LecturerID
        FROM
            inserted;

    OPEN cursor_commission_member;

    FETCH NEXT FROM
        cursor_commission_member
    INTO
        @exam_commission_id,
        @lecturer_id;

    EXEC Exam.usp_CheckCommissionMember @exam_commission_id, @lecturer_id;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        FETCH NEXT FROM
            cursor_commission_member
        INTO
            @exam_commission_id,
            @lecturer_id;

        EXEC Exam.usp_CheckCommissionMember @exam_commission_id, @lecturer_id;
    END

    CLOSE cursor_commission_member;
    DEALLOCATE cursor_commission_member;
END
GO
