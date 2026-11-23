CREATE TABLE [dbo].[TrustExpiryPolicy] (
    [Id]        INT           IDENTITY (1, 1) NOT NULL,
    [Name]      NVARCHAR (50) NOT NULL,
    [IsDefault] BIT           NOT NULL,
    CONSTRAINT [PK_TrustExpiryPolicy] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UK_TrustExpiryPolicy] UNIQUE NONCLUSTERED ([Name] ASC)
);

