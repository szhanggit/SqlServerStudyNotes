CREATE TABLE [dbo].[APILog_Json] (
    [Id]              BIGINT         IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [MerchantCode]    VARCHAR (50)   NOT NULL,
    [ShopCode]        VARCHAR (50)   NOT NULL,
    [TerminalSSN]     VARCHAR (50)   NOT NULL,
    [RequestId]       VARCHAR (50)   NULL,
    [CreatedOn]       DATETIME       NOT NULL,
    [ResponseCode]    VARCHAR (50)   NULL,
    [Comment]         NVARCHAR (MAX) NULL,
    [ResponsedOn]     DATETIME       NULL,
    [RequestMessage]  NVARCHAR (MAX) NULL,
    [ResponseMessage] NVARCHAR (MAX) NULL,
    [TranCode]        VARCHAR (50)   NULL,
    [TranType]        VARCHAR (50)   NULL,
    CONSTRAINT [PK_APILog_Json_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90)
);

