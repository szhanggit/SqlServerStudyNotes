CREATE TABLE [dbo].[CheckPara20210127] (
    [Id]                     INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [MessageId]              INT             NULL,
    [MessageLocalId]         INT             NULL,
    [Status]                 INT             NULL,
    [MissingTag]             NVARCHAR (4000) NULL,
    [MissingVal]             NVARCHAR (4000) NULL,
    [OrderNumber]            VARCHAR (100)   NULL,
    [orderlineId]            INT             NULL,
    [VoucherNumber]          VARCHAR (100)   NULL,
    [OrderBeneficiaryInfoId] INT             NULL,
    [Email]                  VARCHAR (100)   NULL,
    [ProductCode]            VARCHAR (100)   NULL,
    [ClientName]             NVARCHAR (100)  NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

