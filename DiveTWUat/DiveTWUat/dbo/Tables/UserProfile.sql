CREATE TABLE [dbo].[UserProfile] (
    [Id]              INT           IDENTITY (1, 1) NOT NULL,
    [UserName]        NVARCHAR (30) NOT NULL,
    [CultureInfoCode] INT           NULL,
    [Timezone]        INT           NULL,
    CONSTRAINT [PK_UserProfile] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_UserProfile_Dictionary_CultureInfoCode_Id] FOREIGN KEY ([CultureInfoCode]) REFERENCES [dbo].[Dictionary] ([Id]),
    CONSTRAINT [FK_UserProfile_TimezoneOffset_Timezone_Id] FOREIGN KEY ([Timezone]) REFERENCES [dbo].[TimezoneOffset] ([Id]),
    CONSTRAINT [UK_UserName_UserProfile] UNIQUE NONCLUSTERED ([UserName] ASC)
);

