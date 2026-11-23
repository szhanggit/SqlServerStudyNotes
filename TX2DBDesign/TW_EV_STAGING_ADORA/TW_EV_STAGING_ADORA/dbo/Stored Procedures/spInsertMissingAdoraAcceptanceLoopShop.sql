CREATE PROC [dbo].[spInsertMissingAdoraAcceptanceLoopShop] 
@DB	varchar(50)				
AS
BEGIN
	SET NOCOUNT ON;
----------------------------------------------------	
--Start Initialization
DECLARE @GUID varchar(1000);
set @GUID = NewID();

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = N'AcceptanceLoopShopUpdate')
BEGIN
    CREATE TABLE [dbo].[AcceptanceLoopShopUpdate](
	[ProductExternalId] [varchar](50) NULL,
	[ProductName] [nvarchar](200) NULL,
	[ProductId] [int] NULL,
	[MerchantCode] [varchar](50) NULL,
	[MerchantName] [nvarchar](500) NULL,
	[MerchantExternalId] [varchar](50) NULL,
	[MerchantId] [int] NULL,
	[ShopCode] [varchar](50) NULL,
	[ShopName] [nvarchar](100) NULL,
	[ShopExternalId] [varchar](50) NULL,
	[ShopId] [int] NULL,
	[AcceptanceLoopId] [int] NULL
) ON [PRIMARY]
END




IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = N'AdoraLosingAcceptanceLoopLog')
BEGIN
	CREATE TABLE AdoraLosingAcceptanceLoopLog
	(
		Id INT PRIMARY KEY IDENTITY (1, 1),
		ProcessDateTime Datetime NOT null,
		[GUID] NVARCHAR(100) NOT null,
		[type] varchar(10) not null,
		[Desc] NVARCHAR(max)
	)
END

TRUNCATE TABLE AcceptanceLoopShopUpdate

CREATE TABLE #T1
(
	ProductId INT,
	ProductCode VARCHAR(50),
	ProductVersionId INT,
	ProductName NVARCHAR(200),
	MerchantId INT,
	MerchantCode VARCHAR(50),
	MerchantName NVARCHAR(500),
	ShopId INT,
	ShopCode VARCHAR(50),
	ShopName NVARCHAR(100)
)

CREATE CLUSTERED INDEX IDX_T1 ON #T1 (ProductId, MerchantId, ShopId)

CREATE TABLE #T2
(
	ProductId INT,
	MerchantId INT,
	MerchantCode VARCHAR(50)
)

CREATE CLUSTERED INDEX IDX_T2 ON #T2 (ProductId, MerchantId)

CREATE TABLE #T3
(
	ProductId INT,
	ShopId INT,
	ShopCode VARCHAR(50)
)

CREATE CLUSTERED INDEX IDX_T3 ON #T3 (ProductId, ShopId)
--End Initialization






--Start comparing and processing shop
--Mo shops need to be copied to Adora
DECLARE @Shop1Sql nvarchar(max);
SET @Shop1Sql = '
DECLARE @Description varchar(max);
IF EXISTS (SELECT mShop.Id FROM '+@DB+'.dbo.Shop mShop WITH(nolock) 
LEFT JOIN Shop aShop WITH(nolock) ON mShop.Id = aShop.ExternalId WHERE aShop.ExternalId IS NULL AND mShop.[Status] = 1)
BEGIN 	
	SELECT @Description = COALESCE(@Description + '', '', '''') + CAST(mShop.Id as varchar(10)) FROM '+@DB+'.dbo.Shop mShop WITH(nolock) 
	LEFT JOIN Shop aShop WITH(nolock) ON mShop.Id = aShop.ExternalId WHERE aShop.ExternalId IS NULL AND mShop.[Status] = 1
	insert into AdoraLosingAcceptanceLoopLog (ProcessDateTime, [GUID], [type], [Desc]) values (GETDATE(), @GUID, ''S1'', ''Mo shops were copied to Adora: '' + @Description);

	INSERT INTO Shop (ProgramId, ExternalId, IdentityCode, [Name], MerchantId, TimeOffset, Telephone, SecurityKeyId, [Status], MaxFailNumber)
	SELECT aProgram.Id AS ProgramId, CAST(mShop.Id AS nvarchar(20)) AS ExternalId, mShop.identityCode AS IdentityCode, 
	mShop.Name, aMerchant.Id AS MerchantId, ''08:00'' AS TimeOffset, '''' AS Telephone, NULL AS SecurityKeyId, 1 AS [Status], 500 AS MaxFailNumber 
	FROM '+@DB+'.dbo.Shop mShop WITH(nolock) 
	LEFT JOIN Shop aShop WITH(nolock)
	ON mShop.Id = aShop.ExternalId
	INNER JOIN '+@DB+'.dbo.Merchant mMerchant ON mShop.MerchantId = mMerchant.Id
	INNER JOIN Program aProgram ON mMerchant.programId = aProgram.ExternalId
	INNER JOIN Merchant aMerchant ON mMerchant.Id = aMerchant.ExternalId
	WHERE aShop.ExternalId IS NULL AND mShop.[Status] = 1


	DECLARE @ID AS INT
	DECLARE @ExternalId AS NVARCHAR(20)
	DECLARE @KEYID AS INT
	DECLARE CUR CURSOR FOR
	SELECT ID,ExternalId FROM SHOP WHERE SecurityKeyId IS NULL 

	OPEN CUR

	FETCH CUR INTO @id,@ExternalId

	WHILE @@FETCH_STATUS = 0
	BEGIN
	   INSERT INTO SecurityKey
	   SELECT SecurityKey
	   FROM '+@DB+'.DBO.SHOP
	   WHERE ID = CAST(@ExternalId AS INT)

	   SET @KEYID = SCOPE_IDENTITY()

	   IF NOT EXISTS(SELECT * FROM dbo.Shop WHERE SecurityKeyId = @KEYID) and EXISTS (SELECT [Value] FROM dbo.SecurityKey WHERE id = @KEYID)   
	   begin
			UPDATE SHOP 
			SET SecurityKeyId = @KEYID
			WHERE ID = @ID		
	   END
       ELSE
       BEGIN
			INSERT into AdoraLosingAcceptanceLoopLog (ProcessDateTime, [GUID], [type], [Desc]) values (GETDATE(), @GUID, ''C'', ''Confliced security key Id: '' + CAST(@KEYID AS nvarchar(20)) + '' in Adora shopId: '' + CAST(@ID AS nvarchar(20)));
	   END
	   FETCH CUR INTO @ID, @ExternalId
	END

	CLOSE CUR
	DEALLOCATE CUR
END
';

exec SP_EXECUTESQL @Shop1Sql, N'@GUID varchar(1000)', @GUID=@GUID;



--Mo missing shops on Adora
DECLARE @Shop2Sql nvarchar(max);
set @Shop2Sql = '
DECLARE @Description varchar(max);
IF EXISTS (SELECT aShop.Id, aShop.Name, aShop.MerchantId FROM Shop aShop WITH(nolock) 
LEFT JOIN '+@DB+'.dbo.Shop mShop WITH(nolock) ON aShop.ExternalId = mShop.Id WHERE mShop.Id IS NULL AND aShop.[Status] = 1)
BEGIN
	SELECT @Description = COALESCE(@Description + '', '', '''') + CAST(aShop.ExternalId as varchar(10)) 
	FROM Shop aShop WITH(nolock) LEFT JOIN ' + @DB + '.dbo.Shop mShop WITH(nolock) ON aShop.ExternalId = mShop.Id 
	WHERE mShop.Id IS NULL AND aShop.[Status] = 1
	insert into AdoraLosingAcceptanceLoopLog (ProcessDateTime, [GUID], [type], [Desc]) values (GETDATE(), @GUID, ''s2'', ''Mo missing shops on Adora: '' + @Description);
END';




exec SP_EXECUTESQL @Shop2Sql, N'@GUID varchar(1000)', @GUID=@GUID;
--End comparing and processing shop





--Start comparing and processing product

--Mo products need to be copied to Adora
DECLARE @Product1Sql nvarchar(max);


set @Product1Sql = '
DECLARE @Description varchar(max);
if exists (SELECT * FROM '+@DB+'.dbo.Product mProduct WITH(nolock)
LEFT JOIN Product aProduct WITH(nolock)
ON CAST(mProduct.Id AS VARCHAR) = aProduct.ExternalId
WHERE aProduct.ExternalId IS NULL AND mProduct.[Status]  = 1)
begin
	SELECT @Description = COALESCE(@Description + '', '', '''') + CAST(mProduct.Id as varchar(10)) FROM '+@DB+'.dbo.Product mProduct WITH(nolock)
	LEFT JOIN Product aProduct WITH(nolock)
	ON CAST(mProduct.Id AS VARCHAR) = aProduct.ExternalId
	WHERE aProduct.ExternalId IS NULL AND mProduct.[Status]  = 1
	insert into AdoraLosingAcceptanceLoopLog (ProcessDateTime, [GUID], [type], [Desc]) values (GETDATE(), @GUID, ''P1'', ''Mo products need to be copied to Adora: '' + @Description);
end
';





exec SP_EXECUTESQL @Product1Sql, N'@GUID varchar(1000)', @GUID=@GUID;


--Mo missing products
DECLARE @Product2Sql nvarchar(max);


set @Product2Sql = '
DECLARE @Description varchar(max);
if exists (SELECT * FROM Product aProduct WITH(nolock)
LEFT JOIN '+@DB+'.dbo.Product mProduct WITH(nolock)
ON CAST(mProduct.Id AS VARCHAR) = aProduct.ExternalId  
WHERE mProduct.Id IS NULL)
begin
	SELECT @Description = COALESCE(@Description + '', '', '''') + CAST(aProduct.ExternalId as varchar(10)) FROM Product aProduct WITH(nolock)
	LEFT JOIN '+@DB+'.dbo.Product mProduct WITH(nolock)
	ON CAST(mProduct.Id AS VARCHAR) = aProduct.ExternalId  
	WHERE mProduct.Id IS NULL
	insert into AdoraLosingAcceptanceLoopLog (ProcessDateTime, [GUID], [type], [Desc]) values (GETDATE(), @GUID, ''p2'', ''Mo missing products on Adora: '' + @Description);
end

'






exec SP_EXECUTESQL @Product2Sql, N'@GUID varchar(1000)', @GUID=@GUID;

--End comparing and processing product


--Start comparing and processing merchant
--Mo merchants need to be copied to Adora
DECLARE @Merchant1Sql nvarchar(max);

set @Merchant1Sql = '
DECLARE @Description varchar(max);
if exists (SELECT * FROM '+@DB+'.dbo.Merchant mMerchant WITH(nolock)
LEFT JOIN Merchant aMerchant WITH(nolock)
ON mMerchant.Id = aMerchant.ExternalId
WHERE aMerchant.ExternalId IS NULL AND mMerchant.[Status] = 1)
begin
	SELECT @Description = COALESCE(@Description + '', '', '''') + CAST(mMerchant.Id as varchar(10)) FROM '+@DB+'.dbo.Merchant mMerchant WITH(nolock)
	LEFT JOIN Merchant aMerchant WITH(nolock)
	ON mMerchant.Id = aMerchant.ExternalId
	WHERE aMerchant.ExternalId IS NULL AND mMerchant.[Status] = 1
	insert into AdoraLosingAcceptanceLoopLog (ProcessDateTime, [GUID], [type], [Desc]) values (GETDATE(), @GUID, ''M1'', ''Mo merchants need to be copied to Adora: '' + @Description);
end
';





exec SP_EXECUTESQL @Merchant1Sql, N'@GUID varchar(1000)', @GUID=@GUID;
--Mo missing merchants
DECLARE @Merchant2Sql nvarchar(max);

set @Merchant2Sql = '
DECLARE @Description varchar(max);
if exists (SELECT * FROM Merchant aMerchant WITH(nolock)
LEFT JOIN '+@DB+'.dbo.Merchant mMerchant WITH(nolock)
ON aMerchant.ExternalId = mMerchant.Id
WHERE mMerchant.Id IS NULL AND aMerchant.[Status] = 1)
begin
	SELECT @Description = COALESCE(@Description + '', '', '''') + CAST(aMerchant.ExternalId as varchar(10)) FROM Merchant aMerchant WITH(nolock)
	LEFT JOIN '+@DB+'.dbo.Merchant mMerchant WITH(nolock)
	ON aMerchant.ExternalId = mMerchant.Id
	WHERE mMerchant.Id IS NULL AND aMerchant.[Status] = 1
	insert into AdoraLosingAcceptanceLoopLog (ProcessDateTime, [GUID], [type], [Desc]) values (GETDATE(), @GUID, ''M2'', ''Mo missing merchants on Adora: '' + @Description);
end
';




exec SP_EXECUTESQL @Merchant2Sql, N'@GUID varchar(1000)', @GUID=@GUID;

--End comparing and processing merchant






--Start comparing and processing program

--Mo programs need to be copied to Adora
DECLARE @Program1Sql nvarchar(max);

set @Program1Sql = '
DECLARE @Description varchar(max);
if exists (SELECT * FROM '+@DB+'.dbo.Program mProgram WITH(nolock)
LEFT JOIN Program aProgram WITH(nolock)
ON mProgram.Id = aProgram.ExternalId
WHERE aProgram.ExternalId IS NULL)
begin
	SELECT @Description = COALESCE(@Description + '', '', '''') + CAST(mProgram.Id as varchar(10)) FROM '+@DB+'.dbo.Program mProgram WITH(nolock)
	LEFT JOIN Program aProgram WITH(nolock)
	ON mProgram.Id = aProgram.ExternalId
	WHERE aProgram.ExternalId IS NULL
	insert into AdoraLosingAcceptanceLoopLog (ProcessDateTime, [GUID], [type], [Desc]) values (GETDATE(), @GUID, ''O1'', ''Mo programs need to be copied to Adora: '' + @Description);
end
';






exec SP_EXECUTESQL @Program1Sql, N'@GUID varchar(1000)', @GUID=@GUID;
--Mo missing programs
DECLARE @Program2Sql nvarchar(max);

set @Program2Sql = '
DECLARE @Description varchar(max);
if exists (SELECT * FROM Program aProgram WITH(nolock)
LEFT JOIN '+@DB+'.dbo.Program mProgram WITH(nolock)
ON aProgram.ExternalId = mProgram.Id
WHERE mProgram.Id IS NULL)
begin
	SELECT @Description = COALESCE(@Description + '', '', '''') + CAST(aProgram.ExternalId as varchar(10)) FROM Program aProgram WITH(nolock)
	LEFT JOIN '+@DB+'.dbo.Program mProgram WITH(nolock)
	ON aProgram.ExternalId = mProgram.Id
	WHERE mProgram.Id IS NULL
	insert into AdoraLosingAcceptanceLoopLog (ProcessDateTime, [GUID], [type], [Desc]) values (GETDATE(), @GUID, ''O2'', ''Mo missing programs on Adora: '' + @Description);
end
';





exec SP_EXECUTESQL @Program2Sql, N'@GUID varchar(1000)', @GUID=@GUID;
--End comparing and processing program



-- Acceptance loop in MOVE
DECLARE @T1Sql nvarchar(max);


IF @DB = 'd_ev_mo' OR @DB = 'TEST_EV_MOVE'
BEGIN 
	set @T1Sql = '
		;with AcceptanceLoopShopCleaned as (
		SELECT MAX(Id) AS Id, MAX(AcceptanceLoopMerchantId) AS AcceptanceLoopMerchantId, MAX(ShopId) AS ShopId from '+@DB+'.dbo.AcceptanceLoopShop GROUP BY AcceptanceLoopMerchantId, ShopId
		)
		INSERT INTO #T1
		SELECT A.Id ProductId, A.ProductCode, B.Id ProductVersionId, B.ProductName, F.Id MerchantId, F.IdentityCode MerchantCode, F.Name MerchantName, G.Id ShopId, G.IdentityCode ShopCode, G.Name ShopName
		FROM '+@DB+'.dbo.Product A WITH (NOLOCK)
		INNER JOIN '+@DB+'.dbo.ProductVersion B WITH (NOLOCK)
			ON A.Id = B.ProductId AND B.IsCurrentVersion = 1
		INNER JOIN '+@DB+'.dbo.AcceptanceLoop C WITH (NOLOCK)
			ON B.AcceptanceLoopId = C.Id
		INNER JOIN '+@DB+'.dbo.AcceptanceLoopMerchant D WITH (NOLOCK)
			ON C.Id = D.AcceptanceLoopId
		INNER JOIN AcceptanceLoopShopCleaned E WITH (NOLOCK)
			ON D.Id = E.AcceptanceLoopMerchantId
		INNER JOIN '+@DB+'.dbo.Merchant F WITH (NOLOCK)
			ON D.MerchantId = F.Id AND F.Status = 1
		INNER JOIN '+@DB+'.dbo.Shop G WITH (NOLOCK)
			ON E.ShopId = G.Id AND G.Status = 1
		WHERE A.Status = 1		
	';
end
else
begin
	set @T1Sql = '
	INSERT INTO #T1
	SELECT A.Id ProductId, A.ProductCode, B.Id ProductVersionId, B.ProductName, F.Id MerchantId, F.IdentityCode MerchantCode, F.Name MerchantName, G.Id ShopId, G.IdentityCode ShopCode, G.Name ShopName
	FROM '+@DB+'.dbo.Product A WITH (NOLOCK)
	INNER JOIN '+@DB+'.dbo.ProductVersion B WITH (NOLOCK)
		ON A.Id = B.ProductId AND B.IsCurrentVersion = 1
	INNER JOIN '+@DB+'.dbo.AcceptanceLoop C WITH (NOLOCK)
		ON B.AcceptanceLoopId = C.Id
	INNER JOIN '+@DB+'.dbo.AcceptanceLoopMerchant D WITH (NOLOCK)
		ON C.Id = D.AcceptanceLoopId
	INNER JOIN '+@DB+'.dbo.AcceptanceLoopShop E WITH (NOLOCK)
		ON D.Id = E.AcceptanceLoopMerchantId
	INNER JOIN '+@DB+'.dbo.Merchant F WITH (NOLOCK)
		ON D.MerchantId = F.Id AND F.Status = 1
	INNER JOIN '+@DB+'.dbo.Shop G WITH (NOLOCK)
		ON E.ShopId = G.Id AND G.Status = 1
	WHERE A.Status = 1';
end




exec SP_EXECUTESQL @T1Sql, N'@GUID varchar(1000)', @GUID=@GUID;




-- Acceptance loop shop in ADORA
INSERT INTO #T3
SELECT A.ExternalId ProductId, C.ExternalId ShopId, C.IdentityCode ShopCode
FROM AcceptanceLoop A WITH (NOLOCK)
INNER JOIN AcceptanceLoopShop B WITH (NOLOCK)
	ON A.Id = B.AcceptanceLoopId
INNER JOIN Shop C WITH (NOLOCK)
	ON B.ShopId = C.Id
WHERE A.Status = 1






DECLARE @Desc varchar(max);
--Acceptance loop shop in MO but not in Adora
IF EXISTS (SELECT T1.ProductId, T1.ProductName, T1.MerchantCode, T1.MerchantName, T1.MerchantId, T1.ShopCode, T1.ShopName, T1.ShopId
FROM #T1 T1
LEFT OUTER JOIN #T3 T3
	ON T1.ProductId = T3.ProductId AND T1.ShopId = T3.ShopId
WHERE T3.ShopId IS NULL)
BEGIN
	SELECT @Desc = COALESCE(@Desc + ', ', '') + 'ProductId: ' + CAST(T1.ProductId AS nvarchar(20)) + ' and ShopId: ' + CAST(T1.ShopId AS nvarchar(20))
	FROM #T1 T1
	LEFT OUTER JOIN #T3 T3
		ON T1.ProductId = T3.ProductId AND T1.ShopId = T3.ShopId
	WHERE T3.ShopId IS NULL
	insert into AdoraLosingAcceptanceLoopLog (ProcessDateTime, [GUID], [type], [Desc]) values (GETDATE(), @GUID, 'K1', 'Mo AcceptanceLoopShops were copied to Adora: ' + @Desc);


	INSERT INTO AcceptanceLoopShopUpdate (ProductExternalId, ProductName, MerchantCode, MerchantName, MerchantExternalId, ShopCode, ShopName, ShopExternalId) 
	SELECT T1.ProductId, T1.ProductName, T1.MerchantCode, T1.MerchantName, T1.MerchantId, T1.ShopCode, T1.ShopName, T1.ShopId
	FROM #T1 T1
	LEFT OUTER JOIN #T3 T3
		ON T1.ProductId = T3.ProductId AND T1.ShopId = T3.ShopId
	WHERE T3.ShopId IS NULL

end








-- Update data
UPDATE AcceptanceLoopShopUpdate
SET ProductId = A.Id
FROM Product A WITH (NOLOCK)
WHERE AcceptanceLoopShopUpdate.ProductExternalId = A.ExternalId
AND AcceptanceLoopShopUpdate.ProductName = A.Name

UPDATE AcceptanceLoopShopUpdate
SET MerchantId = A.Id
FROM Merchant A WITH (NOLOCK)
WHERE AcceptanceLoopShopUpdate.MerchantCode = A.IdentityCode
AND AcceptanceLoopShopUpdate.MerchantName = A.Name
AND AcceptanceLoopShopUpdate.MerchantExternalId = A.ExternalId

UPDATE AcceptanceLoopShopUpdate
SET ShopId = A.Id
FROM Shop A WITH (NOLOCK)
WHERE AcceptanceLoopShopUpdate.ShopCode = A.IdentityCode
AND AcceptanceLoopShopUpdate.ShopName = A.Name
AND AcceptanceLoopShopUpdate.ShopExternalId = A.ExternalId

UPDATE AcceptanceLoopShopUpdate
SET AcceptanceLoopId = A.Id
FROM AcceptanceLoop A WITH (NOLOCK)
WHERE AcceptanceLoopShopUpdate.ProductId = A.ProductId
AND AcceptanceLoopShopUpdate.ProductExternalId = A.ExternalId



-- Insert data
INSERT INTO AcceptanceLoopShop
SELECT A.AcceptanceLoopId, A.ShopId
FROM AcceptanceLoopShopUpdate A
LEFT OUTER JOIN AcceptanceLoopShop B WITH (NOLOCK)
	ON A.AcceptanceLoopId = B.AcceptanceLoopId AND A.ShopId = B.ShopId
WHERE B.Id IS NULL AND A.AcceptanceLoopId IS NOT NULL


DROP TABLE #T1;
DROP TABLE #T2;
DROP TABLE #T3;	
----------------------------------------------------	
END	

