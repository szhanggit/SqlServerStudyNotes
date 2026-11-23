CREATE TABLE [dbo].[ConsumeConfirmationInfo] (
    [Id]               BIGINT         IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [VoucherId]        BIGINT         NOT NULL,
    [ConfirmationInfo] NVARCHAR (200) NOT NULL,
    [LastUpdatedOn]    DATETIME       NOT NULL,
    CONSTRAINT [PK_ConsumeConfirmationInfo_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ConsumeConfirmationInfo_Voucher_VoucherId] FOREIGN KEY ([VoucherId]) REFERENCES [dbo].[Voucher] ([Id])
);


GO
CREATE NONCLUSTERED INDEX [IX_ConsumeConfirmationInfo_VoucherId_1]
    ON [dbo].[ConsumeConfirmationInfo]([VoucherId] ASC)
    INCLUDE([ConfirmationInfo]);

