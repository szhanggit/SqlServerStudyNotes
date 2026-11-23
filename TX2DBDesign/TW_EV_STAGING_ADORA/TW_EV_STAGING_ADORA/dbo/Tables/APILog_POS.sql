CREATE TABLE [dbo].[APILog_POS] (
    [Id]              BIGINT         IDENTITY (1, 1) NOT NULL,
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
    CONSTRAINT [PK_APILog_POS_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);

