-- 1. Get a list of all tables in the restaurant (overview for the front-end)
SELECT TableID, Seats, Name as Restaurnat
FROM `Table` t
INNER JOIN Restaurant r ON t.RestaurantID = r.RestaurantID
ORDER BY r.Name, t.TableID;

-- 2. Get a list of all bookings for a given customer (when they arrive at the restaurant) ordered by date
SELECT res.ReservationID, `Date`, `Time`, NumberOfPeople, Status, res.TableID, r.Name AS Restaurant
FROM Reservation res
INNER JOIN `Table` t ON res.TableID = t.TableID
INNER JOIN Restaurant r ON t.RestaurantID = r.RestaurantID
WHERE res.CustomerID = 1
ORDER BY res.`Date`, res.`Time`;

-- 3. Get a list of all bookings for a given tableID, including the customers for a specific date
SELECT res.ReservationID, `Time`, NumberOfPeople, Status, c.FirstName, c.LastName, c.PhoneNumber
FROM Reservation res
INNER JOIN Customer c ON res.CustomerID = c.CustomerID
WHERE res.TableID = 3
AND res.`Date` = '2026-10-15'
ORDER BY res.`Time`;