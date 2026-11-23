CREATE TABLE [dbo].[EXT_MyCard_Buffer] (
    [VoucherNumber]  VARCHAR (50)  NOT NULL,
    [ProgramId]      INT           NOT NULL,
    [Barcode1]       VARCHAR (50)  NOT NULL,
    [Barcode2]       VARCHAR (50)  NOT NULL,
    [TrustStartDate] DATETIME      NULL,
    [TrustEndDate]   DATETIME      NULL,
    [PrizeName]      NVARCHAR (50) NULL,
    [PrizeSn]        NVARCHAR (50) NULL,
    [PrizePW]        NVARCHAR (50) NULL,
    [PrizeID]        NVARCHAR (50) NULL,
    [SessionId]      VARCHAR (50)  NOT NULL
);


GO
CREATE NONCLUSTERED INDEX [Index_EXT_MyCard_Buffer_SessionId]
    ON [dbo].[EXT_MyCard_Buffer]([SessionId] ASC);

