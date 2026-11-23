CREATE TABLE [dbo].[ClientInvoiceCutoffSetting] (
    [Id]                    INT IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ClientId]              INT NOT NULL,
    [BusinessModelId]       INT NOT NULL,
    [IsEndDayOfMonthCutoff] BIT DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_ClientInvoiceCutoffSetting_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ClientInvoiceCutoffSetting_BusinessModel_BusinessModelId] FOREIGN KEY ([BusinessModelId]) REFERENCES [dbo].[BusinessModel] ([Id]),
    CONSTRAINT [FK_ClientInvoiceCutoffSetting_Client_ClientId] FOREIGN KEY ([ClientId]) REFERENCES [dbo].[Client] ([Id])
);

