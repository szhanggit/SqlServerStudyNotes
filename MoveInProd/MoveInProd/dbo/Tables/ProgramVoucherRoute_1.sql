CREATE TABLE [dbo].[ProgramVoucherRoute] (
    [Id]                    INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ProgramId]             INT          NOT NULL,
    [ShortUrlPrefix]        CHAR (1)     NOT NULL,
    [VoucherStockTableName] VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_ProgramVoucherRoute_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);

