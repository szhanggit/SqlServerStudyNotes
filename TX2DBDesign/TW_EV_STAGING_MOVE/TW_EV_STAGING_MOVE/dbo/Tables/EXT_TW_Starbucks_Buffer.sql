CREATE TABLE [dbo].[EXT_TW_Starbucks_Buffer] (
    [SessionId]     VARCHAR (50)   NOT NULL,
    [ProgramId]     INT            NOT NULL,
    [VoucherNumber] VARCHAR (30)   NOT NULL,
    [DownloadURL]   NVARCHAR (500) NOT NULL,
    [AuthCode]      VARCHAR (50)   NOT NULL,
    [ExpiryDate]    VARCHAR (50)   NOT NULL,
    [QRCode]        NVARCHAR (500) NOT NULL
);

