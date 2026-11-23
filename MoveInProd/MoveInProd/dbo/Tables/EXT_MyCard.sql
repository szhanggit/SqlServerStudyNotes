CREATE TABLE [dbo].[EXT_MyCard] (
    [Id]             BIGINT        NOT NULL,
    [Barcode1]       VARCHAR (50)  NOT NULL,
    [Barcode2]       VARCHAR (50)  NOT NULL,
    [TrustStartDate] DATETIME      NULL,
    [TrustEndDate]   DATETIME      NULL,
    [PrizeName]      NVARCHAR (50) NULL,
    [PrizeSn]        NVARCHAR (50) NULL,
    [PrizePW]        NVARCHAR (50) NULL,
    [PrizeID]        NVARCHAR (50) NULL,
    CONSTRAINT [PK_EXT_MyCard_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);

