CREATE TABLE [dbo].[Client] (
    [Id]                         INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Name]                       NVARCHAR (100)  NOT NULL,
    [IdentityCode]               VARCHAR (50)    NOT NULL,
    [IndustryId]                 INT             NULL,
    [AddressId]                  INT             NOT NULL,
    [GroupId]                    INT             NULL,
    [InvoiceRegisterNumber]      NVARCHAR (100)  NOT NULL,
    [CRMReference]               NVARCHAR (100)  NULL,
    [FinanceReference]           NVARCHAR (100)  NULL,
    [Department]                 NVARCHAR (100)  NULL,
    [Status]                     TINYINT         NOT NULL,
    [Description]                NVARCHAR (500)  NULL,
    [Modifier]                   NVARCHAR (50)   NOT NULL,
    [Version]                    INT             NOT NULL,
    [VersionTime]                DATETIME        NOT NULL,
    [SecurityKey]                VARCHAR (32)    NOT NULL,
    [NeedNotification]           BIT             DEFAULT ((0)) NOT NULL,
    [NotificationProviderCodeId] INT             NULL,
    [Title]                      NVARCHAR (100)  NULL,
    [SecurityAlgorithm]          TINYINT         NOT NULL,
    [EmailSenderName]            NVARCHAR (255)  NULL,
    [EmailSenderAddress]         NVARCHAR (255)  NULL,
    [VoucherIssuerId]            INT             NULL,
    [MediaLibraryId]             INT             NULL,
    [SMSSenderName]              NVARCHAR (255)  NULL,
    [EmailHeaderMId]             INT             NULL,
    [EmailFooterMId]             INT             NULL,
    [ApplyEmailSubject]          BIT             NULL,
    [CanIssue]                   BIT             DEFAULT ((1)) NOT NULL,
    [SubURL]                     NVARCHAR (6)    NULL,
    [BannerMediaLibraryId]       INT             NULL,
    [MandatoryAutoBilling]       BIT             NULL,
    [SmsProviderCode]            NVARCHAR (8)    NULL,
    [EmailProviderCode]          NVARCHAR (8)    NULL,
    [Memo]                       NVARCHAR (2000) NULL,
    [SmsEntityId]                NVARCHAR (30)   NULL,
    [SalesEmail]                 NVARCHAR (255)  NULL,
    [BusinessTypeId]             INT             NULL,
    [ContactName]                NVARCHAR (30)   NULL,
    [ContactEmail]               NVARCHAR (255)  NULL,
    [ContactPhone]               NVARCHAR (50)   NULL,
    CONSTRAINT [PK_Client_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Client_Address_AddressId] FOREIGN KEY ([AddressId]) REFERENCES [dbo].[Address] ([Id]),
    CONSTRAINT [FK_Client_ClientGroup_GroupId] FOREIGN KEY ([GroupId]) REFERENCES [dbo].[ClientGroup] ([Id]),
    CONSTRAINT [FK_Client_Dictionary_IndustryId] FOREIGN KEY ([IndustryId]) REFERENCES [dbo].[Dictionary] ([Id]),
    CONSTRAINT [FK_Client_Dictionary_NotificationProviderCodeId] FOREIGN KEY ([NotificationProviderCodeId]) REFERENCES [dbo].[Dictionary] ([Id]),
    CONSTRAINT [UK_Client_IdentityCode] UNIQUE NONCLUSTERED ([IdentityCode] ASC),
    CONSTRAINT [UK_Client_Name] UNIQUE NONCLUSTERED ([Name] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IDX_Client_InvoiceRegisterNumber]
    ON [dbo].[Client]([InvoiceRegisterNumber] ASC);


GO
-- =============================================
-- Author:		Steven Yu
-- Create date: 2014/6/13
-- Description:	Trace client.
-- =============================================
CREATE TRIGGER trTraceClient
	ON  [dbo].[Client]
	AFTER INSERT,UPDATE,DELETE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
		INSERT INTO [dbo].[ClientTracing]
           ([ClientId]
           ,[Name]
           ,[InvoiceRegisterNumber]
           ,[IndustryId]
           ,[CRMReference]
           ,[FinanceReference]
           ,[Department]
	   ,[SecurityKey]
	   ,[IdentityCode]
           ,[AddressId]
           ,[GroupId]
           ,[Status]
           ,[Description]
           ,[Modifier]
           ,[Version]
           ,[VersionTime])
     SELECT Id
           ,[Name]
           ,[InvoiceRegisterNumber]
           ,[IndustryId]
           ,[CRMReference]
           ,[FinanceReference]
           ,[Department]
           ,[SecurityKey]
           ,[IdentityCode]
           ,[AddressId]
           ,[GroupId]
           ,[Status]
           ,[Description]
           ,[Modifier]
           ,[Version]
           ,[VersionTime]
	FROM inserted
END
