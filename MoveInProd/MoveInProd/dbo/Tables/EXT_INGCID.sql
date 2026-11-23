CREATE TABLE [dbo].[EXT_INGCID] (
    [Id]            BIGINT       NOT NULL,
    [VoucherNumber] VARCHAR (50) NOT NULL,
    [ProgramId]     INT          NOT NULL,
    [GCID]          VARCHAR (50) NULL,
    CONSTRAINT [PK_EXT_INGCID_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [index_EXT_INGCID_GCID]
    ON [dbo].[EXT_INGCID]([GCID] ASC);

