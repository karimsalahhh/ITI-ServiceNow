CREATE TABLE Department (
dept_id SERIAL PRIMARY KEY,
name VARCHAR(50)
);
 
CREATE TABLE Employee (
emp_id SERIAL PRIMARY KEY,
name VARCHAR(50),
dept_id INT REFERENCES Department(dept_id) ON DELETE CASCADE
);
ALTER TABLE Employee
ADD COLUMN salary NUMERIC;
 
 
INSERT INTO Department (name) VALUES
('HR'),
('IT'),
('Finance'),
('Marketing'),
('Sales');
 
 
INSERT INTO Employee (name, dept_id) VALUES
('Ahmed Ali', 1),
('Sara Mohamed', 1),
('Omar Hassan', 2),
('Mona Ibrahim', 2),
('Youssef Adel', 2),
('Nour Khaled', 3),
('Ali Mahmoud', 3),
('Fatma Samir', 3),
('Hassan Tarek', 4),
('Salma Hany', 4),
('Khaled Fathy', 4),
('Rania Mostafa', 5),
('Mahmoud Yasser', 5),
('Dina Ahmed', 5),
('Karim Nabil', 2),
('Heba Wael', 1),
('Amr Samy', 3),
('Laila Ashraf', 4),
('Mostafa Said', 5),
('Nada Gamal', 2);
 
UPDATE Employee
SET salary = 5000;


SELECT 
 name,
 salary,
 CASE
 	WHEN salary>=10000 THEN 'High'
	WHEN salary>=5000 THEN 'Medium'
	ELSE 'Low'
 END AS salary_level
FROM employee;


SELECT * 
FROM Employee
WHERE dept_id





SELECT *
FROM Department d 

WHERE EXISTS (
	SELECT 1
	FROM Employee
	WHERE dept_id = 1
);

SELECT name
FROM Employee
WHERE name SIMILAR TO '(A|M)%';

SELECT name
FROM Employee
WHERE name SIMILAR TO '____ %';


SELECT name 
FROM employee
WHERE name ~'[ae]';



SELECT 
name,
salary,
salary*1.10 AS salary_bonus
FROM Employee;
