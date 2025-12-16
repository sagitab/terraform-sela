CREATE DATABASE flask_db;
USE flask_db;
CREATE TABLE users (
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    PRIMARY KEY (id)
);
INSERT INTO users (name) VALUES ('sagi');
SELECT * FROM users;
SHOW TABLES;
DESCRIBE users;
