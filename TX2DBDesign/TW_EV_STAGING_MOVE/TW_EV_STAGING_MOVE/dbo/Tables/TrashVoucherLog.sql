CREATE TABLE [dbo].[TrashVoucherLog] (
    [Id]          INT    IDENTITY (1, 1) NOT NULL,
    [VoucherId]   BIGINT NOT NULL,
    [TrashStatus] INT    NOT NULL,
    CONSTRAINT [PK_TrashVoucherLog_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [index_TrashVoucherLog_VoucherId]
    ON [dbo].[TrashVoucherLog]([VoucherId] ASC)
    INCLUDE([TrashStatus]);

