CREATE TABLE [dbo].[AccountLETransBuffer] (
    [Id]            BIGINT       IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [AccountNumber] VARCHAR (50) NULL,
    [ProgramCode]   VARCHAR (20) NULL,
    [TranCode]      VARCHAR (50) NULL,
    [MerchantCode]  VARCHAR (50) NULL,
    [TranLocalDate] INT          NULL,
    [SessionId]     VARCHAR (50) NULL,
    CONSTRAINT [PK_AccountLETransBuffer] PRIMARY KEY CLUSTERED ([Id] ASC)
);

