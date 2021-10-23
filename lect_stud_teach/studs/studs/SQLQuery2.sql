
create table research_teams(
RTID smallint identity(1,1) primary key,
RTName varchar(50) unique
);

create table researchers(
RID int primary key identity(1,1),
RFName varchar(50) not null,
RLName varchar(50) not null,
RTID smallint,
constraint fk_name foreign key(RTID) references research_teams(RTID)
);

create table published_papers(
PID int primary key identity(1,1),
title varchar(100),
conference varchar(100)
);

create table researchers_punlished_papers(
RID int foreign key references researchers(RID),
PID int foreign key references published_papers(PID),
primary key(rid,pid)
);

create table universities(
UnivId int primary key identity(1,1),
UnivName nvarchar(100),
Country nvarchar(100)
);

create table research_teams_universities(
RTID smallint references research_teams(RTID),
UnivID int references universities(UnivID),
primary key(RTID, UnivId)
);

create table birds(
 BID int primary key identity(1,1),
 BNickName nvarchar(100),
 Species nvarchar(100),
 RTID smallint references research_teams(RTID)
);

create table sensor_types(
STID int primary key identity(1,1),
STname nvarchar(100) unique,
STBirdDescription nvarchar(100) default 'tbw'
);

create table Sensors(
Sensor_id int primary key identity(1,1),
BirdId int references birds(BID),
STID int references sensor_types(STID) on delete no action on update cascade,
);

create table Sensor_data(
SDID int primary key identity(1,1),
Sensor_id int references Sensors(Sensor_id),
SensorDataValue real,
SensorDataTime datetime2
);





