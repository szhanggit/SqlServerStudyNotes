CREATE TABLE [dbo].[ConsumeConfirmationInfo] (
    [Id]               BIGINT         IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [VoucherId]        BIGINT         NOT NULL,
    [ConfirmationInfo] NVARCHAR (200) NOT NULL,
    [LastUpdatedOn]    DATETIME       NOT NULL,
    CONSTRAINT [PK_ConsumeConfirmationInfo_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_ConsumeConfirmationInfo_Voucher_VoucherId] FOREIGN KEY ([VoucherId]) REFERENCES [dbo].[Voucher] ([Id])
);

