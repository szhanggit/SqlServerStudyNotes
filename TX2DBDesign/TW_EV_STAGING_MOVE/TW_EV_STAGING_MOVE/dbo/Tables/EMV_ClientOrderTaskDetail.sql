CREATE TABLE [dbo].[EMV_ClientOrderTaskDetail] (
    [Id]                INT IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ClientOrderTaskId] INT NOT NULL,
    [ClientOrderLineId] INT NOT NULL,
    CONSTRAINT [PK_EMV_ClientOrderTaskDetail] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_EMV_ClientOrderTaskDetail_ClientOrderLine_Id] FOREIGN KEY ([ClientOrderLineId]) REFERENCES [dbo].[EMV_ClientOrderLine] ([Id]),
    CONSTRAINT [FK_EMV_ClientOrderTaskDetail_ClientOrderTask_Id] FOREIGN KEY ([ClientOrderTaskId]) REFERENCES [dbo].[EMV_ClientOrderTask] ([Id])
);

