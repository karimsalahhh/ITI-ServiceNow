CREATE TABLE doctors (
doctor_id SERIAL PRIMARY KEY,
first_name VARCHAR(50) NOT NULL,
middle_name VARCHAR(50),
last_name VARCHAR(50) NOT NULL,
specialization VARCHAR(100) NOT NULL,
qualification VARCHAR(100) NOT NULL
);

CREATE TABLE patients (
patient_id SERIAL PRIMARY KEY,
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50) NOT NULL,
dob DATE DEFAULT CURRENT_DATE,
locality VARCHAR(100) NOT NULL,
city VARCHAR(100) NOT NULL,
doctor_id INT 
);


ALTER TABLE patients
ADD CONSTRAINT fk_patients_doctor
FOREIGN KEY (doctor_id)
REFERENCES doctors(doctor_id)
ON DELETE CASCADE
ON UPDATE CASCADE;


CREATE TABLE medicines (
code SERIAL PRIMARY KEY,
medicine_name VARCHAR(100) NOT NULL,
price NUMERIC(10,2) NOT NULL,
quantity INT NOT NULL
);

CREATE TABLE patient_medicine (
bill_id SERIAL PRIMARY KEY,
patient_id INT,
medicine_code INT,
quantity INT,
bill_date DATE
);

ALTER TABLE patient_medicine
ADD CONSTRAINT fk_patient_medicine_patient
FOREIGN KEY (patient_id)
REFERENCES patients(patient_id)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE patient_medicine
ADD CONSTRAINT fk_patient_medicine_medicine
FOREIGN KEY (medicine_code)
REFERENCES medicines(code)
ON DELETE CASCADE
ON UPDATE CASCADE;


INSERT INTO doctors (first_name, middle_name, last_name, specialization, qualification)
VALUES
('Ahmed', 'Mohamed', 'Ali', 'Cardiology', 'MBBS'),
('Sara', 'Ibrahim', 'Hassan', 'Dermatology', 'MD'),
('Omar', 'Khaled', 'Youssef', 'Pediatrics', 'PhD');


INSERT INTO patients (first_name, last_name, dob, locality, city, doctor_id)
VALUES
('Mona', 'Adel', '2000-05-10', 'Nasr City', 'Cairo', 1),
('Youssef', 'Tarek', '1998-03-15', 'Heliopolis', 'Cairo', 2),
('Nour', 'Sameh', '2002-11-20', 'Smouha', 'Alexandria', 1),
('Karim', 'Magdy', '1999-07-01', 'Sidi Gaber', 'Alexandria', 3),
('Salma', 'Hany', '2001-09-25', 'Dokki', 'Giza', 2);


INSERT INTO medicines (medicine_name, price, quantity)
VALUES
('Panadol', 25.00, 100),
('Amoxicillin', 80.00, 50),
('Vitamin C', 40.00, 70),
('Insulin', 150.00, 30),
('Paracetamol Syrup', 35.00, 60);


INSERT INTO patient_medicine (patient_id, medicine_code, quantity, bill_date)
VALUES
(1, 1, 2, '2026-03-10'),
(2, 2, 1, '2026-03-11'),
(3, 3, 3, '2026-03-12'),
(4, 4, 1, '2026-03-13'),
(5, 5, 2, '2026-03-14');



