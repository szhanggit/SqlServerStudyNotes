CREATE TABLE [dbo].[Merchant] (
    [Id]                                  INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ProgramId]                           INT             NOT NULL,
    [AddressId]                           INT             NOT NULL,
    [CategoryId]                          INT             NULL,
    [IdentityCode]                        VARCHAR (50)    NOT NULL,
    [Name]                                NVARCHAR (500)  NOT NULL,
    [ExternalCode]                        NVARCHAR (100)  NULL,
    [InvoiceRegisterNumber]               NVARCHAR (100)  NOT NULL,
    [ContactName1]                        NVARCHAR (50)   NULL,
    [ContactPhone1]                       VARCHAR (50)    NULL,
    [ContactName2]                        NVARCHAR (50)   NULL,
    [ContactPhone2]                       VARCHAR (50)    NULL,
    [CRMReference]                        NVARCHAR (100)  NULL,
    [FinanceReference]                    NVARCHAR (100)  NULL,
    [SecurityKey]                         VARCHAR (48)    NULL,
    [Status]                              TINYINT         NOT NULL,
    [Description]                         NVARCHAR (500)  NULL,
    [Modifier]                            NVARCHAR (50)   NOT NULL,
    [Version]                             INT             NOT NULL,
    [VersionTime]                         DATETIME        NOT NULL,
    [ShopIdentityCodePrefix]              VARCHAR (10)    NULL,
    [TX1MerchantUID]                      VARCHAR (100)   NULL,
    [IsAutoCreateReimbursement]           BIT             NULL,
    [AutoCreateReimbursementIntervalType] TINYINT         NULL,
    [AutoCreateReimbursementDay]          INT             NULL,
    [ReimbursementTaxType]                TINYINT         NULL,
    [ReimbursementReceivers]              NVARCHAR (1000) NULL,
    [SameKeyWithShop]                     BIT             NOT NULL,
    [MAMEmail]                            NVARCHAR (255)  NOT NULL,
    [ReimbursementType]                   TINYINT         NOT NULL,
    [MerchantAutoType]                    TINYINT         NOT NULL,
    [NotificationMerchantCode]            VARCHAR (50)    NULL,
    [MerchantEmail]                       NVARCHAR (255)  NULL,
    [MerchantAcquirerId]                  INT             NULL,
    [NeedConsumerScan]                    BIT             NULL,
    [Memo]                                NVARCHAR (2000) NULL,
    [IssuerType]                          TINYINT         NULL,
    CONSTRAINT [PK_Merchant] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Merchant_Address_AddressId] FOREIGN KEY ([AddressId]) REFERENCES [dbo].[Address] ([Id]),
    CONSTRAINT [FK_Merchant_Dictionary_CategoryId] FOREIGN KEY ([CategoryId]) REFERENCES [dbo].[Dictionary] ([Id]),
    CONSTRAINT [FK_Merchant_Program_ProgramId] FOREIGN KEY ([ProgramId]) REFERENCES [dbo].[Program] ([Id]),
    CONSTRAINT [UK_Merchant_IdentityCode] UNIQUE NONCLUSTERED ([IdentityCode] ASC)
);


GO
CREATE TRIGGER [dbo].[trSyncTX1MerchantUID] ON [dbo].[Merchant]
AFTER INSERT
	,UPDATE
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Insert statements for trigger here
	DECLARE @InsertCount INT
	DECLARE @DeleteCount INT

	SELECT @InsertCount = COUNT(1) FROM inserted

	SELECT @DeleteCount = COUNT(1) FROM deleted

	IF (@InsertCount > 0 AND @DeleteCount <= 0)
	BEGIN
		INSERT INTO [TW_EV_UAT_ROUTE].dbo.MerchantShop
		SELECT TX1MerchantUID
			,''
			,i.IdentityCode
			,''
			,p.IdentityCode
		FROM inserted i
		JOIN Program p ON i.ProgramId = p.Id
		WHERE ISNULL(TX1MerchantUID, '') <> ''
	END
	ELSE IF (@InsertCount > 0 AND @DeleteCount > 0)
	BEGIN
		IF UPDATE (TX1MerchantUID)
			BEGIN
				IF (NOT EXISTS (SELECT 1 FROM inserted AS T1
							JOIN dbo.Program AS T2 ON T1.ProgramId = T2.Id
							JOIN [TW_EV_UAT_ROUTE].dbo.MerchantShop AS T3 ON T3.MerchantCode20 = T1.IdentityCode AND T3.ProgramCode20 = T2.IdentityCode
							))
					BEGIN
						INSERT INTO [TW_EV_UAT_ROUTE].dbo.MerchantShop
						SELECT TX1MerchantUID
							,ISNULL(T3.ExternalCode,'')
							,T1.IdentityCode
							,ISNULL(T3.IdentityCode,'')
							,T2.IdentityCode
						FROM inserted AS T1
						JOIN Program AS T2 ON T1.ProgramId = T2.Id
						LEFT JOIN dbo.Shop AS T3 ON T1.Id = t3.MerchantId
						WHERE ISNULL(TX1MerchantUID, '') <> ''
					END
				ELSE
					BEGIN
						UPDATE [TW_EV_UAT_ROUTE].dbo.MerchantShop
						SET MerchantUid10 = i.TX1MerchantUID
						FROM inserted i
						JOIN deleted d ON i.Id = d.Id
						JOIN Program p ON i.ProgramId = p.Id
						WHERE i.IdentityCode = MerchantCode20
							AND p.IdentityCode = ProgramCode20
							AND d.TX1MerchantUID = MerchantUid10
							AND i.TX1MerchantUID <> d.TX1MerchantUID
							AND ISNULL(i.TX1MerchantUID, '') <> ''
					END
			END
	END
END

GO
DISABLE TRIGGER [dbo].[trSyncTX1MerchantUID]
    ON [dbo].[Merchant];

