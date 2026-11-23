CREATE TABLE [dbo].[APILog] (
    [Id]              BIGINT         IDENTITY (1, 1) NOT NULL,
    [ProgramCode]     VARCHAR (20)   NOT NULL,
    [OperationCode]   VARCHAR (50)   NOT NULL,
    [RequestId]       VARCHAR (50)   NOT NULL,
    [CreatedOn]       DATETIME       NOT NULL,
    [ResponseCode]    VARCHAR (50)   NULL,
    [Comment]         NVARCHAR (MAX) NULL,
    [ResponsedOn]     DATETIME       NULL,
    [RequestMessage]  NVARCHAR (MAX) NULL,
    [ResponseMessage] NVARCHAR (MAX) NULL,
    [ProductCode]     VARCHAR (50)   NOT NULL,
    [ServerCode]      VARCHAR (50)   NULL,
    [VendorCode]      VARCHAR (50)   NOT NULL,
    CONSTRAINT [PK_APILog_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UK_APILog_RequestId] UNIQUE NONCLUSTERED ([RequestId] ASC, [ProgramCode] ASC)
);

