CREATE TABLE [dbo].[EXT_Incomm_Apple] (
    [Id]       BIGINT       NOT NULL,
    [Barcode1] VARCHAR (50) NOT NULL,
    [Barcode2] VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_EXT_Incomm_Apple_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);

