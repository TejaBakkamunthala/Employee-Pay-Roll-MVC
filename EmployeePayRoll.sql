CREATE DATABASE EMPLOYEEPAYROLLMVC;

USE EMPLOYEEPAYROLLMVC;


CREATE   TABLE EMPLOYEE(
EmpId INT PRIMARY KEY IDENTITY(1,1),
EmpName VARCHAR(40) NOT NULL,
ProfileImage VARCHAR(60) NOT NULL,
Gender VARCHAR(10)  NOT NULL,
Department VARCHAR(40) NOT NULL,
Salary MONEY NOT NULL,
StartDate date NOT NULL,
Notes Varchar(Max) NOT NULL);


select  * FROM EMPLOYEE;


INSERT INTO EMPLOYEE (EmpName,ProfileImage,Gender,Department,Salary,StartDate,Notes)
VALUES('Teja','tej.jpg','Male','IT',20000,'01-01-2023','Hii Teja');


create or alter procedure Register_Employee(
@EmpName VARCHAR(40),
@ProfileImage VARCHAR(60),
@Gender VARCHAR(10),
@Department VARCHAR(40),
@Salary MONEY,
@StartDate date,
@Notes VARCHAR(MAX))
AS
BEGIN 

IF @EmpName IS NULL OR 
@ProfileImage IS NULL OR 
@GENDER IS NULL OR 
@Department IS NULL OR 
@Salary IS NULL OR 
@StartDate IS NULL OR 
@Notes IS NULL

BEGIN 
PRINT 'PROVIDE ALL PARMETERS'
RETURN 
END

IF @Salary<=0
BEGIN
PRINT 'Salary  amount should be greater than zero'
RETURN
END

IF @StartDate> GETDATE()
BEGIN
PRINT 'Date should not be in future'
RETURN
END

INSERT INTO EMPLOYEE (EmpName,ProfileImage,Gender,Department,Salary,StartDate,Notes)
VALUES(@EmpName,@ProfileImage,@Gender,@Department,@Salary,@StartDate,@Notes);

IF @@ROWCOUNT=1
BEGIN
PRINT 'ROW REGISTERED SUCCESSFULLY';
END

ELSE

BEGIN
PRINT 'ROW REGISTERED FAILED';
END

END



EXEC Register_Employee 'Saii','saii.jpg','Male','IT',300000,'02-02-2023','Hii Saii';



CREATE OR ALTER PROCEDURE GETALLEMPLOYEES
AS
BEGIN
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM Employee)
        BEGIN
            SELECT * FROM Employee;
        END
        ELSE
        BEGIN
			PRINT 'NO EMPLOYEES FOUND'
        END
    END TRY
    BEGIN CATCH
        -- Error handling
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT @ErrorMessage = ERROR_MESSAGE(), 
               @ErrorSeverity = ERROR_SEVERITY(),
               @ErrorState = ERROR_STATE();

        -- Log error message or take appropriate action
        -- For now, printing the error message
        PRINT 'Error: ' + @ErrorMessage;
    END CATCH
END


EXEC GETALLEMPLOYEES;





--UPDATE EMPLOYEE 


CREATE OR ALTER PROCEDURE UPDATEEMPLOYEE(
    @EmpId INT ,
    @EmpName VARCHAR(40),
    @ProfileImage VARCHAR(60),
    @Gender VARCHAR(10),
    @Department VARCHAR(40),
    @Salary MONEY,
    @StartDate DATE,
    @Notes VARCHAR(MAX)
)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Check Salary constraint
        IF (@Salary < 0)
        BEGIN
            print 'Salary cannot be negative.';
            RETURN;
        END;

        -- Check StartDate constraint
        IF (@StartDate > GETDATE())
        BEGIN
            print 'StartDate cannot be in the future.'
            RETURN;
        END;

        UPDATE EMPLOYEE SET 
            EmpName = @EmpName, 
            ProfileImage = @ProfileImage,
            Gender = @Gender, 
            Department = @Department,
            Salary = @Salary,
            StartDate = @StartDate,
            Notes = @Notes
        WHERE EmpId = @EmpId;

        COMMIT TRANSACTION;

        PRINT 'Employee Information Updated Successfully';
    END TRY

    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        INSERT INTO ErrorLog (ErrorMessage, ErrorSeverity, ErrorState, ErrorDate)
        VALUES (@ErrorMessage, @ErrorSeverity, @ErrorState, GETDATE());

        PRINT 'Error Occurred: ' + @ErrorMessage;
    END CATCH;
END;


EXEC UPDATEEMPLOYEE @EmpId=18, 
                    @EmpName='arav', 
                    @ProfileImage='arun.jpg',
					@Gender='Male',
					@Department='HR',
					@Salary=10000,
					@StartDate='01-02-2024',
					@Notes='HII Aavindhj'
					

select *from EMPLOYEE




--DELETE STORED PROCEDURE FOR EMPLOYEE

CREATE OR ALTER PROCEDURE DELETEEMPLOYE(
@EmpId INT)
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION        

DELETE FROM EMPLOYEE WHERE EmpId=@EmpId;
COMMIT TRANSACTION

PRINT 'EMPLOYEE  RECORD DELETED SUCCESSFULLY';
END TRY

BEGIN CATCH
IF @@TRANCOUNT>0
 ROLLBACK TRANSACTION;

 DECLARE @ErrorMessage NVARCHAR(4000);
 DECLARE @ErrorSeverity INT;
 DECLARE @ErrorState INT;

 SELECT 
 @ErrorMessage=ERROR_MESSAGE(),
 @ErrorSeverity=ERROR_SEVERITY(),
 @ErrorState=ERROR_STATE();

 INSERT INTO ErrorLog(ErrorMessage,ErrorSeverity,ErrorState,ErrorDate)
 Values(@ErrorMessage,@ErrorSeverity,@ErrorState,GETDATE());

 PRINT 'Error Occured: '+@ErrorMessage;
 
 END CATCH;
END;



EXEC DELETEEMPLOYE 5;

SELECT *FROM EMPLOYEE;

SELECT * FROM ErrorLog;

CREATE TABLE ErrorLog (
    ErrorId INT PRIMARY KEY IDENTITY(1,1),
    ErrorMessage NVARCHAR(MAX),
    ErrorSeverity INT,
    ErrorState INT,
    ErrorDate DATETIME DEFAULT GETDATE()
);



--GET EMPLOYE BY EMPLOYE ID

CREATE OR ALTER PROCEDURE GetEmployeeById(
@EmpId INT)
AS
BEGIN
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM Employee WHERE EmpId = @EmpId)
        BEGIN
            SELECT * FROM EMPLOYEE WHERE EmpId=@EmpId;
        END
        ELSE
        BEGIN
			PRINT 'EMPLOYEE IS NOT FOUND BY THIS EMPID'
        END
    END TRY
    BEGIN CATCH
        -- Error handling
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT @ErrorMessage = ERROR_MESSAGE(), 
               @ErrorSeverity = ERROR_SEVERITY(),
               @ErrorState = ERROR_STATE();

        -- Log error message or take appropriate action
        -- For now, printing the error message
        PRINT 'Error: ' + @ErrorMessage;
    END CATCH
END

EXEC GetEmployeeById 11;


CREATE OR ALTER PROCEDURE LOGIN_SP(
@EMPID INT,
@EMPNAME VARCHAR(40))
AS
BEGIN 
    BEGIN TRY
	 IF EXISTS(SELECT 1 FROM EMPLOYEE WHERE @EMPID=EMPID AND EmpName=@EMPNAME)
	    BEGIN
     SELECT *FROM EMPLOYEE WHERE EMPID=@EMPID AND EmpName=@EMPNAME;
	    END

	 ELSE
	    BEGIN
	 PRINT 'LOGIN DETAILS ARE INCORRECT OR LOGIN DETAILS ARE NOT AVAILABE';
	    END
   END TRY
   BEGIN CATCH
        -- Error handling
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT @ErrorMessage = ERROR_MESSAGE(), 
               @ErrorSeverity = ERROR_SEVERITY(),
               @ErrorState = ERROR_STATE();

        PRINT 'Error: ' + @ErrorMessage;
    END CATCH
END
   


exec LOGIN_SP 3,'Sam';








--take input of employeename and sow the details, 
--if more than one employee of same name exist show list of their data

--GET EMPLOYEE DETAILS BY NAME
CREATE OR ALTER PROCEDURE GetEmployeeByName(
@EmpName VARCHAR(40))
AS
BEGIN
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM Employee WHERE EmpName = @EmpName)
        BEGIN
            SELECT * FROM EMPLOYEE WHERE EmpName=@EmpName;
        END
        ELSE
        BEGIN
			PRINT 'EMPLOYEE IS NOT FOUND BY THIS EMPNAME'
        END
    END TRY
    BEGIN CATCH
        -- Error handling
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT @ErrorMessage = ERROR_MESSAGE(), 
               @ErrorSeverity = ERROR_SEVERITY(),
               @ErrorState = ERROR_STATE();

        PRINT 'Error: ' + @ErrorMessage;
    END CATCH
END

EXEC GetEmployeeByName 'MAHESH'


























































































































CREATE OR ALTER PROCEDURE GETBYNAME(
@EmpName VARCHAR(40))
AS
BEGIN
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM Employee WHERE EmpName = @EmpName)
        BEGIN
            SELECT * FROM EMPLOYEE WHERE EmpName=@EmpName;
        END
        ELSE
        BEGIN
			PRINT 'EMPLOYEE IS NOT FOUND BY THIS EMPNAME'
        END
    END TRY
    BEGIN CATCH
        -- Error handling
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT @ErrorMessage = ERROR_MESSAGE(), 
               @ErrorSeverity = ERROR_SEVERITY(),
               @ErrorState = ERROR_STATE();

        PRINT 'Error: ' + @ErrorMessage;
    END CATCH
END

EXEC GetEmployeeByName 'SAM'































































































































































































--GET EMPLOYEE DETAILS BY STARTING LETTER
CREATE OR ALTER PROCEDURE GetEmployeeByFirstLetter(
@EmpName VARCHAR(40))
AS
BEGIN
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM Employee WHERE EmpName LIKE @EmpName+'%')
        BEGIN
            SELECT * FROM EMPLOYEE WHERE EmpName LIKE @EmpName+'%';
        END
        ELSE
        BEGIN
			PRINT 'EMPLOYEE IS NOT FOUND BY THIS EMPNAME'
        END
    END TRY
    BEGIN CATCH
        -- Error handling
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT @ErrorMessage = ERROR_MESSAGE(), 
               @ErrorSeverity = ERROR_SEVERITY(),
               @ErrorState = ERROR_STATE();

        -- Log error message or take appropriate action
        -- For now, printing the error message
        PRINT 'Error: ' + @ErrorMessage;
    END CATCH
END


exec GetEmployeeByFisrtLetter 'M';

select * from EMPLOYEE;


CREATE OR ALTER PROCEDURE SearchByGender(
@GENDER VARCHAR(10))
AS
BEGIN
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM Employee WHERE GENDER=@GENDER)
        BEGIN
            SELECT * FROM EMPLOYEE WHERE GENDER=@GENDER
        END
        ELSE
        BEGIN
			PRINT 'EMPLOYEES ARE NOT FOUND BY THIS GENDER'
        END
    END TRY
    BEGIN CATCH
        -- Error handling
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT @ErrorMessage = ERROR_MESSAGE(), 
               @ErrorSeverity = ERROR_SEVERITY(),
               @ErrorState = ERROR_STATE();

        -- Log error message or take appropriate action
        -- For now, printing the error message
        PRINT 'Error: ' + @ErrorMessage;
    END CATCH
END


exec SearchByGender 'FEMALE';


CREATE OR ALTER PROCEDURE SearchBySalary(
@SALARY MONEY)
AS
BEGIN
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM Employee WHERE SALARY>@SALARY)
        BEGIN
            SELECT * FROM EMPLOYEE WHERE SALARY>@SALARY
        END
        ELSE
        BEGIN
			PRINT 'EMPLOYEES ARE NOT AVAILABLE BY THIS SALARY'
        END
    END TRY
    BEGIN CATCH
        -- Error handling
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT @ErrorMessage = ERROR_MESSAGE(), 
               @ErrorSeverity = ERROR_SEVERITY(),
               @ErrorState = ERROR_STATE();

        -- Log error message or take appropriate action
        -- For now, printing the error message
        PRINT 'Error: ' + @ErrorMessage;
    END CATCH
END


exec SearchBySalary 20000;

exec SearchBySlary 30000;


CREATE OR ALTER PROCEDURE SearchByDate(
@STARTDATE DATE)
AS
BEGIN
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM Employee WHERE StartDate>@STARTDATE)
        BEGIN
            SELECT * FROM EMPLOYEE WHERE StartDate>@STARTDATE
        END
        ELSE
        BEGIN
			PRINT 'EMPLOYEES ARE NOT AVAILABLE BY THIS JIOINING DATE'
        END
    END TRY
    BEGIN CATCH
        -- Error handling
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT @ErrorMessage = ERROR_MESSAGE(), 
               @ErrorSeverity = ERROR_SEVERITY(),
               @ErrorState = ERROR_STATE();

        -- Log error message or take appropriate action
        -- For now, printing the error message
        PRINT 'Error: ' + @ErrorMessage;
    END CATCH
END


EXEC SearchByDate '05-05-2024'


CREATE OR ALTER PROCEDURE SearchByDepartment(
@DEPARTMENT VARCHAR(50))
AS
BEGIN
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM Employee WHERE Department=@DEPARTMENT)
        BEGIN
            SELECT * FROM EMPLOYEE WHERE Department=@DEPARTMENT
        END
        ELSE
        BEGIN
			PRINT 'EMPLOYEES ARE NOT FOUND BY THIS  DEPARTMENT';
        END
    END TRY
    BEGIN CATCH
        -- Error handling
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT @ErrorMessage = ERROR_MESSAGE(), 
               @ErrorSeverity = ERROR_SEVERITY(),
               @ErrorState = ERROR_STATE();

        -- Log error message or take appropriate action
        -- For now, printing the error message
        PRINT 'Error: ' + @ErrorMessage;
    END CATCH
END


EXEC SearchByDepartment 'ENGINEER'

CREATE OR ALTER PROCEDURE SerachByJoiningDates(
@StartDate1 date,
@StartDate2 date)
AS
BEGIN
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM Employee WHERE StartDate BETWEEN @StartDate1 AND @StartDate2)
        BEGIN
            SELECT * FROM EMPLOYEE WHERE StartDate BETWEEN @StartDate1 AND  @StartDate2;
        END
        ELSE
        BEGIN
			PRINT 'EMPLOYEES ARE NOT FOUND BY THIS  JOINING DATES';
        END
    END TRY
    BEGIN CATCH
        -- Error handling
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT @ErrorMessage = ERROR_MESSAGE(), 
               @ErrorSeverity = ERROR_SEVERITY(),
               @ErrorState = ERROR_STATE();

        -- Log error message or take appropriate action
        -- For now, printing the error message
        PRINT 'Error: ' + @ErrorMessage;
    END CATCH
END


exec SerachByJoiningDates '01-01-2024' ,'04-04-2024';

exec SerachByJoiningDates '01-01-2025' ,'04-04-2025';

select * from EMPLOYEE

