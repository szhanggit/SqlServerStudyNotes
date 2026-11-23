CREATE TABLE [dbo].[EXT_TW_Starbucks] (
    [Id]          BIGINT         NOT NULL,
    [DownloadURL] NVARCHAR (500) NOT NULL,
    [AuthCode]    VARCHAR (50)   NOT NULL,
    [ExpiryDate]  VARCHAR (50)   NOT NULL,
    [QRCode]      NVARCHAR (500) NOT NULL,
    CONSTRAINT [PK_EXT_TW_Starbucks_VoucherId] PRIMARY KEY CLUSTERED ([Id] ASC)
);

