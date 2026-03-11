CREATE TABLE Department(
dept_id SERIAL PRIMARY KEY,
name VARCHAR(50)
);

CREATE TABLE Employee(
emp_id SERIAL PRIMARY KEY,
name VARCHAR(50),
dept_id INT REFERENCES Department(dept_id)ON DELETE CASCADE
);

CREATE TABLE Employees(
emps_id SERIAL PRIMARY KEY,
name VARCHAR(50),
dept_id INT REFERENCES Department(dept_id) ON DELETE RESTRICT
);

INSERT INTO Employes (name) VALUES
('I'),
('H'),
('Finance');

INSERT INTO Department (name) VALUES
('IT'),
('HR'),
('Finance');

-- Insert Employees
INSERT INTO Employees (name, dept_id) VALUES
('Ali', 2),
('Sara', 2),
('Omar', 2);


SELECT * FROM Department;


SELECT * FROM Employee;

DELETE FROM Department
WHERE dept_id = 2;

SELECT * FROM Department;
SELECT * FROM Employee;