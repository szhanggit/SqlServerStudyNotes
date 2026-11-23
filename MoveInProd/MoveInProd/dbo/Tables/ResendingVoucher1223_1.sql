CREATE TABLE [dbo].[ResendingVoucher1223] (
    [Id]            INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [VoucherNumber] VARCHAR (100) NULL,
    [ProgramId]     INT           NULL,
    [Status]        INT           NULL,
    [Session]       VARCHAR (100) NULL,
    [OrderId]       INT           NULL,
    [OrderLineId]   INT           NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

