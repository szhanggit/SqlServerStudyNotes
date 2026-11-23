CREATE TABLE [dbo].[EMV_ClientOrderLine] (
    [Id]                       INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ClientOrderId]            INT           NOT NULL,
    [ClientQuotationProductId] INT           NOT NULL,
    [ProgramName]              VARCHAR (250) NULL,
    [ProgramId]                VARCHAR (50)  NOT NULL,
    [LocalRedemptionID]        VARCHAR (100) NOT NULL,
    [UserID]                   VARCHAR (50)  NOT NULL,
    [UserName]                 VARCHAR (200) NOT NULL,
    [FirstName]                VARCHAR (100) NOT NULL,
    [MiddleName]               VARCHAR (100) NULL,
    [LastName]                 VARCHAR (100) NULL,
    [Email]                    VARCHAR (200) NOT NULL,
    [ContactPhone]             VARCHAR (25)  NOT NULL,
    [Country]                  VARCHAR (20)  NOT NULL,
    [RedemptionDate]           VARCHAR (30)  NOT NULL,
    [RCN]                      VARCHAR (100) NOT NULL,
    [RedemptionItemName]       VARCHAR (250) NOT NULL,
    [SKU]                      VARCHAR (25)  NOT NULL,
    [Quantity]                 INT           NOT NULL,
    [UnitItemPoints]           INT           NULL,
    [TotalItemPoints]          INT           NULL,
    [DeliveryType]             TINYINT       NOT NULL,
    [DeliveryPriority]         VARCHAR (20)  NULL,
    [ClientOrderNumber]        VARCHAR (100) NULL,
    [Priority]                 INT           NOT NULL,
    [Remarks]                  VARCHAR (250) NULL,
    [ClientSKUCode]            VARCHAR (25)  NULL,
    [FLEX1]                    VARCHAR (250) NULL,
    [FLEX2]                    VARCHAR (250) NULL,
    [FLEX3]                    VARCHAR (250) NULL,
    [FLEX4]                    VARCHAR (250) NULL,
    [FLEX5]                    VARCHAR (250) NULL,
    [Status]                   TINYINT       NOT NULL,
    [CreatedTime]              DATETIME      NOT NULL,
    [UpdatedTime]              DATETIME      NOT NULL,
    [OrderNumber]              VARCHAR (50)  NULL,
    CONSTRAINT [PK_EMV_ClientOrderLine] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_EMV_ClientOrderLine_ClientOrder_Id] FOREIGN KEY ([ClientOrderId]) REFERENCES [dbo].[EMV_ClientOrder] ([Id]),
    CONSTRAINT [FK_EMV_ClientOrderLine_ClientQuotationProduct_Id] FOREIGN KEY ([ClientQuotationProductId]) REFERENCES [dbo].[ClientQuotationProduct] ([Id])
);


GO
CREATE NONCLUSTERED INDEX [index_EMV_ClientOrderLine_RCN]
    ON [dbo].[EMV_ClientOrderLine]([RCN] ASC);

