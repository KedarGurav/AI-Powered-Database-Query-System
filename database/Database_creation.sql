-- Drop the database if it exists and create it again
DROP DATABASE IF EXISTS atliq_tshirts;
CREATE DATABASE atliq_tshirts;
USE atliq_tshirts;

-- Drop the t_shirts table if it exists and create it again
DROP TABLE IF EXISTS t_shirts;
CREATE TABLE t_shirts (
    t_shirt_id INT AUTO_INCREMENT PRIMARY KEY,
    brand ENUM('Van Huesen', 'Levi', 'Nike', 'Adidas') NOT NULL,
    color ENUM('Red', 'Blue', 'Black', 'White') NOT NULL,
    size ENUM('XS', 'S', 'M', 'L', 'XL') NOT NULL,
    price INT CHECK (price BETWEEN 10 AND 50),
    stock_quantity INT NOT NULL,
    UNIQUE KEY brand_color_size (brand, color, size)
);

-- Drop the discounts table if it exists and create it again
DROP TABLE IF EXISTS discounts;
CREATE TABLE discounts (
    discount_id INT AUTO_INCREMENT PRIMARY KEY,
    t_shirt_id INT NOT NULL,
    pct_discount DECIMAL(5,2) CHECK (pct_discount BETWEEN 0 AND 100),
    FOREIGN KEY (t_shirt_id) REFERENCES t_shirts(t_shirt_id)
);

-- Create a stored procedure to populate the t_shirts table
DELIMITER $$
CREATE PROCEDURE PopulateTShirts()
BEGIN
    DECLARE counter INT DEFAULT 0;
    DECLARE max_records INT DEFAULT 100;
    DECLARE brand VARCHAR(50);
    DECLARE color VARCHAR(50);
    DECLARE size VARCHAR(50);
    DECLARE price INT;
    DECLARE stock INT;

    WHILE counter < max_records DO
        -- Generate random values
        SET brand = ELT(FLOOR(1 + RAND() * 4), 'Van Huesen', 'Levi', 'Nike', 'Adidas');
        SET color = ELT(FLOOR(1 + RAND() * 4), 'Red', 'Blue', 'Black', 'White');
        SET size = ELT(FLOOR(1 + RAND() * 5), 'XS', 'S', 'M', 'L', 'XL');
        SET price = FLOOR(10 + RAND() * 41);
        SET stock = FLOOR(10 + RAND() * 91);

        -- Attempt to insert a new record
        BEGIN
            DECLARE CONTINUE HANDLER FOR 1062 BEGIN END;  -- Handle duplicate key error
            INSERT INTO t_shirts (brand, color, size, price, stock_quantity)
            VALUES (brand, color, size, price, stock);
            SET counter = counter + 1;
        END;
    END WHILE;
END$$
DELIMITER ;

-- Call the stored procedure to populate the t_shirts table
CALL PopulateTShirts();

-- Insert 10 records into the discounts table using valid t_shirt_id values
INSERT INTO discounts (t_shirt_id, pct_discount)
VALUES
(1, 10.00),
(2, 15.00),
(3, 20.00),
(4, 5.00),
(5, 25.00),
(6, 10.00),
(7, 30.00),
(8, 35.00),
(9, 40.00),
(10, 45.00);
