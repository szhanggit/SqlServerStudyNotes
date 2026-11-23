CREATE TABLE [dbo].[GRBulkAPIInfo] (
    [SKU]              VARCHAR (50)  NOT NULL,
    [OrderId]          INT           NULL,
    [OrderNumber]      VARCHAR (20)  NULL,
    [FileName]         VARCHAR (500) NULL,
    [Password]         VARCHAR (10)  NULL,
    [CheckSum]         VARCHAR (35)  NULL,
    [Status]           INT           NOT NULL,
    [ExecuteStartTime] DATETIME      NULL,
    [ExecuteEndTime]   DATETIME      NULL,
    [ModifyVersion]    INT           NOT NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_GRBulkAPIInfo_SKU]
    ON [dbo].[GRBulkAPIInfo]([SKU] ASC);

