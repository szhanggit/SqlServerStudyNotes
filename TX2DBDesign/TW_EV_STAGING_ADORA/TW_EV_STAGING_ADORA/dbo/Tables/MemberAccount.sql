CREATE TABLE [dbo].[MemberAccount] (
    [Id]            INT          IDENTITY (1, 1) NOT NULL,
    [MemberId]      INT          NOT NULL,
    [AccountNumber] VARCHAR (50) NOT NULL,
    [ProgramId]     INT          NOT NULL,
    [AccountType]   VARCHAR (20) NOT NULL,
    CONSTRAINT [PK_MEMBERACCOUNT] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_MemberAccount_Member_MemberId] FOREIGN KEY ([MemberId]) REFERENCES [dbo].[Member] ([Id]),
    CONSTRAINT [UK_MemberAccount_ProgramId_AccountNumber] UNIQUE NONCLUSTERED ([AccountNumber] ASC, [ProgramId] ASC)
);

