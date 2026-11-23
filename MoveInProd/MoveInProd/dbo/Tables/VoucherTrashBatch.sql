CREATE TABLE [dbo].[VoucherTrashBatch] (
    [Id]                       INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [BatchNo]                  VARCHAR (20)  NOT NULL,
    [VoucherCount]             INT           NOT NULL,
    [VoucherReservationCodeId] INT           NOT NULL,
    [ProductId]                INT           NOT NULL,
    [CreatedOn]                DATETIME      NOT NULL,
    [CreatedBy]                NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_VoucherTrashBatch_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_VoucherTrashBatch_VoucherReservationCode_VoucherReservationCodeId] FOREIGN KEY ([VoucherReservationCodeId]) REFERENCES [dbo].[VoucherReservationCode] ([Id])
);

