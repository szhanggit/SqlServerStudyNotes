CREATE TABLE [dbo].[VoucherSequenceNumber] (
    [Id]             INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [VoucherNumber]  VARCHAR (50) NOT NULL,
    [SequenceNumber] BIGINT       NOT NULL,
    CONSTRAINT [PK_VoucherSequenceNumber] PRIMARY KEY CLUSTERED ([Id] ASC)
);

