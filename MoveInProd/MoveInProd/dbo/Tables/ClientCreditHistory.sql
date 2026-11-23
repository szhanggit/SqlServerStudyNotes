CREATE TABLE [dbo].[ClientCreditHistory] (
    [Id]              INT             IDENTITY (1, 1) NOT NULL,
    [ClientId]        INT             NOT NULL,
    [CreditLimit]     DECIMAL (18, 2) NOT NULL,
    [AvailableCredit] DECIMAL (18, 2) NOT NULL,
    [Parkfund]        DECIMAL (18, 2) NOT NULL,
    [ClientEmail]     VARCHAR (200)   NOT NULL,
    [ExtendEmail]     VARCHAR (200)   NOT NULL,
    [MailSendStatus]  INT             NOT NULL,
    [ModifyVersion]   INT             NOT NULL
);


GO
CREATE NONCLUSTERED INDEX [Index_ClientCreditHistory_ClientId]
    ON [dbo].[ClientCreditHistory]([ClientId] ASC);

