CREATE TABLE [dbo].[VoucherMovingLog] (
    [Id]                        INT            IDENTITY (1, 1) NOT NULL,
    [VoucherReservationBatchId] INT            NULL,
    [Amount]                    INT            NULL,
    [Increase]                  INT            NULL,
    [GUID]                      VARCHAR (1000) NOT NULL,
    [DateTime]                  DATETIME       NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

