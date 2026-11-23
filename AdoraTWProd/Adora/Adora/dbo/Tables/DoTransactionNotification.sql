CREATE TABLE [dbo].[DoTransactionNotification] (
    [Id]              BIGINT         IDENTITY (1, 1) NOT NULL,
    [ProgramCode]     VARCHAR (20)   NOT NULL,
    [AccountNumber]   VARCHAR (50)   NOT NULL,
    [TranCode]        VARCHAR (50)   NOT NULL,
    [RequestId]       VARCHAR (50)   NULL,
    [ResponseCode]    VARCHAR (5)    NOT NULL,
    [ResponseMessage] NVARCHAR (MAX) NULL,
    [NotifiedOn]      DATETIME       NULL,
    [Parameters]      NVARCHAR (MAX) NULL,
    [CreatedOn]       DATETIME       NOT NULL,
    [GeneratedOn]     DATETIME       NULL,
    CONSTRAINT [PK_DoTransactionNotification_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90)
);

