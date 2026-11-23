CREATE TYPE [dbo].[BulkDividedTasksMessageEntityType] AS TABLE (
    [BulkDividedTasksId] BIGINT         NULL,
    [messageId]          BIGINT         NULL,
    [SPId]               NVARCHAR (100) NULL,
    [SPStatus]           INT            NULL);

