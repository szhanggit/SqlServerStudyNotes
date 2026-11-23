CREATE TABLE [dbo].[ClientInvoiceCutoffDay] (
    [Id]                           INT     IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ClientInvoiceCutoffSettingId] INT     NOT NULL,
    [Day]                          TINYINT NOT NULL,
    CONSTRAINT [PK_ClientInvoiceCutoffDay_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ClientInvoiceCutoffDay_ClientInvoiceCutoffSetting_ClientInvoiceCutoffSettingId] FOREIGN KEY ([ClientInvoiceCutoffSettingId]) REFERENCES [dbo].[ClientInvoiceCutoffSetting] ([Id])
);

