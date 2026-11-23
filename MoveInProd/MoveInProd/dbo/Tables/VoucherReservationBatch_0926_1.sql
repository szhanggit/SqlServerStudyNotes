CREATE TABLE [dbo].[VoucherReservationBatch_0926] (
    [Id]                       BIGINT         IDENTITY (1, 1) NOT NULL,
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
    [AvailableEndDate]         INT            NOT NULL
);

