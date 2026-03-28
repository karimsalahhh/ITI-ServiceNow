-- users table

CREATE TABLE users (
user_id SERIAL PRIMARY KEY,
user_name VARCHAR(100) NOT NULL,
user_email VARCHAR(150) NOT NULL UNIQUE,
user_phone VARCHAR(20) UNIQUE,
user_password VARCHAR(255) NOT NULL,
user_role VARCHAR(20) NOT NULL,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT check_user_role CHECK (user_role IN ('customer', 'admin'))
);

SELECT * FROM users;


-- insert users

INSERT INTO users (user_name, user_email, user_phone, user_password, user_role)
VALUES
('Karim Salah', 'karim@gmail.com', '01011111111', 'pass123', 'customer'),
('Ahmet Fathy', 'ahmet@gmail.com', '01022222222', 'pass456', 'customer'),
('Omar Mohammed', 'omar@gmail.com', '01033333333', 'pass789', 'customer'),
('Reem Al Taher', 'reem@gmail.com', '01044444444', 'admin123', 'admin');

SELECT user_id, user_name, user_email, user_role
FROM users;


-- hotels table

CREATE TABLE hotels (
hotel_id SERIAL PRIMARY KEY,
hotel_name VARCHAR(100) NOT NULL,
hotel_location VARCHAR(100) NOT NULL,
hotel_rating NUMERIC(2,1) NOT NULL,
hotel_description TEXT,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT check_hotel_rating CHECK (hotel_rating BETWEEN 1 AND 5)
);

SELECT * FROM hotels;


-- insert hotels

INSERT INTO hotels (hotel_name, hotel_location, hotel_rating, hotel_description)
VALUES
('Hilton', 'Hurghada', 4.6, 'A beach hotel with comfortable rooms and sea view'),
('Four Seasons', 'Cairo', 4.8, 'A luxury hotel in Cairo with elegant rooms and great service'),
('Novotel', 'North Coast', 4.2, 'A modern hotel close to the beach and summer places'),
('Rixos', 'Hurghada', 4.7, 'A resort hotel with pools private beach and family activities');

SELECT hotel_id, hotel_name, hotel_location, hotel_rating
FROM hotels;


-- rooms table

CREATE TABLE rooms (
room_id SERIAL PRIMARY KEY,
hotel_id INT NOT NULL,
room_number VARCHAR(10) NOT NULL,
room_type VARCHAR(50) NOT NULL,
room_price NUMERIC(10,2) NOT NULL,
room_capacity INT NOT NULL,
is_available BOOLEAN DEFAULT TRUE,
CONSTRAINT fk_room_hotel FOREIGN KEY (hotel_id) REFERENCES hotels(hotel_id) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT unique_room_number_per_hotel UNIQUE (hotel_id, room_number),
CONSTRAINT check_room_price CHECK (room_price > 0),
CONSTRAINT check_room_capacity CHECK (room_capacity > 0)
);

SELECT * FROM rooms;


-- insert rooms

INSERT INTO rooms (hotel_id, room_number, room_type, room_price, room_capacity, is_available)
VALUES
(1, '101', 'Single', 1800.00, 1, TRUE),
(1, '102', 'Double', 2600.00, 2, TRUE),
(2, '201', 'Suite', 4200.00, 4, TRUE),
(3, '301', 'Double', 2400.00, 2, TRUE),
(4, '401', 'Suite', 4600.00, 4, TRUE),
(4, '402', 'Single', 2100.00, 1, TRUE);

SELECT hotel_id, room_number, room_type, room_price, room_capacity, is_available
FROM rooms;


-- flights table

CREATE TABLE flights (
flight_id SERIAL PRIMARY KEY,
airline_name VARCHAR(100) NOT NULL,
departure_location VARCHAR(100) NOT NULL,
arrival_location VARCHAR(100) NOT NULL,
departure_time TIMESTAMP NOT NULL,
arrival_time TIMESTAMP NOT NULL,
flight_price NUMERIC(10,2) NOT NULL,
available_seats INT NOT NULL,
CONSTRAINT check_flight_price CHECK (flight_price > 0),
CONSTRAINT check_available_seats CHECK (available_seats >= 0),
CONSTRAINT check_flight_time CHECK (departure_time < arrival_time)
);

SELECT * FROM flights;


-- insert flights

INSERT INTO flights (
airline_name,
departure_location,
arrival_location,
departure_time,
arrival_time,
flight_price,
available_seats
)
VALUES
('EgyptAir', 'Cairo', 'Hurghada', '2026-04-10 08:00:00', '2026-04-10 09:10:00', 3200.00, 90),
('Air Cairo', 'Cairo', 'North Coast', '2026-04-11 07:30:00', '2026-04-11 08:40:00', 2800.00, 75),
('Nile Air', 'Hurghada', 'Cairo', '2026-04-13 06:45:00', '2026-04-13 07:55:00', 3000.00, 88),
('EgyptAir', 'North Coast', 'Cairo', '2026-04-14 09:20:00', '2026-04-14 10:35:00', 2900.00, 82);

SELECT flight_id, airline_name, departure_location, arrival_location, flight_price, available_seats
FROM flights;


-- hotel bookings table

CREATE TABLE hotel_bookings (
hotel_booking_id SERIAL PRIMARY KEY,
user_id INT NOT NULL,
room_id INT NOT NULL,
check_in_date DATE NOT NULL,
check_out_date DATE NOT NULL,
total_days INT NOT NULL,
total_amount NUMERIC(10,2) NOT NULL,
booking_status VARCHAR(20) DEFAULT 'confirmed',
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT fk_hotel_booking_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT fk_hotel_booking_room FOREIGN KEY (room_id) REFERENCES rooms(room_id) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT check_booking_dates CHECK (check_out_date > check_in_date),
CONSTRAINT check_total_days CHECK (total_days > 0),
CONSTRAINT check_total_amount CHECK (total_amount > 0),
CONSTRAINT check_booking_status CHECK (booking_status IN ('confirmed', 'cancelled'))
);

SELECT * FROM hotel_bookings;


-- insert hotel booking

INSERT INTO hotel_bookings (
user_id,
room_id,
check_in_date,
check_out_date,
total_days,
total_amount,
booking_status
)
SELECT
1,
r.room_id,
DATE '2026-04-10',
DATE '2026-04-12',
DATE '2026-04-12' - DATE '2026-04-10',
r.room_price * (DATE '2026-04-12' - DATE '2026-04-10'),
'confirmed'
FROM rooms r
WHERE r.room_id = 1
AND NOT EXISTS (
SELECT 1
FROM hotel_bookings hb
WHERE hb.room_id = r.room_id
AND hb.booking_status = 'confirmed'
AND DATE '2026-04-10' < hb.check_out_date
AND DATE '2026-04-12' > hb.check_in_date
);

SELECT hotel_booking_id, user_id, room_id, check_in_date, check_out_date, total_days, total_amount, booking_status
FROM hotel_bookings;


-- flight bookings table

CREATE TABLE flight_bookings (
flight_booking_id SERIAL PRIMARY KEY,
user_id INT NOT NULL,
flight_id INT NOT NULL,
seat_number VARCHAR(10) NOT NULL,
booking_status VARCHAR(20) NOT NULL DEFAULT 'confirmed',
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT fk_flight_booking_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT fk_flight_booking_flight FOREIGN KEY (flight_id) REFERENCES flights(flight_id) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT unique_flight_seat UNIQUE (flight_id, seat_number),
CONSTRAINT check_flight_booking_status CHECK (booking_status IN ('confirmed', 'cancelled'))
);

SELECT * FROM flight_bookings;


-- insert flight bookings

INSERT INTO flight_bookings (user_id, flight_id, seat_number, booking_status)
VALUES
(1, 1, 'A1', 'confirmed'),
(2, 2, 'B3', 'confirmed'),
(3, 3, 'A2', 'confirmed'),
(1, 4, 'C1', 'confirmed');

SELECT flight_booking_id, user_id, flight_id, seat_number, booking_status
FROM flight_bookings;


-- payments table

CREATE TABLE payments (
payment_id SERIAL PRIMARY KEY,
flight_booking_id INT,
hotel_booking_id INT,
payment_amount NUMERIC(10,2) NOT NULL,
payment_method VARCHAR(20) NOT NULL,
payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT fk_payment_flight_booking FOREIGN KEY (flight_booking_id) REFERENCES flight_bookings(flight_booking_id) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT fk_payment_hotel_booking FOREIGN KEY (hotel_booking_id) REFERENCES hotel_bookings(hotel_booking_id) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT check_payment_amount CHECK (payment_amount > 0),
CONSTRAINT check_payment_method CHECK (payment_method IN ('cash', 'card', 'online')),
CONSTRAINT check_one_booking_only CHECK (
(flight_booking_id IS NOT NULL AND hotel_booking_id IS NULL)
OR
(flight_booking_id IS NULL AND hotel_booking_id IS NOT NULL)
)
);

SELECT * FROM payments;


-- insert payments

INSERT INTO payments (flight_booking_id, hotel_booking_id, payment_amount, payment_method)
VALUES
(1, NULL, 3200.00, 'card'),
(2, NULL, 2800.00, 'online'),
(NULL, 1, 3600.00, 'cash');

SELECT payment_id, flight_booking_id, hotel_booking_id, payment_amount, payment_method
FROM payments;


-- reviews table

CREATE TABLE reviews (
review_id SERIAL PRIMARY KEY,
user_id INT NOT NULL,
hotel_id INT NOT NULL,
review_rating INT NOT NULL,
review_comment TEXT,
review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT fk_review_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT fk_review_hotel FOREIGN KEY (hotel_id) REFERENCES hotels(hotel_id) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT check_review_rating CHECK (review_rating BETWEEN 1 AND 5),
CONSTRAINT unique_user_review UNIQUE (user_id, hotel_id)
);

SELECT * FROM reviews;


-- insert reviews

INSERT INTO reviews (user_id, hotel_id, review_rating, review_comment)
VALUES
(1, 1, 5, 'Very nice hotel and clean rooms'),
(2, 2, 4, 'Great location and good service'),
(3, 4, 5, 'Amazing resort and friendly staff');

SELECT review_id, user_id, hotel_id, review_rating, review_comment
FROM reviews;



SELECT * FROM users;
SELECT * FROM hotels;
SELECT * FROM rooms;
SELECT * FROM flights;
SELECT * FROM hotel_bookings;
SELECT * FROM flight_bookings;
SELECT * FROM payments;
SELECT * FROM reviews;


-- hotel booking transaction

BEGIN;

INSERT INTO hotel_bookings (
user_id,
room_id,
check_in_date,
check_out_date,
total_days,
total_amount,
booking_status

SELECT
2,
r.room_id,
DATE '2026-05-01',
DATE '2026-05-03',
DATE '2026-05-03' - DATE '2026-05-01',
r.room_price * (DATE '2026-05-03' - DATE '2026-05-01'),
'confirmed'
FROM rooms r
WHERE r.room_id = 2
AND NOT EXISTS (
SELECT 1
FROM hotel_bookings hb
WHERE hb.room_id = r.room_id
AND hb.booking_status = 'confirmed'
AND DATE '2026-05-01' < hb.check_out_date
AND DATE '2026-05-03' > hb.check_in_date
);

INSERT INTO payments (
flight_booking_id,
hotel_booking_id,
payment_amount,
payment_method
)
SELECT
NULL,
currval('hotel_bookings_hotel_booking_id_seq'),
total_amount,
'card'
FROM hotel_bookings
WHERE hotel_booking_id = currval('hotel_bookings_hotel_booking_id_seq');

COMMIT;


-- check committed booking and payment

SELECT
hb.hotel_booking_id,
hb.user_id,
hb.room_id,
hb.check_in_date,
hb.check_out_date,
hb.total_days,
hb.total_amount,
hb.booking_status,
p.payment_id,
p.payment_amount,
p.payment_method
FROM hotel_bookings hb
JOIN payments p ON hb.hotel_booking_id = p.hotel_booking_id
WHERE hb.user_id = 2
AND hb.room_id = 2
AND hb.check_in_date = DATE '2026-05-01'
AND hb.check_out_date = DATE '2026-05-03';



INSERT INTO users (user_name, user_email, user_phone, user_password, user_role)
VALUES ('Mona Adel', 'mona@gmail.com', '01055555555', 'pass999', 'customer');

INSERT INTO hotel_bookings (
user_id,
room_id,
check_in_date,
check_out_date,
total_days,
total_amount,
booking_status
)
SELECT
5,
r.room_id,
DATE '2026-06-01',
DATE '2026-06-04',
DATE '2026-06-04' - DATE '2026-06-01',
r.room_price * (DATE '2026-06-04' - DATE '2026-06-01'),
'confirmed'
FROM rooms r
WHERE r.room_id = 3
AND NOT EXISTS (
SELECT 1
FROM hotel_bookings hb
WHERE hb.room_id = r.room_id
AND hb.booking_status = 'confirmed'
AND DATE '2026-06-01' < hb.check_out_date
AND DATE '2026-06-04' > hb.check_in_date
);


--overlap check 

SELECT *
FROM hotel_bookings hb
WHERE hb.room_id = 2
AND hb.booking_status = 'confirmed'
AND DATE '2026-05-02' < hb.check_out_date
AND DATE '2026-05-04' > hb.check_in_date;



--an insert attempt for the same overlapping dates using NOT EXISTS
INSERT INTO hotel_bookings (
user_id,
room_id,
check_in_date,
check_out_date,
total_days,
total_amount,
booking_status
)
SELECT
3,
r.room_id,
DATE '2026-05-02',
DATE '2026-05-04',
DATE '2026-05-04' - DATE '2026-05-02',
r.room_price * (DATE '2026-05-04' - DATE '2026-05-02'),
'confirmed'
FROM rooms r
WHERE r.room_id = 2
AND NOT EXISTS (
SELECT 1
FROM hotel_bookings hb
WHERE hb.room_id = r.room_id
AND hb.booking_status = 'confirmed'
AND DATE '2026-05-02' < hb.check_out_date
AND DATE '2026-05-04' > hb.check_in_date
);

-- users who booked a hotel but never booked a flight

SELECT
u.user_id,
u.user_name,
u.user_email,
u.user_phone,
h.hotel_location
FROM users u
JOIN hotel_bookings hb ON u.user_id = hb.user_id
JOIN rooms r ON hb.room_id = r.room_id
JOIN hotels h ON r.hotel_id = h.hotel_id
WHERE u.user_id IN (
SELECT hb.user_id
FROM hotel_bookings hb
)
AND u.user_id NOT IN (
SELECT fb.user_id
FROM flight_bookings fb
);

--hotels that get booked without flights
SELECT
h.hotel_location,
h.hotel_name,
COUNT(hb.hotel_booking_id) AS hotel_only_bookings
FROM hotel_bookings hb
JOIN rooms r ON hb.room_id = r.room_id
JOIN hotels h ON r.hotel_id = h.hotel_id
WHERE hb.booking_status = 'confirmed'
AND hb.user_id NOT IN (
SELECT fb.user_id
FROM flight_bookings fb
WHERE fb.booking_status = 'confirmed'
)
GROUP BY h.hotel_location,h.hotel_name
ORDER BY hotel_only_bookings DESC;

-- top 3 most booked hotels

SELECT
h.hotel_name,
COUNT(hb.hotel_booking_id) AS total_bookings
FROM hotels h
JOIN rooms r ON h.hotel_id = r.hotel_id
JOIN hotel_bookings hb ON r.room_id = hb.room_id
WHERE hb.booking_status = 'confirmed'
GROUP BY h.hotel_id, h.hotel_name
ORDER BY total_bookings DESC
LIMIT 3;


-- total revenue for each hotel

SELECT
h.hotel_name,
SUM(hb.total_amount) AS total_revenue
FROM hotels h
JOIN rooms r ON h.hotel_id = r.hotel_id
JOIN hotel_bookings hb ON r.room_id = hb.room_id
WHERE hb.booking_status = 'confirmed'
GROUP BY h.hotel_id, h.hotel_name
ORDER BY total_revenue DESC;


-- total revenue for a specific hotel

SELECT
h.hotel_name,
SUM(hb.total_amount) AS total_revenue
FROM hotels h
JOIN rooms r ON h.hotel_id = r.hotel_id
JOIN hotel_bookings hb ON r.room_id = hb.room_id
WHERE hb.booking_status = 'confirmed'
AND h.hotel_name = 'Hilton'
GROUP BY h.hotel_id, h.hotel_name;


-- cancelled booking added before cancellation report

INSERT INTO hotel_bookings (
user_id,
room_id,
check_in_date,
check_out_date,
total_days,
total_amount,
booking_status
)
SELECT
1,
r.room_id,
DATE '2026-04-25',
DATE '2026-04-27',
DATE '2026-04-27' - DATE '2026-04-25',
r.room_price * (DATE '2026-04-27' - DATE '2026-04-25'),
'cancelled'
FROM rooms r
WHERE r.room_id = 2;


-- cancelled bookings from hotel and flight

SELECT
'Hotel' AS booking_type,
hotel_booking_id AS booking_id,
hotel_name AS service_name,
user_id,
booking_status,
hb.created_at
FROM hotel_bookings hb
JOIN rooms r ON hb.room_id=r.room_id
JOIN hotels h ON r.hotel_id=h.hotel_id
WHERE booking_status = 'cancelled'

UNION ALL

SELECT
'Flight' AS booking_type,
fb.flight_booking_id AS booking_id,
f.airline_name AS service_name,
fb.user_id,
fb.booking_status,
fb.created_at
FROM flight_bookings fb
JOIN flights f ON fb.flight_id=f.flight_id
WHERE booking_status = 'cancelled'
ORDER BY created_at;


-- average rating for each hotel

SELECT
h.hotel_name,
ROUND(AVG(rv.review_rating), 2) AS average_rating
FROM hotels h
JOIN reviews rv ON h.hotel_id = rv.hotel_id
GROUP BY h.hotel_id, h.hotel_name
ORDER BY average_rating DESC;


-- hotel rating category

SELECT
hotel_name,
hotel_location,
hotel_rating,
CASE
WHEN hotel_rating >= 4.5 THEN 'Excellent'
WHEN hotel_rating >= 4.0 THEN 'Very Good'
ELSE 'Good'
END AS rating_category
FROM hotels
ORDER BY hotel_rating DESC;


-- available rooms in cairo for specific dates

SELECT
h.hotel_name,
h.hotel_location,
r.room_id,
r.room_number,
r.room_type,
r.room_price,
r.room_capacity
FROM hotels h
JOIN rooms r ON h.hotel_id = r.hotel_id
WHERE h.hotel_location = 'Cairo'
AND r.is_available = TRUE
AND NOT EXISTS (
SELECT 1
FROM hotel_bookings hb
WHERE hb.room_id = r.room_id
AND hb.booking_status = 'confirmed'
AND DATE '2026-04-10' < hb.check_out_date
AND DATE '2026-04-12' > hb.check_in_date
)
ORDER BY r.room_price ASC;


-- available rooms in hurghada for specific dates

SELECT
h.hotel_name,
h.hotel_location,
r.room_id,
r.room_number,
r.room_type,
r.room_price,
r.room_capacity
FROM hotels h
JOIN rooms r ON h.hotel_id = r.hotel_id
WHERE h.hotel_location = 'Hurghada'
AND r.is_available = TRUE
AND NOT EXISTS (
SELECT 1
FROM hotel_bookings hb
WHERE hb.room_id = r.room_id
AND hb.booking_status = 'confirmed'
AND DATE '2026-04-25' < hb.check_out_date
AND DATE '2026-04-27' > hb.check_in_date
)
ORDER BY r.room_price ASC;


-- cheapest flights from cairo to hurghada

SELECT
flight_id,
airline_name,
departure_location,
arrival_location,
departure_time,
flight_price,
available_seats
FROM flights
WHERE departure_location = 'Cairo'+
AND arrival_location = 'Hurghada'
AND available_seats > 0
ORDER BY flight_price ASC, departure_time ASC;


-- top 3 busiest flight routes

SELECT
departure_location,
arrival_location,
COUNT(fb.flight_booking_id) AS total_bookings
FROM flights f
JOIN flight_bookings fb ON f.flight_id = fb.flight_id
WHERE fb.booking_status = 'confirmed'
GROUP BY departure_location, arrival_location
ORDER BY total_bookings DESC
LIMIT 3;


-- payment method performance

SELECT
payment_method,
COUNT(payment_id) AS total_payments,
SUM(payment_amount) AS total_revenue,
ROUND(AVG(payment_amount), 2) AS average_payment
FROM payments
GROUP BY payment_method
ORDER BY total_revenue DESC;


-- hotels with the highest cancellation count

SELECT
h.hotel_name,
COUNT(hb.hotel_booking_id) AS cancelled_bookings
FROM hotels h
JOIN rooms r ON h.hotel_id = r.hotel_id
JOIN hotel_bookings hb ON r.room_id = hb.room_id
WHERE hb.booking_status = 'cancelled'
GROUP BY h.hotel_id, h.hotel_name
ORDER BY cancelled_bookings DESC;