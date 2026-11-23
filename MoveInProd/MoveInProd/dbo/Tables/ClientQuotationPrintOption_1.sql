CREATE TABLE [dbo].[ClientQuotationPrintOption] (
    [Id]               INT             NOT NULL,
    [Sales]            NVARCHAR (100)  NOT NULL,
    [SalesPhone]       NVARCHAR (50)   NOT NULL,
    [PlanDeliveryDate] DATETIME        NULL,
    [DeliveryMethod]   NVARCHAR (100)  NULL,
    [OtherConditions]  NVARCHAR (1000) NULL,
    [AdvancePayment]   NUMERIC (15, 4) NULL,
    [IsPrintNoteTerm2] BIT             NOT NULL,
    [IsPrintNoteTerm3] BIT             NOT NULL,
    [SalesTitle]       NVARCHAR (100)  NULL,
    CONSTRAINT [PK_CLIENTQUOTATIONPRINTOPTION] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ClientQuotationPrintOption_ClientQuotation_Id] FOREIGN KEY ([Id]) REFERENCES [dbo].[ClientQuotation] ([Id])
);

