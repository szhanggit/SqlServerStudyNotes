CREATE TABLE [dbo].[OrderBeneficiaryInfoExtra] (
    [Id]                     BIGINT         NOT NULL,
    [EmailSubject]           NVARCHAR (500) NULL,
    [CreatedOn]              DATETIME       NOT NULL,
    [IsServiceFeeCalculated] BIT            NOT NULL,
    [RedemptionID]           VARCHAR (10)   NULL,
    CONSTRAINT [PK_OrderBeneficiaryInfoExtra_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_OrderBeneficiaryInfoExtra_OrderBeneficiaryInfo_Id] FOREIGN KEY ([Id]) REFERENCES [dbo].[OrderBeneficiaryInfo] ([Id])
);

