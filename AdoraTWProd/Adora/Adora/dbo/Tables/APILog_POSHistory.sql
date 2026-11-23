CREATE TABLE [dbo].[APILog_POSHistory] (
    [Id]              BIGINT         NOT NULL,
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
    [TranType]        VARCHAR (50)   NULL
) ON [DATA2] TEXTIMAGE_ON [DATA2];

