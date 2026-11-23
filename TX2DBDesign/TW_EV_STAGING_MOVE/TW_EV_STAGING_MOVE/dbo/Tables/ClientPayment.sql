CREATE TABLE [dbo].[ClientPayment] (
    [Id]            INT             IDENTITY (1, 1) NOT NULL,
    [ClientId]      INT             NOT NULL,
    [PaymentAmount] DECIMAL (18, 2) NOT NULL,
    [RefNumber]     VARCHAR (50)    NULL,
    [PaidDate]      DATETIME        NOT NULL,
    CONSTRAINT [PK_ClientPayment_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [Index_ClientPayment_ClientId]
    ON [dbo].[ClientPayment]([ClientId] ASC);

