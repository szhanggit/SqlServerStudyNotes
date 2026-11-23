CREATE TABLE [dbo].[VoucherOrderBatch] (
    [Id]               INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [OrderId]          INT          NOT NULL,
    [OrderLineId]      INT          NOT NULL,
    [OrderLineStartSN] INT          NOT NULL,
    [OrderLineEndSN]   INT          NOT NULL,
    [Assigned]         BIT          NOT NULL,
    [Moved]            BIT          NOT NULL,
    [SessionId]        VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_VoucherOrderBatch_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);

