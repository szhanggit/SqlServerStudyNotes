CREATE TABLE [dbo].[EXT_GR_PacificCoffee] (
    [Id]        BIGINT        NOT NULL,
    [Barcode1]  VARCHAR (50)  NOT NULL,
    [CreatedOn] SMALLDATETIME DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_EXT_GR_PacificCoffee_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);

