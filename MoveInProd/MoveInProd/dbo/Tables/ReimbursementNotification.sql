CREATE TABLE [dbo].[ReimbursementNotification] (
    [Id]                   BIGINT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [HasNotified]          BIT             NOT NULL,
    [ReimbursementTaxType] TINYINT         NOT NULL,
    [Receivers]            NVARCHAR (1000) NULL,
    [Parameters]           NVARCHAR (MAX)  NULL,
    [CreatedOn]            DATETIME        NULL,
    [CreatedBy]            NVARCHAR (50)   NULL,
    [NotifiedOn]           DATETIME        NULL,
    [NotifiedBy]           NVARCHAR (50)   NULL,
    CONSTRAINT [PK_ReimbursementNotification_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90)
);

