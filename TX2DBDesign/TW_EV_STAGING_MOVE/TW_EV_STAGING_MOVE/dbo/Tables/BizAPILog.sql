CREATE TABLE [dbo].[BizAPILog] (
    [Id]              BIGINT         IDENTITY (1, 1) NOT NULL,
    [ConsumerCode]    VARCHAR (50)   NOT NULL,
    [OperationCode]   VARCHAR (50)   NOT NULL,
    [RequestId]       VARCHAR (50)   NOT NULL,
    [RequestHash]     VARCHAR (255)  NOT NULL,
    [TXRequestId]     VARCHAR (50)   NOT NULL,
    [CreatedOn]       DATETIME       NOT NULL,
    [ResponseCode]    VARCHAR (50)   NULL,
    [Comment]         NVARCHAR (MAX) NULL,
    [ResponsedOn]     DATETIME       NULL,
    [RequestMessage]  NVARCHAR (MAX) NULL,
    [ResponseMessage] NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_BizAPILog] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UK_BizAPILog_RequestHash] UNIQUE NONCLUSTERED ([RequestHash] ASC)
);

