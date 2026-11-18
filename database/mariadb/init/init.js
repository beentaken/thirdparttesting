USE mariadb_test;

CREATE TABLE IF NOT EXISTS employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    department VARCHAR(100)
);

INSERT INTO employees (name, department)
VALUES
    ('John', 'IT'),
    ('Mary', 'HR');