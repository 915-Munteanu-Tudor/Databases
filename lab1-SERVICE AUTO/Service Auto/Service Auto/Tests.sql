use master
go

create or alter procedure CreateTest @name varchar(50)
as
begin
	if exists(select * from Tests T where Name = @name)
		begin
			print 'Test already exists'
			return
		end
	insert into Tests(Name) values (@name)
end

exec CreateTest 'HelloWorld'
select * from Tests

create or alter procedure AddTableToTestTable @tblname varchar(50)
as
	begin
		if not exists(select * from sys.tables where name = @tblname)
			begin
				print 'Table ' + @tblname + ' does not exist'
				return
			end
		if exists(select * from Tables T where T.Name = @tblname)
			begin 
				print 'Table ' + @tblname + ' already added to test'
				return
			end
		insert into Tables(Name) values(@tblname)
end

exec AddTableToTestTable 'Tools'
exec AddTableToTestTable 'Parts'
exec AddTableToTestTable 'MechanicsCars'

create or alter procedure RelateTestsAndTables @tableName varchar(50), @testName varchar(50), @noRows int, @position int
as
begin
	if @position < 0
	begin
		print 'Position must be > 0'
		return
	end
	if @noRows < 0
	begin
		print 'Number of rows must be > 0'
		return
	end

	declare @testID int, @tableID int
	set @testID = (select T.TestID from Tests T where T.Name = @testName)
	set @tableID = (select T.TableID from Tables T where T.Name = @tableName)
	INSERT INTO TestTables(TestID, TableID, NoOfRows, Position) VALUES(@testID, @tableID, @noRows, @position)
END

EXEC RelateTestsAndTables 'MechanicsCars', 'HelloWorld', 2000, 0
select *from TestTables

create or alter procedure AddViewToTestTable @viewName varchar(50)
as
	begin
		if not exists(select * from information_schema.views where TABLE_NAME = @viewName)
		begin
			print 'View does not exist'
			return
		end
	if exists(select * from Views where Name = @viewName)
	begin
		print 'View already added'
		return
	end
	insert into Views(Name) Values(@viewName)
end

create or alter procedure RelateTestsAndViews @viewName varchar(50), @testName varchar(50)
as
	begin
		declare @testID int, @viewID int
		set @testID = (select TestID from Tests where Name = @testName)
		set @viewID = (select ViewID from Views where Name = @viewName)
		insert into TestViews(TestID,ViewID) values(@testID, @viewID)
end

create or alter procedure RunTest @name varchar(50)
as
	declare @test int
	set @test = (select T.TestID from Tests T where T.Name = @name)

	declare @tableName varchar(50), @noRows int, @tableID int,
			@allTestsStartTime datetime2, @allTestsEndTime datetime2,
			@currentTestStartTime datetime2, @currentTestEndTime datetime2,
			@testRunID int, @command varchar(256),
			@viewName varchar(50), @viewID int

	insert into TestRuns(Description) values(@name)
	set @testRunID = CONVERT(int, (select last_value from sys.identity_columns where name = 'TestRunID'))
	
	declare TableCursor cursor scroll for
	select TT.TableID, T2.Name, TT.NoOfRows from TestTables TT inner join Tables T2 on T2.TableID = TT.TableID
	where TT.TestID = @test
	order by TT.Position

	declare ViewCursor cursor for
	select V.ViewID, V.Name from Views V inner join TestViews TV on V.ViewID = TV.ViewID
	where TV.TestID = @test

	set @allTestsStartTime = SYSDATETIME();
	open TableCursor
	
	fetch first from TableCursor into @tableID, @tableName, @noRows
	while @@FETCH_STATUS = 0
	begin
		set @currentTestStartTime = SYSDATETIME()
		set @command = 'PopulateTable ' + char(39) + @tableName + char(39) + ', ' + CONVERT(varchar(10), @noRows)
		print @noRows
		exec(@command)
		set @currentTestEndTime = SYSDATETIME()
		insert into TestRunTables(TestRunID, TableID, StartAt, EndAt) values(@testRunID, @tableID, @currentTestStartTime, @currentTestEndTime)
		fetch next from TableCursor into @tableID, @tableName, @noRows
	end

	close TableCursor
	open TableCursor
	fetch last from TableCursor into @tableID, @tableName, @noRows

	while @@FETCH_STATUS = 0
	begin
		exec ClearTable @tableName
		fetch prior from TableCursor into @tableID, @tableName, @noRows
	end

	close TableCursor
	deallocate TableCursor

	open ViewCursor
	fetch from ViewCursor into @viewID, @viewName
	while @@FETCH_STATUS = 0
	begin
		set @currentTestStartTime = SYSDATETIME()
		declare @statement varchar(256)
		set @statement = 'SELECT * FROM ' + @viewName
		print @statement
		exec(@statement)
		set @currentTestEndTime = SYSDATETIME()
		insert into TestRunViews(TestRunID, ViewID, StartAt, EndAt) values(@testRunID, @viewID, @currentTestStartTime, @currentTestEndTime)
		fetch next from ViewCursor into @viewID, @viewName
	end

	set @allTestsEndTime = SYSDATETIME()
	close ViewCursor
	deallocate ViewCursor
	update TestRuns
		set StartAt = @allTestsStartTime, EndAt = @allTestsEndTime
		where TestRunID = @testRunID
go

delete TestTables
delete TestRunTables
delete TestRuns


select * from MechanicsCars
select * from Tools
select * from Parts


EXEC RelateTestsAndTables 'Tools', 'HelloWorld', 3000, 1
EXEC RelateTestsAndTables 'Parts', 'HelloWorld', 1500, 2
EXEC RelateTestsAndTables 'MechanicsCars', 'HelloWorld', 200, 3

EXEC CreateTest 'FastTestShouldBeShort'
EXEC RelateTestsAndTables 'Tools', 'FastTestShouldBeShort', 100, 2
EXEC RelateTestsAndTables 'Parts', 'FastTestShouldBeShort', 150, 1
EXEC RelateTestsAndTables 'MechanicsCars', 'FastTestShouldBeShort', 33, 3

EXEC AddViewToTestTable 'ExpensiveCars'
EXEC AddViewToTestTable 'UsefulTools'
EXEC AddViewToTestTable 'CarsWithAppointment'

EXEC RelateTestsAndViews 'ExpensiveCars', 'FastTestShouldBeShort'
EXEC RelateTestsAndViews 'UsefulTools', 'FastTestShouldBeShort'
EXEC RelateTestsAndViews 'CarsWithAppointment', 'FastTestShouldBeShort'

SELECT * FROM Views
SELECT * FROM TestViews

SELECT * FROM TestTables
SELECT * FROM TestRunTables
SELECT * FROM TestRuns
SELECT * FROM TestRunViews

PRINT SYSDATETIME()
EXEC RunTest 'FastTestShouldBeShort'
EXEC RunTest 'HelloWorld'

