CREATE TABLE [dbo].[VoucherExpiryNotificationConfiguration] (
    [Id]          INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Email]       VARCHAR (100) NOT NULL,
    [ProductCode] VARCHAR (50)  NOT NULL,
    [ProgramId]   INT           NOT NULL,
    [Days]        INT           NOT NULL,
    CONSTRAINT [PK_VoucherExpiryNotificationConfiguration] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_VoucherExpiryNotificationConfigurationProgramId_ProgramId] FOREIGN KEY ([ProgramId]) REFERENCES [dbo].[Program] ([Id])
);

