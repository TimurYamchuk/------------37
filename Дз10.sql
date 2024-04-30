-- Шаг 0 создание Бд
use master
go

CREATE DATABASE BarberShopDB;
USE BarberShopDB;

-- Позиции в барбершопе
CREATE TABLE Positions (
    PositionID INT IDENTITY PRIMARY KEY,
    PositionName NVARCHAR(100) NOT NULL
);

-- Барберы
CREATE TABLE Barbers (
    BarberID INT IDENTITY PRIMARY KEY,
    FullName NVARCHAR(255) NOT NULL,
    Gender CHAR(1) CHECK (Gender IN ('M', 'F')),
    ContactPhone NVARCHAR(50),
    Email NVARCHAR(100),
    DateOfBirth DATE CHECK (DateOfBirth <= DATEADD(YEAR, -21, GETDATE())), -- Проверка на возраст старше 21 года
    HireDate DATE,
    PositionID INT FOREIGN KEY REFERENCES Positions(PositionID)
);

-- Клиенты
CREATE TABLE Clients (
    ClientID INT IDENTITY PRIMARY KEY,
    FullName NVARCHAR(255) NOT NULL,
    ContactPhone NVARCHAR(50),
    Email NVARCHAR(100)
);

-- Услуги
CREATE TABLE Services (
    ServiceID INT IDENTITY PRIMARY KEY,
    ServiceName NVARCHAR(255) NOT NULL,
    Price MONEY NOT NULL,
    DurationInMinutes INT NOT NULL
);

-- Фидбеки клиентов
CREATE TABLE ClientFeedbacks (
    FeedbackID INT IDENTITY PRIMARY KEY,
    ClientID INT FOREIGN KEY REFERENCES Clients(ClientID),
    BarberID INT FOREIGN KEY REFERENCES Barbers(BarberID),
    Feedback NVARCHAR(MAX),
    Rating NVARCHAR(50) CHECK (Rating IN ('very_bad', 'bad', 'normal', 'good', 'excellent'))
);

-- Фидбеки барберов
CREATE TABLE BarberFeedbacks (
    FeedbackID INT IDENTITY PRIMARY KEY,
    BarberID INT FOREIGN KEY REFERENCES Barbers(BarberID),
    ClientID INT FOREIGN KEY REFERENCES Clients(ClientID),
    Feedback NVARCHAR(MAX),
    Rating NVARCHAR(50) CHECK (Rating IN ('very_bad', 'bad', 'normal', 'good', 'excellent'))
);

-- Расписание барберов
CREATE TABLE BarberSchedule (
    ScheduleID INT IDENTITY PRIMARY KEY,
    BarberID INT FOREIGN KEY REFERENCES Barbers(BarberID),
    Date DATE NOT NULL,
    TimeFrom TIME NOT NULL,
    TimeTo TIME NOT NULL,
    ClientID INT FOREIGN KEY REFERENCES Clients(ClientID)
);

-- Архив посещений
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

--Шаг 1 Заполняем данные

-- Заполняем позиции
INSERT INTO Positions (PositionName) VALUES
('chief-barber'),
('senior-barber'),
('junior-barber'),
('stylist'),
('apprentice');

SELECT * FROM Positions

-- Заполняем барберов
INSERT INTO Barbers (FullName, Gender, ContactPhone, Email, DateOfBirth, HireDate, PositionID) VALUES
('Иван Иванов', 'M', '123-456-7890', 'ivanov@example.com', '1980-06-15', '2015-01-01', 1),
('Алексей Смирнов', 'M', '234-567-8901', 'smirnov@example.com', '1990-07-20', '2016-02-01', 2),
('Мария Петрова', 'F', '345-678-9012', 'petrova@example.com', '1985-08-25', '2017-03-01', 3),
('Екатерина Сергеева', 'F', '456-789-0123', 'sergeeva@example.com', '1983-09-30', '2018-04-01', 2),
('Дмитрий Волков', 'M', '567-890-1234', 'volkov@example.com', '1995-05-05', '2019-05-01', 3);

SELECT * FROM Barbers

-- Заполняем клиентов
INSERT INTO Clients (FullName, ContactPhone, Email) VALUES
('Сергей Кузнецов', '678-901-2345', 'kuznetsov@example.com'),
('Елена Васильева', '789-012-3456', 'vasilieva@example.com'),
('Ольга Новикова', '890-123-4567', 'novikova@example.com'),
('Татьяна Морозова', '901-234-5678', 'morozova@example.com'),
('Андрей Белов', '012-345-6789', 'belov@example.com');

SELECT * FROM Clients

-- Заполняем услуги
INSERT INTO Services (ServiceName, Price, DurationInMinutes) VALUES
('Стрижка', 1500.00, 60),
('Бритьё бороды', 800.00, 30),
('Окраска', 2000.00, 120),
('Укладка', 1000.00, 40),
('Маска для волос', 500.00, 30);

SELECT * FROM Services

-- Заполняем фидбеки клиентов
INSERT INTO ClientFeedbacks (ClientID, BarberID, Feedback, Rating) VALUES
(1, 1, 'Отличная стрижка!', 'excellent'),
(2, 2, 'Неплохо, но могло быть и лучше.', 'good'),
(3, 3, 'Я осталась довольна услугой.', 'good'),
(4, 4, 'Не очень аккуратно.', 'normal'),
(5, 5, 'Великолепно, буду рекомендовать друзьям!', 'excellent');

SELECT * FROM ClientFeedbacks

-- Заполняем фидбеки барберов
INSERT INTO BarberFeedbacks (BarberID, ClientID, Feedback, Rating) VALUES
(1, 1, 'Пунктуальный клиент.', 'good'),
(2, 2, 'Замечательный разговор.', 'excellent'),
(3, 3, 'Были небольшие замечания.', 'normal'),
(4, 4, 'Клиент недоволен.', 'bad'),
(5, 5, 'Все прошло отлично!', 'excellent');

SELECT * FROM BarberFeedbacks

-- Заполняем расписание барберов
INSERT INTO BarberSchedule (BarberID, Date, TimeFrom, TimeTo, ClientID) VALUES
(1, '2024-04-25', '09:00', '10:00', 1),
(2, '2024-04-25', '10:00', '11:00', 2),
(3, '2024-04-25', '11:00', '12:00', 3),
(4, '2024-04-25', '12:00', '13:00', 4),
(5, '2024-04-25', '13:00', '14:00', 5);

SELECT * FROM BarberSchedule

-- Заполняем архив посещений
INSERT INTO VisitsArchive (ClientID, BarberID, ServiceID, VisitDate, TotalCost, Rating, Feedback) VALUES
(1, 1, 1, '2023-01-15', 1500.00, 'excellent', 'Хорошая стрижка и обслуживание.'),
(2, 2, 2, '2023-02-20', 800.00, 'good', 'Быстро и качественно.'),
(3, 3, 3, '2023-03-25', 2000.00, 'normal', 'Цвет не совсем тот, что хотелось.'),
(4, 4, 4, '2023-04-30', 1000.00, 'bad', 'Укладка не держится.'),
(5, 5, 5, '2023-05-05', 500.00, 'excellent', 'Волосы после маски шелковистые.');

SELECT * FROM VisitsArchive

--Шаг 2 

--1. Вернуть ФИО всех барберов салона
CREATE FUNCTION dbo.GetAllBarbersNames()
RETURNS TABLE
AS
RETURN
    SELECT FullName
    FROM Barbers;
GO

SELECT * FROM dbo.GetAllBarbersNames();

--2. Вернуть информацию о всех синьор-барберах
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

--3. Вернуть информацию о всех барберах, которые могут пре-
--доставить услугу традиционного бритья бороды
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

EXEC dbo.GetBarbersByService @ServiceName = 'Бритьё бороды';

--4. Вернуть информацию о всех барберах, которые могут пре-
--доставить конкретную услугу. Информация о требуемой
--услуге предоставляется в качестве параметра

EXEC dbo.GetBarbersByService @ServiceName = 'Стрижка';

--5. Вернуть информацию о всех барберах, которые работают
--свыше указанного количества лет. Количество лет переда-
--ётся в качестве параметра
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

--6. Вернуть количество синьор-барберов и количество джу-
--ниор-барберов
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

--7. Вернуть информацию о постоянных клиентах. Критерий
--постоянного клиента: был в салоне заданное количество
--раз. Количество передаётся в качестве параметра
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

--8. Запретить возможность удаления информации о чиф-бар-
--бере, если не добавлен второй чиф-барбер
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

--9. Запретить добавлять барберов младше 21 года.
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
VALUES ('Молодой Барбер', 'M', '987-654-3210', 'youngbarber@example.com', '2007-01-01', '2024-01-01', 1);


