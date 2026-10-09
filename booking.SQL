-- Localhost DB Setup
DROP DATABASE IF EXISTS RestaurantDB;
CREATE DATABASE RestaurantDB;
USE RestaurantDB;

-- Remote hosting DBs (one.com etc.)
-- We need to do this, because remote hosts does not allow us root access etc.
-- Tables are dropped in reverse order, so the foreign keys never block a drop.
DROP TABLE IF EXISTS Reservation;
DROP TABLE IF EXISTS `Table`;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Restaurant;


CREATE TABLE Restaurant
(
RestaurantID int AUTO_INCREMENT NOT NULL PRIMARY KEY,
Name varchar(100),
Phone varchar(20)
);


CREATE TABLE Customer
(
CustomerID int AUTO_INCREMENT NOT NULL PRIMARY KEY,
FirstName varchar(100),
LastName varchar(100),
Email varchar(255),
PhoneNumber varchar(20)
);


-- Table is a reserved word in MySQL, so it needs backticks
CREATE TABLE `Table`
(
TableID int AUTO_INCREMENT NOT NULL PRIMARY KEY,
Seats tinyint,
RestaurantID int NOT NULL,
FOREIGN KEY (RestaurantID) REFERENCES Restaurant (RestaurantID)
);


CREATE TABLE Reservation
(
ReservationID int AUTO_INCREMENT NOT NULL PRIMARY KEY,
`Time` time,
`Date` date,
NumberOfPeople tinyint,
Status enum('booked', 'seated', 'completed', 'cancelled', 'no-show'),
MetaData text,
CustomerID int NOT NULL,
TableID int NOT NULL,
FOREIGN KEY (CustomerID) REFERENCES Customer (CustomerID),
FOREIGN KEY (TableID) REFERENCES `Table` (TableID)
);


-- Restaurants
INSERT INTO Restaurant VALUES (NULL, 'Bistro Havnen', '+45 75 12 34 56');


-- Customers
INSERT INTO Customer VALUES (NULL, 'Emil', 'Jensen', 'emil.jensen@example.com', '+45 20 11 22 33');
INSERT INTO Customer VALUES (NULL, 'Sofie', 'Nielsen', 'sofie.nielsen@example.com', '+45 21 22 33 44');
INSERT INTO Customer VALUES (NULL, 'Lars', 'Hansen', 'lars.hansen@example.com', '+45 22 33 44 55');
INSERT INTO Customer VALUES (NULL, 'Maja', 'Pedersen', 'maja.pedersen@example.com', '+45 23 44 55 66');
INSERT INTO Customer VALUES (NULL, 'Oliver', 'Andersen', 'oliver.andersen@example.com', '+45 24 55 66 77');
INSERT INTO Customer VALUES (NULL, 'Freja', 'Christensen', 'freja.christensen@example.com', '+45 25 66 77 88');


-- Tables (all belong to Bistro Havnen)
INSERT INTO `Table` VALUES (NULL, 2, 1);
INSERT INTO `Table` VALUES (NULL, 2, 1);
INSERT INTO `Table` VALUES (NULL, 4, 1);
INSERT INTO `Table` VALUES (NULL, 6, 1);
INSERT INTO `Table` VALUES (NULL, 4, 1);
INSERT INTO `Table` VALUES (NULL, 8, 1);


-- Reservations (Time, Date, NumberOfPeople, Status, MetaData, CustomerID, TableID)
INSERT INTO Reservation VALUES (NULL, '18:00:00', '2026-10-15', 2, 'booked', 'Window seat please', 1, 1);
INSERT INTO Reservation VALUES (NULL, '19:30:00', '2026-10-15', 4, 'booked', NULL, 2, 3);
INSERT INTO Reservation VALUES (NULL, '17:30:00', '2026-10-16', 6, 'booked', 'Birthday dinner, needs a cake', 3, 4);
INSERT INTO Reservation VALUES (NULL, '20:00:00', '2026-10-12', 2, 'completed', 'Anniversary', 4, 2);
INSERT INTO Reservation VALUES (NULL, '18:30:00', '2026-10-10', 4, 'completed', NULL, 5, 5);
INSERT INTO Reservation VALUES (NULL, '19:00:00', '2026-10-17', 8, 'booked', 'Company dinner, one vegetarian guest', 6, 6);
INSERT INTO Reservation VALUES (NULL, '18:00:00', '2026-10-09', 2, 'cancelled', 'Cancelled by customer', 1, 1);
INSERT INTO Reservation VALUES (NULL, '20:00:00', '2026-10-08', 4, 'no-show', NULL, 3, 5);
INSERT INTO Reservation VALUES (NULL, '12:00:00', '2026-10-18', 2, 'booked', 'Allergic to nuts', 2, 2);
INSERT INTO Reservation VALUES (NULL, '18:30:00', '2026-10-20', 4, 'booked', NULL, 5, 3);


-- QUERIES

-- 1. Get a list of all tables in the restaurant (overview for the front-end)
SELECT t.TableID, t.Seats, r.Name AS Restaurant
FROM `Table` t
INNER JOIN Restaurant r ON t.RestaurantID = r.RestaurantID
ORDER BY r.Name, t.TableID;


-- 2. Get a list of all bookings for a given customer (when they arrive), ordered by date
-- Change CustomerID = 1 to look up another customer
SELECT res.ReservationID, res.`Date`, res.`Time`, res.NumberOfPeople, res.Status, res.TableID, r.Name AS Restaurant
FROM Reservation res
INNER JOIN `Table` t ON res.TableID = t.TableID
INNER JOIN Restaurant r ON t.RestaurantID = r.RestaurantID
WHERE res.CustomerID = 1
ORDER BY res.`Date`, res.`Time`;


-- 3. Get a list of all bookings for a given TableID, including the customers, for a specific date
-- Change TableID = 3 and the date to look up another table or day
SELECT res.ReservationID, res.`Time`, res.NumberOfPeople, res.Status, c.FirstName, c.LastName, c.PhoneNumber
FROM Reservation res
INNER JOIN Customer c ON res.CustomerID = c.CustomerID
WHERE res.TableID = 3
AND res.`Date` = '2026-10-15'
ORDER BY res.`Time`;



-- 1. All tables (overview for the front-end)
SELECT TableID, Seats, Name as Restaurnat
FROM `Table` t
INNER JOIN Restaurant r ON t.RestaurantID = r.RestaurantID
ORDER BY r.Name, t.TableID;

-- 2. All bookings for a given customer, ordered by date
SELECT res.ReservationID, `Date`, `Time`, NumberOfPeople, Status, res.TableID, r.Name AS Restaurant
FROM Reservation res
INNER JOIN `Table` t ON res.TableID = t.TableID
INNER JOIN Restaurant r ON t.RestaurantID = r.RestaurantID
WHERE res.CustomerID = 1
ORDER BY res.`Date`, res.`Time`;

-- 3. All bookings for a given table on a specific date, with customer details
SELECT res.ReservationID, `Time`, NumberOfPeople, Status, c.FirstName, c.LastName, c.PhoneNumber
FROM Reservation res
INNER JOIN Customer c ON res.CustomerID = c.CustomerID
WHERE res.TableID = 3
AND res.`Date` = '2026-10-15'
ORDER BY res.`Time`;