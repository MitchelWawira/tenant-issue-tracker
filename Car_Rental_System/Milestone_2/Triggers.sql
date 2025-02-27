DELIMITER //

-- Trigger to update car status after reservation
CREATE TRIGGER after_reservation_insert
AFTER INSERT ON reservation
FOR EACH ROW
BEGIN
    UPDATE car
    SET status = 'reserved'
    WHERE car_id = NEW.car_id;
END //

-- Trigger to update car status after reservation ends
CREATE TRIGGER after_reservation_delete
AFTER DELETE ON reservation
FOR EACH ROW
BEGIN
    UPDATE car
    SET status = 'available'
    WHERE car_id = OLD.car_id;
END //

-- Trigger to log payments
CREATE TABLE payment_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    payment_id INT,
    old_status VARCHAR(20),
    new_status VARCHAR(20),
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) //

CREATE TRIGGER payment_status_change
AFTER UPDATE ON payment
FOR EACH ROW
BEGIN
    IF OLD.status != NEW.status THEN
        INSERT INTO payment_log (payment_id, old_status, new_status)
        VALUES (NEW.payment_id, OLD.status, NEW.status);
    END IF;
END //

-- Trigger to validate reservation dates
CREATE TRIGGER before_reservation_insert
BEFORE INSERT ON reservation
FOR EACH ROW
BEGIN
    IF NEW.start_date >= NEW.end_date THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'End date must be after start date';
    END IF;
END //

DELIMITER ;