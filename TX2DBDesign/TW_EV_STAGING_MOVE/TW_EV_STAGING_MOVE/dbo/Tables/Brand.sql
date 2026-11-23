CREATE TABLE [dbo].[Brand] (
    [Id]         INT           IDENTITY (1, 1) NOT NULL,
    [BrandName]  NVARCHAR (30) NOT NULL,
    [MediaId]    INT           NULL,
    [Status]     INT           NOT NULL,
    [CreateTime] DATETIME      NULL,
    [Creater]    NVARCHAR (20) NOT NULL,
    CONSTRAINT [PK_Brand_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_Brand_BrandName]
    ON [dbo].[Brand]([BrandName] ASC);

