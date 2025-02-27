DELIMITER 

-- Add new car
CREATE PROCEDURE AddCar(
    IN p_model VARCHAR(100),
    IN p_brand VARCHAR(100),
    IN p_year INT
)
BEGIN
    INSERT INTO car (model, brand, year, status)
    VALUES (p_model, p_brand, p_year, 'available');
END //

-- Update car status
CREATE PROCEDURE UpdateCarStatus(
    IN p_car_id INT,
    IN p_status VARCHAR(20)
)
BEGIN
    UPDATE car
    SET status = p_status
    WHERE car_id = p_car_id;
END //

-- Get available cars
CREATE PROCEDURE GetAvailableCars(
    IN p_start_date DATE,
    IN p_end_date DATE
)
BEGIN
    SELECT c.*
    FROM car c
    WHERE c.car_id NOT IN (
        SELECT r.car_id
        FROM reservation r
        WHERE r.start_date <= p_end_date 
        AND r.end_date >= p_start_date
    )
    AND c.status = 'available';
END //

DELIMITER ;