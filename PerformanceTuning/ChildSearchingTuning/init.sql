IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Orders]') AND type in (N'U'))
BEGIN
	create table Orders(
		Id bigint IDENTITY(1,1) NOT NULL,
		CustomerName varchar(50) Not Null,
		OrderDate Datetime Not Null
	);
END

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderDetails]') AND type in (N'U'))
BEGIN
	create table OrderDetails(
		Id bigint IDENTITY(1,1) NOT NULL,
		OrderId int not null,
		ProductCode varchar(20) not null,
		Quantity int not null
	);
END


Declare @OrderCounter int = 1
Declare @OrderDetailCounter int = 1
Declare @TotalOrderNumber int = 1000000
Declare @TotalOrderDetailNumber int = 5;
Declare @CustomerNamePrefix varchar(50) = 'customer_'
Declare @ProductCodePrefix varchar(50) = 'pcode_'
Declare @CustomerName varchar(50)
Declare @ProductCode varchar(50)
Declare @OrderId int

while @OrderCounter <= @TotalOrderNumber
begin
	set @CustomerName = @CustomerNamePrefix + cast(@OrderCounter as varchar(50));	
	insert into Orders(CustomerName, OrderDate) values (@CustomerName, getdate());
	set @OrderId = scope_identity();
	set @OrderDetailCounter = 1
	while @OrderDetailCounter <= @TotalOrderDetailNumber
	begin
		set @ProductCode = @ProductCodePrefix + cast(@OrderDetailCounter as varchar(50));
		insert into OrderDetails (OrderId, ProductCode, Quantity) values (@OrderId, @ProductCode, 2);
		set @OrderDetailCounter = @OrderDetailCounter + 1
	end
	set @OrderCounter = @OrderCounter + 1;
end

