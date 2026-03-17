CREATE TABLE Doctor (
    Doctor_id INT PRIMARY KEY,
    Specialization VARCHAR(100),
    Qualification VARCHAR(100),
    Name_First VARCHAR(50),
    Name_Middle VARCHAR(50),
    Name_Last VARCHAR(50),
    Salary INT
);

CREATE TABLE Patient (
    Patient_id INT PRIMARY KEY,
    Name_First VARCHAR(50),
    DOB DATE,
    Address_Locality VARCHAR(100),
    Address_City VARCHAR(100),
    Phone VARCHAR(20)
);

CREATE TABLE Medicine (
    Code VARCHAR(10) PRIMARY KEY,
    Price NUMERIC(10,2),
    Quantity INT
);

CREATE TABLE Doctor_Treats_Patient (
    Doctor_id INT,
    Patient_id INT,
    PRIMARY KEY (Doctor_id, Patient_id),
    CONSTRAINT fk_dtp_doctor
        FOREIGN KEY (Doctor_id)
        REFERENCES Doctor(Doctor_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_dtp_patient
        FOREIGN KEY (Patient_id)
        REFERENCES Patient(Patient_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Patient_Bills_Medicine (
    Patient_id INT,
    Medicine_Code VARCHAR(10),
    Quantity INT,
    PRIMARY KEY (Patient_id, Medicine_Code),
    CONSTRAINT fk_pbm_patient
        FOREIGN KEY (Patient_id)
        REFERENCES Patient(Patient_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_pbm_medicine
        FOREIGN KEY (Medicine_Code)
        REFERENCES Medicine(Code)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
