CREATE TABLE [dbo].[BillingBoxPart1GeneratingLog] (
    [Id]              BIGINT        IDENTITY (1, 1) NOT NULL,
    [IsFileGenerated] INT           NULL,
    [CompareDateInt]  INT           NULL,
    [CreatedOn]       DATETIME      NULL,
    [LastUpdated]     DATETIME      NULL,
    [Comments]        NVARCHAR (50) NULL,
    CONSTRAINT [PK_BillingBoxPart1GeneratingLog_Id] PRIMARY KEY CLUSTERED ([Id] DESC)
);

