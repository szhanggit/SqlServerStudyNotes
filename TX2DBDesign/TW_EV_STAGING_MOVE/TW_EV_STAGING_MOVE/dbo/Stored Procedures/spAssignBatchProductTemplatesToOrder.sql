
CREATE PROCEDURE dbo.spAssignBatchProductTemplatesToOrder
@InputTable ProductCode_OrderNumber READONLY
AS
      SET NOCOUNT ON
	  declare @TableID int;
	  declare @ProductCode varchar(50);
	  declare @OrderNumber varchar(50);
	  declare @Counter int;

	  CREATE TABLE dbo.#InputVariableTable
	  ( 
	   Id INT PRIMARY KEY IDENTITY (1, 1), 
	   ProductCode VARCHAR(50),
       OrderNumber VARCHAR(50)
	  ) 

	  create table dbo.#RunningResult
	  (
	   Id INT PRIMARY KEY IDENTITY (1, 1), 
	   ProductCode VARCHAR(50),
       OrderNumber VARCHAR(50),
	   TagName VARCHAR(50),
	   Status VARCHAR(50),
	   OperationType VARCHAR(50),
	   [Type] VARCHAR(50)
	  )

	  insert into dbo.#InputVariableTable (ProductCode, OrderNumber)
	  select ProductCode, OrderNumber from @InputTable;

	  while exists (select * from dbo.#InputVariableTable)
		begin

			select top 1 @TableID = id
			, @ProductCode = ProductCode
			, @OrderNumber = OrderNumber
			from dbo.#InputVariableTable
			order by id asc;

			----------------




			insert into dbo.#RunningResult(ProductCode, OrderNumber, TagName, Status, OperationType, [Type]) EXEC [dbo].[spAssignProductEmailTemplatesToOrder] @ProductCode, @OrderNumber; 
			insert into dbo.#RunningResult(ProductCode, OrderNumber, TagName, Status, OperationType, [Type]) EXEC [dbo].[spAssignProductSLMSTemplatesToOrder] @ProductCode, @OrderNumber; 




			-----------------

			delete dbo.#InputVariableTable where id = @TableID;

		end
		
		select * from dbo.#RunningResult
