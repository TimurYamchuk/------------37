-- ��� 0 �������� ��
use master
go

CREATE DATABASE BarberShopDB;
USE BarberShopDB;

-- ������� � ����������
CREATE TABLE Positions (
    PositionID INT IDENTITY PRIMARY KEY,
    PositionName NVARCHAR(100) NOT NULL
);

-- �������
CREATE TABLE Barbers (
    BarberID INT IDENTITY PRIMARY KEY,
    FullName NVARCHAR(255) NOT NULL,
    Gender CHAR(1) CHECK (Gender IN ('M', 'F')),
    ContactPhone NVARCHAR(50),
    Email NVARCHAR(100),
    DateOfBirth DATE CHECK (DateOfBirth <= DATEADD(YEAR, -21, GETDATE())), -- �������� �� ������� ������ 21 ����
    HireDate DATE,
    PositionID INT FOREIGN KEY REFERENCES Positions(PositionID)
);

-- �������
CREATE TABLE Clients (
    ClientID INT IDENTITY PRIMARY KEY,
    FullName NVARCHAR(255) NOT NULL,
    ContactPhone NVARCHAR(50),
    Email NVARCHAR(100)
);

-- ������
CREATE TABLE Services (
    ServiceID INT IDENTITY PRIMARY KEY,
    ServiceName NVARCHAR(255) NOT NULL,
    Price MONEY NOT NULL,
    DurationInMinutes INT NOT NULL
);

-- ������� ��������
CREATE TABLE ClientFeedbacks (
    FeedbackID INT IDENTITY PRIMARY KEY,
    ClientID INT FOREIGN KEY REFERENCES Clients(ClientID),
    BarberID INT FOREIGN KEY REFERENCES Barbers(BarberID),
    Feedback NVARCHAR(MAX),
    Rating NVARCHAR(50) CHECK (Rating IN ('very_bad', 'bad', 'normal', 'good', 'excellent'))
);

-- ������� ��������
CREATE TABLE BarberFeedbacks (
    FeedbackID INT IDENTITY PRIMARY KEY,
    BarberID INT FOREIGN KEY REFERENCES Barbers(BarberID),
    ClientID INT FOREIGN KEY REFERENCES Clients(ClientID),
    Feedback NVARCHAR(MAX),
    Rating NVARCHAR(50) CHECK (Rating IN ('very_bad', 'bad', 'normal', 'good', 'excellent'))
);

-- ���������� ��������
CREATE TABLE BarberSchedule (
    ScheduleID INT IDENTITY PRIMARY KEY,
    BarberID INT FOREIGN KEY REFERENCES Barbers(BarberID),
    Date DATE NOT NULL,
    TimeFrom TIME NOT NULL,
    TimeTo TIME NOT NULL,
    ClientID INT FOREIGN KEY REFERENCES Clients(ClientID)
);

-- ����� ���������
CREATE TABLE VisitsArchive (
    VisitID INT IDENTITY PRIMARY KEY,
    ClientID INT FOREIGN KEY REFERENCES Clients(ClientID),
    BarberID INT FOREIGN KEY REFERENCES Barbers(BarberID),
    ServiceID INT FOREIGN KEY REFERENCES Services(ServiceID),
    VisitDate DATE NOT NULL,
    TotalCost MONEY,
    Rating NVARCHAR(50) CHECK (Rating IN ('very_bad', 'bad', 'normal', 'good', 'excellent')),
    Feedback NVARCHAR(MAX)
);

--��� 1 ��������� ������

-- ��������� �������
INSERT INTO Positions (PositionName) VALUES
('chief-barber'),
('senior-barber'),
('junior-barber'),
('stylist'),
('apprentice');

SELECT * FROM Positions

-- ��������� ��������
INSERT INTO Barbers (FullName, Gender, ContactPhone, Email, DateOfBirth, HireDate, PositionID) VALUES
('���� ������', 'M', '123-456-7890', 'ivanov@example.com', '1980-06-15', '2015-01-01', 1),
('������� �������', 'M', '234-567-8901', 'smirnov@example.com', '1990-07-20', '2016-02-01', 2),
('����� �������', 'F', '345-678-9012', 'petrova@example.com', '1985-08-25', '2017-03-01', 3),
('��������� ��������', 'F', '456-789-0123', 'sergeeva@example.com', '1983-09-30', '2018-04-01', 2),
('������� ������', 'M', '567-890-1234', 'volkov@example.com', '1995-05-05', '2019-05-01', 3);

SELECT * FROM Barbers

-- ��������� ��������
INSERT INTO Clients (FullName, ContactPhone, Email) VALUES
('������ ��������', '678-901-2345', 'kuznetsov@example.com'),
('����� ���������', '789-012-3456', 'vasilieva@example.com'),
('����� ��������', '890-123-4567', 'novikova@example.com'),
('������� ��������', '901-234-5678', 'morozova@example.com'),
('������ �����', '012-345-6789', 'belov@example.com');

SELECT * FROM Clients

-- ��������� ������
INSERT INTO Services (ServiceName, Price, DurationInMinutes) VALUES
('�������', 1500.00, 60),
('������ ������', 800.00, 30),
('�������', 2000.00, 120),
('�������', 1000.00, 40),
('����� ��� �����', 500.00, 30);

SELECT * FROM Services

-- ��������� ������� ��������
INSERT INTO ClientFeedbacks (ClientID, BarberID, Feedback, Rating) VALUES
(1, 1, '�������� �������!', 'excellent'),
(2, 2, '�������, �� ����� ���� � �����.', 'good'),
(3, 3, '� �������� �������� �������.', 'good'),
(4, 4, '�� ����� ���������.', 'normal'),
(5, 5, '�����������, ���� ������������� �������!', 'excellent');

SELECT * FROM ClientFeedbacks

-- ��������� ������� ��������
INSERT INTO BarberFeedbacks (BarberID, ClientID, Feedback, Rating) VALUES
(1, 1, '������������ ������.', 'good'),
(2, 2, '������������� ��������.', 'excellent'),
(3, 3, '���� ��������� ���������.', 'normal'),
(4, 4, '������ ���������.', 'bad'),
(5, 5, '��� ������ �������!', 'excellent');

SELECT * FROM BarberFeedbacks

-- ��������� ���������� ��������
INSERT INTO BarberSchedule (BarberID, Date, TimeFrom, TimeTo, ClientID) VALUES
(1, '2024-04-25', '09:00', '10:00', 1),
(2, '2024-04-25', '10:00', '11:00', 2),
(3, '2024-04-25', '11:00', '12:00', 3),
(4, '2024-04-25', '12:00', '13:00', 4),
(5, '2024-04-25', '13:00', '14:00', 5);

SELECT * FROM BarberSchedule

-- ��������� ����� ���������
INSERT INTO VisitsArchive (ClientID, BarberID, ServiceID, VisitDate, TotalCost, Rating, Feedback) VALUES
(1, 1, 1, '2023-01-15', 1500.00, 'excellent', '������� ������� � ������������.'),
(2, 2, 2, '2023-02-20', 800.00, 'good', '������ � �����������.'),
(3, 3, 3, '2023-03-25', 2000.00, 'normal', '���� �� ������ ���, ��� ��������.'),
(4, 4, 4, '2023-04-30', 1000.00, 'bad', '������� �� ��������.'),
(5, 5, 5, '2023-05-05', 500.00, 'excellent', '������ ����� ����� �����������.');

SELECT * FROM VisitsArchive

--��� 2 

--1. ������� ��� ���� �������� ������
CREATE FUNCTION dbo.GetAllBarbersNames()
RETURNS TABLE
AS
RETURN
    SELECT FullName
    FROM Barbers;
GO

SELECT * FROM dbo.GetAllBarbersNames();

--2. ������� ���������� � ���� ������-��������
CREATE PROCEDURE GetSeniorBarbersInfo
AS
BEGIN
    SELECT b.*
    FROM Barbers AS b
    INNER JOIN Positions AS p ON b.PositionID = p.PositionID
    WHERE p.PositionName = 'senior-barber';
END
GO

EXEC GetSeniorBarbersInfo;

--3. ������� ���������� � ���� ��������, ������� ����� ���-
--��������� ������ ������������� ������ ������
CREATE PROCEDURE dbo.GetBarbersByService
    @ServiceName NVARCHAR(255)
AS
BEGIN
    SELECT b.*
    FROM Barbers b
    INNER JOIN Services s ON b.PositionID = s.ServiceID
    WHERE s.ServiceName = @ServiceName;
END
GO

EXEC dbo.GetBarbersByService @ServiceName = '������ ������';

--4. ������� ���������� � ���� ��������, ������� ����� ���-
--��������� ���������� ������. ���������� � ���������
--������ ��������������� � �������� ���������

EXEC dbo.GetBarbersByService @ServiceName = '�������';

--5. ������� ���������� � ���� ��������, ������� ��������
--����� ���������� ���������� ���. ���������� ��� ������-
--���� � �������� ���������
CREATE PROCEDURE dbo.GetBarbersByYearsOfService
    @Years INT
AS
BEGIN
    SELECT *
    FROM Barbers
    WHERE DATEDIFF(YEAR, HireDate, GETDATE()) > @Years;
END
GO

EXEC dbo.GetBarbersByYearsOfService @Years = 5;

--6. ������� ���������� ������-�������� � ���������� ���-
--����-��������
CREATE FUNCTION dbo.GetBarbersCountByPosition()
RETURNS @BarberCounts TABLE
(
    SeniorBarbersCount INT,
    JuniorBarbersCount INT
)
AS
BEGIN
    INSERT INTO @BarberCounts (SeniorBarbersCount, JuniorBarbersCount)
    SELECT
        (SELECT COUNT(*) FROM Barbers WHERE PositionID = (SELECT PositionID FROM Positions WHERE PositionName = 'senior-barber')),
        (SELECT COUNT(*) FROM Barbers WHERE PositionID = (SELECT PositionID FROM Positions WHERE PositionName = 'junior-barber'));
    
    RETURN;
END
GO

SELECT * FROM dbo.GetBarbersCountByPosition();

--7. ������� ���������� � ���������� ��������. ��������
--����������� �������: ��� � ������ �������� ����������
--���. ���������� ��������� � �������� ���������
CREATE PROCEDURE GetRegularClients
    @VisitThreshold INT
AS
BEGIN
    SELECT 
        c.ClientID, 
        c.FullName, 
        c.ContactPhone, 
        c.Email, 
        COUNT(v.VisitID) AS VisitCount
    FROM 
        Clients c
    JOIN 
        VisitsArchive v ON c.ClientID = v.ClientID
    GROUP BY 
        c.ClientID, 
        c.FullName, 
        c.ContactPhone, 
        c.Email
    HAVING 
        COUNT(v.VisitID) >= @VisitThreshold
END
GO

EXEC GetRegularClients @VisitThreshold = 1;

--8. ��������� ����������� �������� ���������� � ���-���-
--����, ���� �� �������� ������ ���-������
CREATE TRIGGER trg_PreventChiefBarberDeletion
ON Barbers
INSTEAD OF DELETE
AS
BEGIN
    IF (SELECT COUNT(*) FROM Barbers WHERE PositionID = (SELECT PositionID FROM Positions WHERE PositionName = 'chief-barber')) <= 1
    BEGIN
        RAISERROR ('Cannot delete the only chief barber without having a replacement.', 16, 1);
    END
    ELSE
    BEGIN
        DELETE FROM Barbers WHERE BarberID IN (SELECT BarberID FROM deleted);
    END
END
GO

DELETE FROM Barbers WHERE PositionID = (SELECT PositionID FROM Positions WHERE PositionName = 'chief-barber');

--9. ��������� ��������� �������� ������ 21 ����.
CREATE TRIGGER trg_CheckBarberAge
ON Barbers
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted WHERE DATEDIFF(YEAR, DateOfBirth, GETDATE()) < 21)
    BEGIN
        RAISERROR ('Barbers must be at least 21 years old.', 16, 1);
    END
    ELSE
    BEGIN
        INSERT INTO Barbers (FullName, Gender, ContactPhone, Email, DateOfBirth, HireDate, PositionID)
        SELECT FullName, Gender, ContactPhone, Email, DateOfBirth, HireDate, PositionID FROM inserted;
    END
END
GO

INSERT INTO Barbers (FullName, Gender, ContactPhone, Email, DateOfBirth, HireDate, PositionID) 
VALUES ('������� ������', 'M', '987-654-3210', 'youngbarber@example.com', '2007-01-01', '2024-01-01', 1);


