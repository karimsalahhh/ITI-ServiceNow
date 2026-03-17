CREATE TABLE students (
student_id SERIAL PRIMARY KEY,
student_name VARCHAR(50)
);
CREATE TABLE courses (
course_id SERIAL PRIMARY KEY,
course_name VARCHAR(50)
);
CREATE TABLE enrollments (
enrollment_id SERIAL PRIMARY KEY,
student_id INT,
course_id INT,
FOREIGN KEY (student_id) REFERENCES students(student_id),
FOREIGN KEY (course_id) REFERENCES courses(course_id)
);
 
INSERT INTO students (student_name) VALUES
('Ali'),('Sara'),('Omar'),('Ahmed');
 
INSERT INTO courses (course_name) VALUES
('Database'),('JS'),('HTML'),('css');
 
INSERT INTO enrollments (student_id, course_id) VALUES
(1,1),(1,2),(2,1),(3,3);


SELECT s.student_name, c.course_name
FROM enrollments e 
INNER JOIN students s 
ON e.student_id = s.student_id
INNER JOIN courses c
ON e.course_id = c.course_id


SELECT student_name , count(e.course_id) AS course_count
FROM students s 
left join enrollments e 
on s.student_id = e.student_id
group by student_name 


SELECT student_name , count(e.course_id) AS course_count
FROM students s 
left join enrollments e 
on s.student_id = e.student_id
group by student_name having count(course_id)>0
order by course_count desc


select course_name , count(e.student_id) as enrollment_students
from courses c 
left join enrollments e on
c.course_id= e.course_id
group by course_name






