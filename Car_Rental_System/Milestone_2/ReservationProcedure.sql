DELIMITER //

-- Create new reservation
CREATE PROCEDURE CreateReservation(
    IN p_customer_id INT,
    IN p_car_id INT,
    IN p_start_date DATE,
    IN p_end_date DATE,
    IN p_amount DECIMAL(10,2)
)
BEGIN
    DECLARE v_reservation_id INT;
    
    START TRANSACTION;
    
    -- Check if car is available
    IF NOT EXISTS (
        SELECT 1 FROM reservation 
        WHERE car_id = p_car_id 
        AND start_date <= p_end_date 
        AND end_date >= p_start_date
    ) THEN
        -- Create reservation
        INSERT INTO reservation (customer_id, car_id, start_date, end_date)
        VALUES (p_customer_id, p_car_id, p_start_date, p_end_date);
        
        SET v_reservation_id = LAST_INSERT_ID();
        
        -- Create payment record
        INSERT INTO payment (reservation_id, amount, payment_date, status)
        VALUES (v_reservation_id, p_amount, CURDATE(), 'pending');
        
        -- Update car status
        UPDATE car SET status = 'reserved' WHERE car_id = p_car_id;
        
        COMMIT;
        SELECT 'Reservation created successfully' AS message;
    ELSE
        ROLLBACK;
        SELECT 'Car not available for selected dates' AS message;
    END IF;
END //

-- Cancel reservation
CREATE PROCEDURE CancelReservation(
    IN p_reservation_id INT
)
BEGIN
    START TRANSACTION;
    
    UPDATE car c
    JOIN reservation r ON c.car_id = r.car_id
    SET c.status = 'available'
    WHERE r.reservation_id = p_reservation_id;
    
    DELETE FROM reservation WHERE reservation_id = p_reservation_id;
    
    COMMIT;
END //

DELIMITER ;