CREATE TABLE [dbo].[ServiceFeeTriggerTime] (
    [Id]           INT      IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ServiceFeeId] INT      NOT NULL,
    [TranType]     SMALLINT NOT NULL,
    [Status]       TINYINT  NOT NULL,
    CONSTRAINT [PK_ServiceFeeTriggerTime_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_ServiceFeeTriggerTime_ServiceFee_ServiceFeeId] FOREIGN KEY ([ServiceFeeId]) REFERENCES [dbo].[ServiceFee] ([Id])
);

