CREATE TABLE [dbo].[MerchantContract_08172021] (
    [Id]         INT          IDENTITY (1, 1) NOT NULL,
    [ProgramId]  INT          NOT NULL,
    [MerchantId] INT          NOT NULL,
    [ProductId]  INT          NOT NULL,
    [ExternalId] VARCHAR (50) NOT NULL,
    [StartDate]  INT          NOT NULL,
    [EndDate]    INT          NOT NULL,
    [Status]     INT          NOT NULL
);

