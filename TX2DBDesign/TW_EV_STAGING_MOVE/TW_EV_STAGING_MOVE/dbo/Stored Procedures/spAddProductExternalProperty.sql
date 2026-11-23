
CREATE PROCEDURE dbo.spAddProductExternalProperty
@ProductCode varchar(50),
@Name nvarchar(50),
@Val nvarchar(50)
AS
    SET NOCOUNT ON
	Declare @ProductExternalPropertyId int;
	select top(1) @ProductExternalPropertyId = peps.ProductExternalPropertyId from ProductExternalPropertySet peps inner join ProductExternalProperty pep on peps.ProductExternalPropertyId = pep.Id
	inner join ProductVersion pv with(nolock) on pv.ExternalPropertyId = pep.Id
	inner join Product p with(nolock) on p.Id = pv.ProductId
	where p.ProductCode = @ProductCode and pv.IsCurrentVersion = 1;

	if @ProductExternalPropertyId is not null
	begin
		insert into ProductExternalPropertySet(ProductExternalPropertyId, PropertyName, PropertyValue, [Description])
		select @ProductExternalPropertyId as ProductExternalPropertyId, @Name as PropertyName,  @Val as PropertyValue, @Name as [Description];
	end
	else
	begin
		INSERT ProductExternalProperty DEFAULT VALUES;
		SELECT @ProductExternalPropertyId = SCOPE_IDENTITY();
		update Product
		set ExternalPropertyId = @ProductExternalPropertyId
		where ProductCode = @ProductCode;
		update pv
		set pv.ExternalPropertyId = @ProductExternalPropertyId
		from ProductVersion pv with(nolock)
		inner join Product p with(nolock) on p.Id = pv.ProductId
		where p.ProductCode = @ProductCode and pv.IsCurrentVersion = 1;	
		insert into ProductExternalPropertySet(ProductExternalPropertyId, PropertyName, PropertyValue, [Description])
		select @ProductExternalPropertyId as ProductExternalPropertyId, @Name as PropertyName,  @Val as PropertyValue, @Name as [Description];
	end
