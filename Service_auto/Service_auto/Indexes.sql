use master
go

drop table Customers
drop table Products
drop table Shoppings

create table Customers (
	CustomerID int primary key identity,
	Name varchar(50),
	PhoneNumber int unique 
)

create table Products (
	ProductID int primary key identity,
	Name varchar(50),
	Price int
)

create table Shoppings(
	Customer int references Customers(CustomerID),
	Product int references Products(ProductID),
	ShoppingID int primary key identity
)


create or alter procedure InsertCustomers @seed int
as
begin
	insert into Customers(Name, PhoneNumber)
	values('Customer' + convert(varchar(50), @seed), dbo.RandomInt(1000000, 10000000))
end
go


create or alter procedure InsertProducts @seed int
as
begin
	insert into Products(Name, Price)
	values('Product' + convert(varchar(50), @seed), dbo.RandomInt(1, 250))
end
go


create or alter procedure InsertShoppings @seed int
as
begin
	declare @customerID int, @productId int, @added smallint
	select @added = 0
	while @added = 0
		begin
			set @customerID = (select top 1 CustomerID From Customers order by newid())
			set @productId = (select top 1 ProductID from Products order by newid())
			--check the uniqueness of intorduced data
			IF EXISTS(SELECT *
                      FROM (
                               SELECT *
                               FROM Shoppings
                               WHERE Customer = @customerID
                           ) as [MC*]
                      WHERE Product = @productId
				)
				BEGIN
					CONTINUE
				END
            INSERT INTO Shoppings(Customer, Product)
            VALUES (@customerID, @productId)

            SELECT @added = 1
        END
END
go

exec PopulateTable 'Customers', 3000
exec PopulateTable 'Products', 3500
exec PopulateTable 'Shoppings', 2500

delete Customers
delete Products
delete Shoppings

--a
--CLUSTERED

--index scan
select *
from Customers
order by PhoneNumber

--index seek
select *
from Products
where Price > 212

--NON CLUSTERED
drop index if exists nonClusteredIndexCustomer on Customers
create nonclustered index nonClusteredIndexCustomer on Customers (PhoneNumber)

--index scan
select PhoneNumber
from Customers
order by PhoneNumber

--index seek
select PhoneNumber
from Customers
where PhoneNumber > 7000000 and PhoneNumber < 8000000

--key lookup
select Name
from Customers
where PhoneNumber = 2592151

--b
--no index; time: 30.6667
select *
from Products
where Price = 125

--non clustered index; time: 15.0000
drop index if exists nonClusteredIndexProducts on Products
create nonclustered index nonClusteredIndexProducts on Products (Price)
select *
from Products
where Price = 125

--c
create or alter view ThisView as
select top 1000 C.Name as Customer, P.Name as Product 
from Customers C
	inner join Shoppings S on C.CustomerID = S.Customer
	inner join Products P on S.Product = P.ProductID
where C.PhoneNumber > 7000000
order by P.Price
go

--time: 41.0000
select *
from ThisView

drop index if exists nonClusteredIndexCustomer2 on Customers
drop index if exists nonClusteredIndexShoppings on Shoppings

--time:10.0000
create nonclustered index nonClusteredIndexCustomer2 on Customers (CustomerID) include (Name, PhoneNumber)
create nonclustered index nonClusteredIndexShoppings on Shoppings (ShoppingID) include (Customer, Product)

select *
from ThisView