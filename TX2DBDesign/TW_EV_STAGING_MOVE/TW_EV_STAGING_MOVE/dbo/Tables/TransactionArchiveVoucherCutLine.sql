CREATE TABLE [dbo].[TransactionArchiveVoucherCutLine] (
    [Id]             BIGINT         IDENTITY (1, 1) NOT NULL,
    [ExpiryDate]     DATETIME       NOT NULL,
    [StartVoucherId] BIGINT         NOT NULL,
    [EndVoucherId]   BIGINT         NOT NULL,
    [DataCount]      INT            DEFAULT ((0)) NOT NULL,
    [Status]         TINYINT        NOT NULL,
    [CreatedOn]      DATETIME       NULL,
    [Comment]        NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_TransactionArchiveVoucherCutLine_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);

