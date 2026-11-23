CREATE TABLE [dbo].[OLAPSyncTransactionFeeBuffer] (
    [Id]                          BIGINT          NULL,
    [OLAPSyncTransactionBufferId] BIGINT          NOT NULL,
    [ServiceFeeId]                INT             NOT NULL,
    [TranFee]                     NUMERIC (20, 6) NOT NULL,
    [SessionId]                   VARCHAR (50)    NULL
);


GO
CREATE NONCLUSTERED INDEX [idex_OLAPSyncTransactionFeeBuffer_OLAPSyncTransactionBufferId]
    ON [dbo].[OLAPSyncTransactionFeeBuffer]([OLAPSyncTransactionBufferId] ASC);


GO
CREATE NONCLUSTERED INDEX [idex_OLAPSyncTransactionFeeBuffer_SessionId]
    ON [dbo].[OLAPSyncTransactionFeeBuffer]([SessionId] ASC);

