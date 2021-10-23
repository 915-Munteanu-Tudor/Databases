CREATE TABLE Teachers(
	id_teacher int not null primary key,
	teacher_name varchar(50)
);

CREATE TABLE Lectures(
	id_lecture int not null primary key,
	lecture_name varchar(100) UNIQUE,
	is_in_english bit,
	teacher_id int foreign key references Teachers(id_teacher)
);

CREATE TABLE Students(
	id_student int not null primary key IDENTITY(1,1),
	student_name varchar(100),
	cnp varchar(14)
);

CREATE TABLE StudentsLectures(
	id_student int foreign key references Students(id_student),
	id_lecture int foreign key references Lectures(id_lecture),
	primary key(id_student, id_lecture)
);
