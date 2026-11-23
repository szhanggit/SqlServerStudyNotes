CREATE TABLE [dbo].[ClientQuotationStatusHistory20201203] (
    [Id]                INT            IDENTITY (1, 1) NOT NULL,
    [ClientQuotationId] INT            NOT NULL,
    [Operation]         TINYINT        NOT NULL,
    [Comment]           NVARCHAR (500) NULL,
    [Operator]          NVARCHAR (50)  NOT NULL,
    [OperationTime]     DATETIME       NOT NULL
);

