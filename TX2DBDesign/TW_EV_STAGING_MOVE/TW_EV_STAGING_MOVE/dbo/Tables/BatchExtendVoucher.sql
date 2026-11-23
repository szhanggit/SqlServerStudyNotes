CREATE TABLE [dbo].[BatchExtendVoucher] (
    [VoucherId]     BIGINT        NOT NULL,
    [ExtendTimes]   INT           NOT NULL,
    [BatchExtendId] VARCHAR (100) NOT NULL,
    CONSTRAINT [UK_BatchExtendVoucher_VoucherId] UNIQUE NONCLUSTERED ([VoucherId] ASC)
);

