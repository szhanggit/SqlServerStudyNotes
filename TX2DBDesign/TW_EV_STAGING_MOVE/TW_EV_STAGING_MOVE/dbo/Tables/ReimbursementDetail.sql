CREATE TABLE [dbo].[ReimbursementDetail] (
    [Id]                       BIGINT        IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ReimbursementId]          BIGINT        NOT NULL,
    [ClientQuotationProductId] INT           NOT NULL,
    [ReimbursementSchemeId]    INT           NULL,
    [TransactionCount]         INT           NULL,
    [CreatedOn]                DATETIME      NULL,
    [CreatedBy]                NVARCHAR (50) NULL,
    CONSTRAINT [PK_ReimbursementDetail_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ReimbursementDetail_Reimbursement_ReimbursementId] FOREIGN KEY ([ReimbursementId]) REFERENCES [dbo].[Reimbursement] ([Id])
);

