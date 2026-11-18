CREATE TABLE IF NOT EXISTS employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    department VARCHAR(100)
);

INSERT INTO employees (name, department)
VALUES
    ('John', 'IT'),
    ('Mary', 'HR');