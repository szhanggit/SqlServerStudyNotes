
CREATE PROCEDURE [dbo].[spCreateProgram]
	@ProgramName NVARCHAR (50),
	@IdentityCode VARCHAR (20),
	@ProgramOffset VARCHAR (6),
	@IsEdenred BIT,
	@VoucherImportTemplateName NVARCHAR (100),
	@DateFormatString  VARCHAR (25) = NULL,
	@DateTimeFormatString  VARCHAR (25) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @ProgramId INT
	DECLARE @VoucherStockTableName VARCHAR (50)
	DECLARE @ShortUrlPrefix char(1)
	INSERT INTO [dbo].[Program] (
	[IdentityCode]
	,[Name]
	,[DisplayName]
	,[TimeOffset]
	,[MerchantMaxFailNumber]
	,[ShopMaxFailNumber]
	,[TerminalMaxFailNumber]
	,[IsDefaultProgram]
	,[DateFormatString]
	,[DateTimeFormatString]
	,[IsEdenred]
	)
	VALUES(
	@IdentityCode
	,@ProgramName
	,@ProgramName
	,@ProgramOffset
	,500
	,200
	,50
	,0
	,@DateFormatString
	,@DateTimeFormatString
	,@IsEdenred
	)

	SELECT @ProgramId = SCOPE_IDENTITY();

	INSERT INTO [dbo].[VoucherImportTemplate]
           ([TemplateName]
           ,[ProgramId])
     VALUES
           (@VoucherImportTemplateName
           ,@ProgramId);

	WITH TableRecord(TableName,RecordCount) as  
(  
  SELECT o.name, i.rows
    from sysobjects o
	join sysindexes i on o.id = i.id
   where 
    (o.name like 'VoucherStock[_][A-Z]'
	or o.name like 'VoucherStock[_][A-Z][_][1-9][0-9]'
	or o.name like 'VoucherStock[_][A-Z][_][1-9][0-9][0-9]')
     and o.Xtype = 'U'
     and i.indid < 2
)
	SELECT TOP (1) @VoucherStockTableName = TableName from TableRecord order by RecordCount
	SET @ShortUrlPrefix = substring(@VoucherStockTableName,14,1)

	INSERT INTO [dbo].[ProgramVoucherRoute] (
	[ProgramId]
	,[ShortUrlPrefix]
	,[VoucherStockTableName]
	)
	VALUES(
	@ProgramId
	,@ShortUrlPrefix
	,@VoucherStockTableName
	)

	SELECT TOP (1) [Id]
      ,[IdentityCode]
      ,[Name]
      ,[DisplayName]
      ,[TimeOffset]
      ,[MerchantMaxFailNumber]
      ,[ShopMaxFailNumber]
      ,[TerminalMaxFailNumber]
      ,[IsDefaultProgram]
      ,[DateFormatString]
      ,[DateTimeFormatString]
  FROM [dbo].[Program]
  WHERE [Id] = @ProgramId
END
