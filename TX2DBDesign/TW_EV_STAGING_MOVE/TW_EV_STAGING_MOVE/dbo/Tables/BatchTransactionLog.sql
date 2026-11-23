CREATE TABLE [dbo].[BatchTransactionLog] (
    [Id]               INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [BatchNo]          VARCHAR (50) NOT NULL,
    [CreatedOn]        DATETIME     NOT NULL,
    [CreatedBy]        VARCHAR (50) NOT NULL,
    [ApprovedOn]       DATETIME     NULL,
    [ApprovedBy]       VARCHAR (50) NULL,
    [Result]           INT          NULL,
    [NeedToBeApproved] INT          NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

