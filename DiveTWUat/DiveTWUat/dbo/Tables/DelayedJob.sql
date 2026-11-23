CREATE TABLE [dbo].[DelayedJob] (
    [Id]              BIGINT         IDENTITY (1, 1) NOT NULL,
    [ProgramCode]     VARCHAR (20)   NOT NULL,
    [VendorCode]      VARCHAR (50)   NOT NULL,
    [ProductCode]     VARCHAR (50)   NOT NULL,
    [RequestId]       VARCHAR (50)   NOT NULL,
    [TypeName]        VARCHAR (200)  NOT NULL,
    [OperationCode]   VARCHAR (50)   NOT NULL,
    [JsonArguments]   NVARCHAR (MAX) NULL,
    [Comment]         NVARCHAR (MAX) NULL,
    [CreatedOn]       DATETIME       NOT NULL,
    [ExecutingStatus] TINYINT        NULL,
    [ExecutingTime]   DATETIME       NULL,
    [ServerCode]      VARCHAR (50)   NULL,
    CONSTRAINT [PK_DelayedJob_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);

