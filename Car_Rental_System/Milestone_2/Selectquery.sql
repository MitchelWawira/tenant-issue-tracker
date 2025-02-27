-- Get customer details
SELECT * FROM customer;

--List all available cars
SELECT car_id, brand, model, year 
FROM car 
WHERE status = 'available';

--Get all active reservations with customer and car details
SELECT 
    r.reservation_id,
    c.name AS customer_name,
    car.brand,
    car.model,
    r.start_date,
    r.end_date
FROM reservation r
JOIN customer c ON r.customer_id = c.customer_id
JOIN car ON r.car_id = car.car_id
WHERE r.end_date >= CURRENT_DATE;

--Get payment history for a specific customer
SELECT 
    p.payment_id,
    p.amount,
    p.payment_date,
    p.status,
    car.brand,
    car.model
FROM payment p
JOIN reservation r ON p.reservation_id = r.reservation_id
JOIN car ON r.car_id = car.car_id
WHERE r.customer_id = [customer_id];

-- Find total revenue by car
SELECT 
    car.brand,
    car.model,
    SUM(p.amount) as total_revenue
FROM car
JOIN reservation r ON car.car_id = r.car_id
JOIN payment p ON r.reservation_id = p.reservation_id
WHERE p.status = 'completed'
GROUP BY car.car_id, car.brand, car.model;

-- Get customers with active reservations
SELECT DISTINCT
    c.customer_id,
    c.name,
    c.email,
    c.phone
FROM customer c
JOIN reservation r ON c.customer_id = r.customer_id
WHERE r.end_date >= CURRENT_DATE;

--Find overdue payments
SELECT 
    p.payment_id,
    c.name AS customer_name,
    p.amount,
    p.payment_date,
    p.status
FROM payment p
JOIN reservation r ON p.reservation_id = r.reservation_id
JOIN customer c ON r.customer_id = c.customer_id
WHERE p.status = 'pending'
AND p.payment_date < CURRENT_DATE;