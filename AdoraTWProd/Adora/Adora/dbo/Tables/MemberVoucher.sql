CREATE TABLE [dbo].[MemberVoucher] (
    [Id]                    INT            IDENTITY (1, 1) NOT NULL,
    [MemberId]              INT            NOT NULL,
    [GivenBy]               NVARCHAR (100) NULL,
    [AccountNumber]         VARCHAR (50)   NOT NULL,
    [ProgramId]             INT            NOT NULL,
    [AccountType]           VARCHAR (20)   NOT NULL,
    [TransferOutTranCode]   VARCHAR (50)   NULL,
    [TransferOutExpiryDate] DATETIME       NULL,
    [Status]                INT            NOT NULL,
    CONSTRAINT [PK_MEMBERVOUCHER] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_MemberVoucher_Member_MemberId] FOREIGN KEY ([MemberId]) REFERENCES [dbo].[Member] ([Id]),
    CONSTRAINT [UK_MemberVoucher_ProgramId_AccountNumber] UNIQUE NONCLUSTERED ([AccountNumber] ASC, [ProgramId] ASC, [TransferOutTranCode] ASC) WITH (FILLFACTOR = 90)
);

