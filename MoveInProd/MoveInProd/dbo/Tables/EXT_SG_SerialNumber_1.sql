CREATE TABLE [dbo].[EXT_SG_SerialNumber] (
    [Id]                 BIGINT       NOT NULL,
    [VoucherNumber]      VARCHAR (50) NOT NULL,
    [ProgramId]          INT          NOT NULL,
    [VerificationNumber] VARCHAR (50) NULL,
    CONSTRAINT [PK_SG_SerialNumber_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [index_SerialNumber]
    ON [dbo].[EXT_SG_SerialNumber]([VerificationNumber] ASC);

