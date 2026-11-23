
CREATE PROCEDURE [dbo].[spAssignProductSLMSTemplatesToOrder] @ProductCode varchar(50)
	,@OrderNumber varchar(50)
AS
BEGIN
	SET NOCOUNT ON;

	declare @TagId int;
	declare @TagName varchar(50);
	declare @ProductSLMSTemplateTagValueId int;
	declare @OrderSLMSTemplateTagValueId int;
	declare @ProductSLMSTemplateVersionId int;
	declare @OrderSLMSTemplateVersionId int;
	declare @OrderSLMSTemplateVersionSetId int;
	declare @OrderLineId int;
	declare @SLMSTemplateVersionId int;
  	DECLARE @BusinessCursor as CURSOR;
	declare @val nvarchar(1000);
	
	create table dbo.#RunningSLMSResult
	(
		Id INT PRIMARY KEY IDENTITY (1, 1), 
		ProductCode VARCHAR(50),
		OrderNumber VARCHAR(50),
		TagName VARCHAR(50),
		Status VARCHAR(50),
		OperationType VARCHAR(50),
		[Type] VARCHAR(50)
	)
  
	select @ProductSLMSTemplateTagValueId = SLMSTemplateTagValueId, @ProductSLMSTemplateVersionId = SLMSTemplateVersionId from ProductSLMSTemplateVersionSet with(nolock)
	where ProductSLMSTemplateVersionId in (select ProductSLMSTemplateVersionId from Product with(nolock) where ProductCode = @ProductCode)

	if(@ProductSLMSTemplateTagValueId is null or @ProductSLMSTemplateTagValueId = '')
	BEGIN
		return
	END

	if(@ProductSLMSTemplateVersionId is null or @ProductSLMSTemplateVersionId = '')
	BEGIN
		return
	END
  
  
  ---------------------------------------
  
  
  
  if exists(select * from ClientQuotationProduct cqp with(nolock) 
		inner join OrderLine ol with(nolock) on ol.ClientQuotationProductId = cqp.Id
		inner join [Order] o with(nolock) on o.Id = ol.OrderId
		inner join ProductVersion pv with(nolock) on cqp.ProductVersionId = pv.Id
		inner join Product p with(nolock) on pv.ProductId = p.Id
		where p.ProductCode = @ProductCode and o.OrderNumber = @OrderNumber and ol.SLMSTemplateVersionId is not null and ol.OrderSLMSTemplateVersionId is null)
		begin--Old Version
			select @OrderLineId = ol.Id, @SLMSTemplateVersionId = ol.SLMSTemplateVersionId 
			from OrderLine ol with(nolock) 
			inner join [Order] o with(nolock) on ol.OrderId = o.Id 
			inner join ClientQuotationProduct cqp with(nolock) on ol.ClientQuotationProductId = cqp.Id
			inner join ProductVersion pv on pv.Id = cqp.ProductVersionId
			inner join Product p on p.Id = pv.ProductId
			where p.ProductCode = @ProductCode and o.OrderNumber = @OrderNumber
			
			if(@OrderLineId is null or @OrderLineId = '')
			BEGIN
				return
			END		
		
			if(@SLMSTemplateVersionId is null or @SLMSTemplateVersionId = '')
			BEGIN
				return
			END		
		
			update OrderLine
			set SLMSTemplateVersionId = @ProductSLMSTemplateVersionId
			where id = @OrderLineId
			
			BEGIN TRAN

			BEGIN TRY
				SET @BusinessCursor = CURSOR FOR
				select Id from ContentTag

				OPEN @BusinessCursor;
				FETCH NEXT FROM @BusinessCursor INTO @TagId;
				WHILE @@FETCH_STATUS = 0
				BEGIN
				-------------


				select @val = [Value] from ProductSLMSContentTagValueSet pes with(nolock)
				where pes.ProductSLMSTemplateTagValueId = @ProductSLMSTemplateTagValueId
				and pes.ContentTagId = @TagId;


				IF @val is not null and @val <> ''  
				BEGIN		
					select @TagName = TagName from ContentTag where Id = @TagId;
					if exists(select * from OrderSLMSContentTagValueSet with(nolock) where OrderLineId = @OrderLineId and ContentTagId = @TagId)
						begin
							update OrderSLMSContentTagValueSet
							set [Value] = @val
							where OrderLineId = @OrderLineId and ContentTagId = @TagId
							
							insert into #RunningSLMSResult (ProductCode, OrderNumber, TagName, Status, OperationType, [Type]) values (@ProductCode, @OrderNumber, @TagName, 'Success', 'Update', 'SLMS');
						end
					else
						begin
							insert into OrderSLMSContentTagValueSet(ContentTagId, OrderLineId, Value) 
							values (@TagId, @OrderLineId, @val);			
								
							insert into #RunningSLMSResult (ProductCode, OrderNumber, TagName, Status, OperationType, [Type]) values (@ProductCode, @OrderNumber, @TagName, 'Success', 'Insert', 'SLMS');
						end
				END

				set @val = '';				
				----------------
				FETCH NEXT FROM @BusinessCursor INTO @TagId;
				END
				
				
				
				select ProductCode, OrderNumber, TagName, Status, OperationType, [Type] from #RunningSLMSResult;	
			END TRY
			BEGIN CATCH
					ROLLBACK TRAN
					return
			END CATCH

			COMMIT TRAN					
		
		end
  else
		begin--New Version
			select @OrderSLMSTemplateVersionSetId = Id, @OrderSLMSTemplateTagValueId = SLMSTemplateTagValueId, @OrderSLMSTemplateVersionId = SLMSTemplateVersionId from OrderSLMSTemplateVersionSet with(nolock) where OrderSLMSTemplateVersionId in (
				select ol.OrderSLMSTemplateVersionId from ClientQuotationProduct cqp with(nolock) 
				inner join OrderLine ol with(nolock) on ol.ClientQuotationProductId = cqp.Id
				inner join [Order] o with(nolock) on o.Id = ol.OrderId
				inner join ProductVersion pv with(nolock) on cqp.ProductVersionId = pv.Id
				inner join Product p with(nolock) on pv.ProductId = p.Id
				where p.ProductCode = @ProductCode and o.OrderNumber = @OrderNumber
			) 

			if(@OrderSLMSTemplateVersionSetId is null or @OrderSLMSTemplateVersionSetId = '')
			BEGIN
				return
			END

			if(@OrderSLMSTemplateTagValueId is null or @OrderSLMSTemplateTagValueId = '')
			BEGIN
				return
			END

			if(@OrderSLMSTemplateVersionId is null or @OrderSLMSTemplateVersionId = '')
			BEGIN
				return
			END

			update OrderSLMSTemplateVersionSet
			set SLMSTemplateVersionId = @ProductSLMSTemplateVersionId
			where id = @OrderSLMSTemplateVersionSetId


			BEGIN TRAN

			BEGIN TRY
				SET @BusinessCursor = CURSOR FOR
				select Id from ContentTag

				OPEN @BusinessCursor;
				FETCH NEXT FROM @BusinessCursor INTO @TagId;
				WHILE @@FETCH_STATUS = 0
				BEGIN
				-------------


				select @val = [Value] from ProductSLMSContentTagValueSet pes with(nolock)
				where pes.ProductSLMSTemplateTagValueId = @ProductSLMSTemplateTagValueId
				and pes.ContentTagId = @TagId;


				IF @val is not null and @val <> ''  
				BEGIN		
					select @TagName = TagName from ContentTag where Id = @TagId;
					if exists(select * from OrderSLMSTemplateTagValueSet with(nolock) where OrderSLMSTemplateTagValueId = @OrderSLMSTemplateTagValueId and ContentTagId = @TagId)
						begin
							update OrderSLMSTemplateTagValueSet
							set [Value] = @val
							where OrderSLMSTemplateTagValueId = @OrderSLMSTemplateTagValueId and ContentTagId = @TagId;
							
							insert into #RunningSLMSResult (ProductCode, OrderNumber, TagName, Status, OperationType, [Type]) values (@ProductCode, @OrderNumber, @TagName, 'Success', 'Update', 'SLMS');
						end
					else
						begin
							insert into  OrderSLMSTemplateTagValueSet(ContentTagId, OrderSLMSTemplateTagValueId, Value) 
							values (@TagId, @OrderSLMSTemplateTagValueId, @val);				
							
							insert into #RunningSLMSResult (ProductCode, OrderNumber, TagName, Status, OperationType, [Type]) values (@ProductCode, @OrderNumber, @TagName, 'Success', 'Insert', 'SLMS');
						end
				END

				set @val = '';				
				----------------
				FETCH NEXT FROM @BusinessCursor INTO @TagId;
				END
				
				
				
				select ProductCode, OrderNumber, TagName, Status, OperationType, [Type] from #RunningSLMSResult;	
			END TRY
			BEGIN CATCH
					ROLLBACK TRAN
					insert into #RunningSLMSResult (ProductCode, OrderNumber, TagName, Status, OperationType, [Type]) values (@ProductCode, @OrderNumber, '', 'Fail', '', 'SLMS');
					select ProductCode, OrderNumber, TagName, Status, OperationType, [Type] from #RunningSLMSResult;
					return
			END CATCH

			COMMIT TRAN		
		end
  ---------------------------------------
  
END
