CREATE TABLE [dbo].[EXT_TW_FamilyMartBardCodeOne] (
    [Id]        BIGINT        NOT NULL,
    [Bardcode1] VARCHAR (50)  NOT NULL,
    [CreatedOn] SMALLDATETIME DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_EXT_TW_FamilyMartBardCodeOne_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);

