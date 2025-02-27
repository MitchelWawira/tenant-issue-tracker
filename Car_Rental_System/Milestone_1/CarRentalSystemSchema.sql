CREATE TABLE `car` (
  `car_id` INT NOT NULL AUTO_INCREMENT,
  `model` VARCHAR(100) NOT NULL,
  `brand` VARCHAR(100) NOT NULL,
  `year` INT NULL DEFAULT NULL,
  `status` VARCHAR(20) NULL DEFAULT 'available',
  PRIMARY KEY (`car_id`))

CREATE TABLE `customer` (
  `customer_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `phone` VARCHAR(15) NULL DEFAULT NULL,
  PRIMARY KEY (`customer_id`),
  UNIQUE INDEX `email` (`email` ASC) VISIBLE)

CREATE TABLE `reservation` (
  `reservation_id` INT NOT NULL AUTO_INCREMENT,
  `customer_id` INT NULL DEFAULT NULL,
  `car_id` INT NULL DEFAULT NULL,
  `start_date` DATE NOT NULL,
  `end_date` DATE NOT NULL,
  PRIMARY KEY (`reservation_id`),
  INDEX `customer_id` (`customer_id` ASC) VISIBLE,
  INDEX `car_id` (`car_id` ASC) VISIBLE,
  FOREIGN KEY (`customer_id`)
    REFERENCES `customer` (`customer_id`)
    ON DELETE CASCADE,
  FOREIGN KEY (`car_id`)
    REFERENCES `car` (`car_id`)
    ON DELETE SET NULL)

CREATE TABLE `payment` (
  `payment_id` INT NOT NULL AUTO_INCREMENT,
  `reservation_id` INT NULL DEFAULT NULL,
  `amount` DECIMAL(10,2) NOT NULL,
  `payment_date` DATE NULL DEFAULT NULL,
  `status` VARCHAR(20) NULL DEFAULT 'pending',
  PRIMARY KEY (`payment_id`),
  INDEX `reservation_id` (`reservation_id` ASC) VISIBLE,
  FOREIGN KEY (`reservation_id`)
    REFERENCES `reservation` (`reservation_id`)
    ON DELETE CASCADE)
