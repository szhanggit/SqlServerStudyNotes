CREATE TABLE [dbo].[LoadCacheLog] (
    [Id]                 INT            IDENTITY (1, 1) NOT NULL,
    [ProductCode]        NVARCHAR (50)  NOT NULL,
    [User]               NVARCHAR (100) NULL,
    [Result]             INT            NULL,
    [Amount]             INT            NULL,
    [ClickedDateTime]    DATETIME       NOT NULL,
    [AvailableStartDate] NVARCHAR (50)  NULL,
    [AvailableEndDate]   NVARCHAR (50)  NULL,
    [ExpiryDate]         NVARCHAR (50)  NULL
);

