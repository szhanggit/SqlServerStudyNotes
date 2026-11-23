CREATE TABLE [dbo].[VoucherReservationBatch] (
    [Id]                       BIGINT         IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [BatchNo]                  VARCHAR (20)   NOT NULL,
    [VoucherCount]             INT            NOT NULL,
    [VoucherReservationCodeId] INT            NOT NULL,
    [Description]              NVARCHAR (500) NULL,
    [CreatedOn]                DATETIME       NOT NULL,
    [LastDownloadedOn]         DATETIME       NULL,
    [LastDownloadedBy]         NVARCHAR (50)  NULL,
    [ProductId]                INT            NOT NULL,
    [ExpiryDate]               DATETIME       NULL,
    [AvailableStartDate]       INT            NOT NULL,
    [AvailableEndDate]         INT            NOT NULL,
    CONSTRAINT [PK_VoucherReservationBatch_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_VoucherReservationBatch_Product_ProductId] FOREIGN KEY ([ProductId]) REFERENCES [dbo].[Product] ([Id]),
    CONSTRAINT [FK_VoucherReservationBatch_VoucherReservationCode_VoucherReservationCodeId] FOREIGN KEY ([VoucherReservationCodeId]) REFERENCES [dbo].[VoucherReservationCode] ([Id]),
    CONSTRAINT [UK_VoucherReservationBatch_BatchNo] UNIQUE NONCLUSTERED ([BatchNo] ASC)
);

