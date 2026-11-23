CREATE TABLE [dbo].[EXT_IN_APIOrderInfo] (
    [Id]                       INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ClientOrderNumber]        VARCHAR (100) NULL,
    [RCN]                      VARCHAR (100) NOT NULL,
    [SKU]                      VARCHAR (25)  NOT NULL,
    [Quantity]                 INT           NOT NULL,
    [FirstName]                VARCHAR (100) NOT NULL,
    [MiddleName]               VARCHAR (100) NULL,
    [LastName]                 VARCHAR (100) NULL,
    [Email]                    VARCHAR (200) NOT NULL,
    [ContactPhone]             VARCHAR (25)  NOT NULL,
    [ProgramId]                VARCHAR (50)  NOT NULL,
    [ClientSKUCode]            VARCHAR (25)  NULL,
    [FLEX1]                    VARCHAR (250) NULL,
    [FLEX2]                    VARCHAR (250) NULL,
    [FLEX3]                    VARCHAR (250) NULL,
    [FLEX4]                    VARCHAR (250) NULL,
    [FLEX5]                    VARCHAR (250) NULL,
    [DeliveryType]             TINYINT       NOT NULL,
    [ClientQuotationProductId] INT           NOT NULL,
    [CreatedTime]              DATETIME      NOT NULL,
    [UpdatedTime]              DATETIME      NOT NULL,
    [OrderNumber]              VARCHAR (50)  NULL,
    [ClientQuotationId]        INT           NOT NULL,
    [OrderBeneficiaryInfoId]   BIGINT        NULL,
    [TransactionId]            VARCHAR (100) NULL,
    CONSTRAINT [PK_EXT_IN_APIOrderInfo] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_IN_APIOrderInfo_ClientQuotationProduct_Id] FOREIGN KEY ([ClientQuotationProductId]) REFERENCES [dbo].[ClientQuotationProduct] ([Id])
);


GO
CREATE NONCLUSTERED INDEX [index_EXT_IN_APIOrderInfo_RCN]
    ON [dbo].[EXT_IN_APIOrderInfo]([RCN] ASC);


GO
CREATE NONCLUSTERED INDEX [index_EXT_IN_APIOrderInfo_ObiId]
    ON [dbo].[EXT_IN_APIOrderInfo]([OrderBeneficiaryInfoId] ASC);

