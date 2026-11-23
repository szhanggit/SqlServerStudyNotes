CREATE TABLE [dbo].[ClientCreditValue] (
    [Id]               BIGINT          IDENTITY (1, 1) NOT NULL,
    [Amount]           DECIMAL (18, 2) NOT NULL,
    [ClientId]         INT             NOT NULL,
    [Source]           VARCHAR (50)    NULL,
    [CreatedOn]        DATETIME        NOT NULL,
    [UpdatedOn]        DATETIME        NOT NULL,
    [VoucherSessionId] VARCHAR (50)    NULL,
    [SessionId]        VARCHAR (50)    NULL,
    [Status]           INT             NOT NULL,
    CONSTRAINT [PK_ClientCreditValue_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [IDX_ClientCreditValue_Status]
    ON [dbo].[ClientCreditValue]([Status] ASC) WITH (FILLFACTOR = 90);

