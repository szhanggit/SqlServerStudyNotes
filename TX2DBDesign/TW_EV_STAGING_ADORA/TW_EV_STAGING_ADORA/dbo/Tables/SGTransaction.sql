CREATE TABLE [dbo].[SGTransaction] (
    [TranCode]             VARCHAR (50)  NOT NULL,
    [MemberId]             INT           NOT NULL,
    [IssuerId]             VARCHAR (50)  NULL,
    [Channel]              VARCHAR (50)  NULL,
    [InvoiceDetail]        VARCHAR (150) NULL,
    [TerminalTranId]       VARCHAR (50)  NULL,
    [MerchantCode]         VARCHAR (50)  NOT NULL,
    [ShopCode]             VARCHAR (50)  NULL,
    [TerminalCode]         VARCHAR (50)  NULL,
    [TerminalTranDate]     INT           NULL,
    [TerminalTranTime]     INT           NULL,
    [TerminalSSN]          VARCHAR (50)  NULL,
    [TerminalTranDateTime] DATETIME      NOT NULL,
    [ServerTranDateTime]   DATETIME      NULL,
    [TranType]             SMALLINT      NOT NULL,
    [Status]               TINYINT       DEFAULT ((1)) NOT NULL,
    [GAmount]              INT           DEFAULT ((0)) NOT NULL,
    [PAmount]              INT           NOT NULL,
    [NodeNum]              INT           NULL,
    [CallerIP]             VARCHAR (50)  NULL,
    [TranCodeRef]          VARCHAR (50)  NULL,
    [ModifyVersion]        INT           NOT NULL,
    [ResponseCode]         VARCHAR (5)   NULL,
    [GiveToMemberId]       INT           NULL,
    CONSTRAINT [PK_SGTransaction_TranCode] PRIMARY KEY NONCLUSTERED ([TranCode] ASC),
    CONSTRAINT [FK_SGTransaction_Member_GiveToMemberId] FOREIGN KEY ([GiveToMemberId]) REFERENCES [dbo].[Member] ([Id]),
    CONSTRAINT [FK_SGTransaction_Member_MemberId] FOREIGN KEY ([MemberId]) REFERENCES [dbo].[Member] ([Id]),
    CONSTRAINT [UK_SGTransaction_TerminalTranId] UNIQUE NONCLUSTERED ([TerminalTranId] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '1--normal
   2--reversed
   ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SGTransaction', @level2type = N'COLUMN', @level2name = N'Status';

