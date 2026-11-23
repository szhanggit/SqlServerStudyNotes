CREATE TABLE [dbo].[TXCTenant] (
    [Id]   INT          NOT NULL,
    [Name] VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_TXCTenant] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_TXCTenant]
    ON [dbo].[TXCTenant]([Name] ASC);

