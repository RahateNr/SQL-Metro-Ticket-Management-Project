CREATE DATABASE metro_db;
USE metro_db;

CREATE TABLE stations (
    station_id INT PRIMARY KEY AUTO_INCREMENT,
    station_name VARCHAR(50) UNIQUE NOT NULL,
    zone VARCHAR(10) NOT NULL
);

INSERT INTO stations (station_name, zone) VALUES
('Sitabuldi Interchange', 'A'),
('Congress Nagar', 'A'),
('Lokmat Square', 'B'),
('Rahate Colony', 'B'),
('Airport South', 'C'),
('Wardha Road Terminal', 'C');


CREATE TABLE passengers (
    passenger_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    phone VARCHAR(10) UNIQUE,
    age INT CHECK (age >= 5),
    gender VARCHAR(10)
);

INSERT INTO passengers (name, phone, age, gender) VALUES
('Neelesh Pawar', '9897012345', 27, 'Male'),
('Prerna Kulkarni', '9822100456', 34, 'Female'),
('Tanishq Borkar', '9033456712', 19, 'Male'),
('Rekha Deshmukh', '9123007894', 48, 'Female'),
('Mahadev Kamble', '7500891234', 62, 'Male'),
('Sharda More', '8080332211', 66, 'Female'),
('Rutuja Wankhede', '7878123456', 29, 'Female'),
('Yashwant Thakre', '7700124589', 54, 'Male');



    
    
    CREATE TABLE tickets (
    ticket_id INT PRIMARY KEY AUTO_INCREMENT,
    passenger_id INT,
    source_station INT,
    destination_station INT,
    ticket_type VARCHAR(20),
    fare INT CHECK (fare > 0),
    travel_date DATE,

    FOREIGN KEY (passenger_id) REFERENCES passengers(passenger_id),
    FOREIGN KEY (source_station) REFERENCES stations(station_id),
    FOREIGN KEY (destination_station) REFERENCES stations(station_id),

    CHECK (source_station <> destination_station)
);



INSERT INTO tickets
(passenger_id, source_station, destination_station, ticket_type, fare, travel_date)
VALUES
(1, 1, 3, 'Single', 45, CURDATE()),
(2, 2, 5, 'Return', 85, CURDATE()),
(3, 3, 6, 'Monthly', 1350, CURDATE()),
(4, 4, 1, 'Single', 38, '2025-12-27'),
(5, 5, 2, 'Single', 55, CURDATE()),
(6, 6, 4, 'Return', 95, CURDATE()),
(7, 2, 3, 'Single', 52, '2025-12-26'),
(8, 1, 6, 'Monthly', 1600, CURDATE()),
(3, 4, 2, 'Single', 48, CURDATE()),
(2, 3, 5, 'Return', 78, '2025-12-29');





-- task 3--
  
  -- 1. Display all stations
SELECT * FROM stations;

-- 2. Display all passengers
SELECT * FROM passengers;

-- 3. Display all tickets
SELECT * FROM tickets;

-- 4. Passenger name & fare paid
SELECT p.name, t.fare
FROM passengers p
JOIN tickets t USING(passenger_id);

-- 5. Tickets booked today
SELECT * FROM tickets
WHERE travel_date = CURDATE();


--  task 4 -- 

-- 1. Passengers above age 60
SELECT * FROM passengers WHERE age > 60;

-- 2. Tickets with fare greater than 50
SELECT * FROM tickets WHERE fare > 50;

-- 3. Monthly tickets
SELECT * FROM tickets WHERE ticket_type = 'Monthly';

-- 4. Passengers who booked from station 1
SELECT DISTINCT p.*
FROM passengers p
JOIN tickets t USING(passenger_id)
WHERE t.source_station = 1;

 
 
 -- task 5 --
 -- 1. Highest fare first
SELECT * FROM tickets ORDER BY fare DESC;

-- 2. Top 3 most expensive tickets
SELECT * FROM tickets ORDER BY fare DESC LIMIT 3;

-- 3. Passengers sorted by age
SELECT * FROM passengers ORDER BY age ASC;


-- task 6 --
-- 1. Total revenue
SELECT SUM(fare) AS total_revenue FROM tickets;

-- 2. Average ticket fare
SELECT AVG(fare) AS avg_fare FROM tickets;

-- 3. Maximum & Minimum fare
SELECT MAX(fare) AS max_fare, MIN(fare) AS min_fare FROM tickets;

-- 4. Number of tickets per ticket type
SELECT ticket_type, COUNT(*) AS total
FROM tickets
GROUP BY ticket_type;

-- 5. Count passengers zone-wise
SELECT s.zone, COUNT(DISTINCT t.passenger_id) AS passenger_count
FROM tickets t
JOIN stations s ON t.source_station = s.station_id
GROUP BY s.zone;



-- task 7-- 
-- 1. Passenger name + source + destination + fare
SELECT p.name,
       s1.station_name AS source_station,
       s2.station_name AS destination_station,
       t.fare
FROM tickets t
JOIN passengers p USING(passenger_id)
JOIN stations s1 ON t.source_station = s1.station_id
JOIN stations s2 ON t.destination_station = s2.station_id;

-- 2. Ticket details with phone number
SELECT p.name, p.phone, t.*
FROM tickets t
JOIN passengers p USING(passenger_id);

-- 3. Tickets with station names
SELECT t.ticket_id,
       s1.station_name AS source,
       s2.station_name AS destination
FROM tickets t
JOIN stations s1 ON t.source_station = s1.station_id
JOIN stations s2 ON t.destination_station = s2.station_id;

-- task 8 --
-- 1. Increase fare by 10 where fare < 30
UPDATE tickets SET fare = fare + 10 WHERE fare < 30;

-- 2. Change ticket type Single → Return for a passenger
UPDATE tickets
SET ticket_type = 'Return'
WHERE passenger_id = 1;

-- 3. Delete tickets before a specific date
DELETE FROM tickets
WHERE travel_date < '2025-12-20';

-- task 9-- 
-- 1. Passengers who paid more than average fare
SELECT DISTINCT p.*
FROM passengers p
JOIN tickets t USING(passenger_id)
WHERE t.fare > (SELECT AVG(fare) FROM tickets);

-- 2. Station with maximum bookings
SELECT source_station, COUNT(*) AS total_tickets
FROM tickets
GROUP BY source_station
ORDER BY total_tickets DESC
LIMIT 1;

-- 3. Passengers who booked more than one ticket
SELECT passenger_id, COUNT(*) AS total_tickets
FROM tickets
GROUP BY passenger_id
HAVING COUNT(*) > 1;


-- task 10 --
CREATE VIEW daily_revenue AS
SELECT travel_date, SUM(fare) AS total_fare
FROM tickets
GROUP BY travel_date;

-- Fetch from view
SELECT * FROM daily_revenue; 

-- task 11 -- 
-- Identify eligible passengers (age >= 60)
SELECT * FROM passengers WHERE age >= 60;

-- Apply 20% discount
UPDATE tickets t
JOIN passengers p ON t.passenger_id = p.passenger_id
SET t.fare = ROUND(t.fare * 0.8)
WHERE p.age >= 60;





 



  