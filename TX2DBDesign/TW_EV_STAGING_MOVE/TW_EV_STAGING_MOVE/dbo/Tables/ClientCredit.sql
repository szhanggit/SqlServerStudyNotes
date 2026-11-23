CREATE TABLE [dbo].[ClientCredit] (
    [Id]              INT             IDENTITY (1, 1) NOT NULL,
    [ClientId]        INT             NOT NULL,
    [CreditLimit]     DECIMAL (18, 2) NOT NULL,
    [AvailableCredit] DECIMAL (18, 2) NOT NULL,
    [Parkfund]        DECIMAL (18, 2) NOT NULL,
    [ClientEmail]     VARCHAR (200)   NOT NULL,
    [ExtendEmail]     VARCHAR (200)   NOT NULL,
    [MailSendStatus]  INT             NOT NULL,
    [ModifyVersion]   INT             NOT NULL,
    [CreatedOn]       DATETIME        NULL,
    [UpdatedOn]       DATETIME        NULL,
    CONSTRAINT [PK_ClientCredit_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [Index_ClientCredit_ClientId]
    ON [dbo].[ClientCredit]([ClientId] ASC);

