CREATE TABLE [dbo].[UsedVoucher] (
    [Id]        INT    IDENTITY (1, 1) NOT NULL,
    [VoucherId] BIGINT NOT NULL,
    CONSTRAINT [PK_UsedVoucher_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    UNIQUE NONCLUSTERED ([VoucherId] ASC) WITH (IGNORE_DUP_KEY = ON)
);

