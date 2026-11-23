CREATE TABLE [dbo].[Shop] (
    [Id]             INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [MerchantId]     INT            NOT NULL,
    [IdentityCode]   VARCHAR (50)   NOT NULL,
    [ExternalCode]   VARCHAR (50)   NULL,
    [Name]           NVARCHAR (100) NOT NULL,
    [AddressId]      INT            NOT NULL,
    [ContactName1]   NVARCHAR (50)  NULL,
    [ContactPhone1]  VARCHAR (50)   NULL,
    [ContactName2]   NVARCHAR (50)  NULL,
    [ContactPhone2]  VARCHAR (50)   NULL,
    [SecurityKey]    VARCHAR (48)   NULL,
    [CreatedOn]      DATETIME       NOT NULL,
    [LastModifiedOn] DATETIME       NOT NULL,
    [LastModifier]   NVARCHAR (50)  NOT NULL,
    [Status]         TINYINT        NOT NULL,
    [SubsidiaryUEN]  NVARCHAR (30)  NULL,
    [SubsidiaryName] NVARCHAR (100) NULL,
    CONSTRAINT [PK_Shop] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Shop_Address_AddressId] FOREIGN KEY ([AddressId]) REFERENCES [dbo].[Address] ([Id]),
    CONSTRAINT [FK_Shop_Merchant_MerchantId] FOREIGN KEY ([MerchantId]) REFERENCES [dbo].[Merchant] ([Id]),
    CONSTRAINT [UK_Shop_MerchantId_ExternalCode] UNIQUE NONCLUSTERED ([MerchantId] ASC, [ExternalCode] ASC),
    CONSTRAINT [UK_Shop_MerchantId_IdentityCode] UNIQUE NONCLUSTERED ([MerchantId] ASC, [IdentityCode] ASC)
);


GO

CREATE TRIGGER [dbo].[trSyncShopCode] ON [dbo].[Shop]
AFTER INSERT
	,UPDATE
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @InsertCount INT
	DECLARE @DeleteCount INT

	SELECT @InsertCount = COUNT(1)
	FROM inserted

	SELECT @DeleteCount = COUNT(1)
	FROM deleted

	IF (@InsertCount > 0 AND @DeleteCount <= 0)
	BEGIN
		INSERT INTO [TW_EV_UAT_ROUTE].dbo.MerchantShop
		SELECT m.TX1MerchantUID
			,i.ExternalCode
			,m.IdentityCode
			,i.IdentityCode
			,p.IdentityCode
		FROM inserted i
		JOIN Merchant m ON i.MerchantId = m.Id
		JOIN Program p ON m.ProgramId = p.Id
		WHERE ISNULL(m.TX1MerchantUID, '') <> ''
	END
	ELSE IF (@InsertCount > 0 AND @DeleteCount > 0)
	BEGIN
		IF UPDATE (ExternalCode)
			BEGIN
				IF(NOT EXISTS(SELECT 1 FROM inserted AS T1
								JOIN dbo.Merchant AS T2 ON T1.MerchantId = T2.Id
								JOIN dbo.Program AS T3 ON T2.ProgramId = T3.Id
								JOIN [TW_EV_UAT_ROUTE].dbo.MerchantShop AS T4 ON T1.IdentityCode=T4.ShopCode20
								AND T2.IdentityCode = T4.MerchantCode20 AND T3.IdentityCode = T4.ProgramCode20))
					BEGIN
						INSERT INTO [TW_EV_UAT_ROUTE].dbo.MerchantShop
						SELECT m.TX1MerchantUID
							,i.ExternalCode
							,m.IdentityCode
							,i.IdentityCode
							,p.IdentityCode
						FROM inserted i
						JOIN Merchant m ON i.MerchantId = m.Id
						JOIN Program p ON m.ProgramId = p.Id
						where isnull(m.TX1MerchantUID,'')<>''
					END
				ELSE
					BEGIN
						UPDATE [TW_EV_UAT_ROUTE].dbo.MerchantShop
						SET ShopCode10 = i.ExternalCode
						FROM inserted i
						JOIN deleted d ON i.Id = d.Id
						JOIN Merchant m ON i.MerchantId = m.Id
						JOIN Program p ON m.ProgramId = p.Id
						WHERE d.ExternalCode = ShopCode10
							AND d.IdentityCode = ShopCode20
							AND p.IdentityCode = ProgramCode20
							AND m.IdentityCode = MerchantCode20
							AND i.ExternalCode <> d.ExternalCode
					END
			END
	END
END
GO
DISABLE TRIGGER [dbo].[trSyncShopCode]
    ON [dbo].[Shop];

