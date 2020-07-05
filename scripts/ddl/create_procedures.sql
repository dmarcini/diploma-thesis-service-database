-- create procedures --

CREATE PROCEDURE
    Person.usp_CheckThesisAuthorsNumber(@thesis_id int)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @error_info VARCHAR(80) = CONCAT(
        'Diploma thesis (id = ',
        @thesis_id,
        ') can be written by a maximum of 3 students.'
    );
    DECLARE @max_authors tinyint = 3;

    DECLARE @authors_number tinyint = (
        SELECT
            COUNT(*)
        FROM
            Person.Student
        WHERE
            ThesisID = @thesis_id
    );

    IF (@authors_number > @max_authors)
    BEGIN
        RAISERROR(@error_info, 16, 1);
        ROLLBACK TRANSACTION;
    END
END
GO

CREATE PROCEDURE
    Exam.usp_CheckCommissionMembersNumber(@exam_commission_id smallint)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @error_info varchar(80) = CONCAT(
        'Exam commission (id = ',
        @exam_commission_id,
        ') may have maximum of 3 members (except chairman).'
    );
    DECLARE @max_commission_members tinyint = 3;

    DECLARE @commission_member_number tinyint = (
        SELECT
            COUNT(*)
        FROM
            Exam.CommissionMember
        WHERE
            ExamCommissionID = @exam_commission_id
    );

    IF (@commission_member_number > @max_commission_members)
    BEGIN
        RAISERROR(@error_info, 16, 1);
        ROLLBACK TRANSACTION;
    END
END
GO

CREATE PROCEDURE
    Exam.usp_CheckCommissionMember(@exam_commission_id smallint,
                                   @lecturer_id smallint)
AS
BEGIN
    DECLARE @error_info varchar(80) = CONCAT(
        'The chairman (id = ',
        @lecturer_id,
        ') of the commission (id = ',
        @exam_commission_id,
        ') cannot be a regular member of it .'
    );

    IF EXISTS (
        SELECT
            ExamCommissionID, ChairmanID
        FROM
            Exam.ExamCommission
        WHERE
            (ExamCommissionID = @exam_commission_id AND
             ChairmanID = @lecturer_id)
    )
    BEGIN
        RAISERROR(@error_info, 16, 1);
        ROLLBACK TRANSACTION;
    END
END
GO
