CREATE TABLE [dbo].[APILog_2] (
    [Id]              BIGINT         IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ConsumerCode]    VARCHAR (50)   NOT NULL,
    [OperationCode]   VARCHAR (50)   NOT NULL,
    [RequestId]       VARCHAR (50)   NOT NULL,
    [CreatedOn]       DATETIME       NOT NULL,
    [ResponseCode]    VARCHAR (50)   NULL,
    [Comment]         NVARCHAR (MAX) NULL,
    [ResponsedOn]     DATETIME       NULL,
    [RequestMessage]  NVARCHAR (MAX) NULL,
    [ResponseMessage] NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_APILog_2_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UK_APILog_2_RequestId] UNIQUE NONCLUSTERED ([RequestId] ASC)
);

