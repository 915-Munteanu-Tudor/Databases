DROP TABLE Rooms;
DROP TABLE Doctors;
DROP TABLE Departments;

CREATE TABLE Departments(
	dept_id INT NOT NULL PRIMARY KEY,
	dept_name VARCHAR(20) NOT NULL
);

CREATE TABLE Doctors(
	doctor_id INT NOT NULL PRIMARY KEY,
	doctor_name VARCHAR(20) NOT NULL,
	dept_id INT
	CONSTRAINT fk_name
    FOREIGN KEY (dept_id)
    REFERENCES Departments (dept_id)
    ON DELETE CASCADE
);

CREATE TABLE Rooms(
	room_id INT NOT NULL PRIMARY KEY,
	floor_number INT CHECK(floor_number > 0),
	doctor_id INT FOREIGN KEY REFERENCES Doctors(doctor_id) UNIQUE
);

CREATE TABLE Diseases(
	disease_id INT NOT NULL PRIMARY KEY,
	description VARCHAR(100),
	is_treatable BIT,
	-- is_treatable INT CHECK(is_treatable = 0 or is_treatable = 1)
);

CREATE TABLE Pacients(
	pacient_id INT NOT NULL PRIMARY KEY,
	pacient_name VARCHAR(20) NOT NULL,
);

CREATE TABLE DiseasesPacients(
	disease_id INT FOREIGN KEY REFERENCES Diseases(disease_id),
	pacient_id INT FOREIGN KEY REFERENCES Pacients(pacient_id),
	PRIMARY KEY(disease_id, pacient_id)
);

INSERT INTO Departments(dept_id, dept_name) VALUES(1, 'DEPT1');
INSERT INTO Departments(dept_id, dept_name) VALUES(2, 'DEPT2');

INSERT INTO Doctors(doctor_id, doctor_name, dept_id) VALUES (1, 'D1', 1);
INSERT INTO Doctors(doctor_id, doctor_name, dept_id) VALUES (2, 'D2', 2);

SELECT * FROM Departments WHERE dept_id > 1;

SELECT * FROM Doctors ;

DELETE FROM Departments;

UPDATE Departments
SET dept_name = 'DEPARTMENT1'
WHERE dept_id = 1;

SELECT doctor_id, doctor_name, dept_name
FROM Doctors INNER JOIN Departments ON Doctors.dept_id = Departments.dept_id;