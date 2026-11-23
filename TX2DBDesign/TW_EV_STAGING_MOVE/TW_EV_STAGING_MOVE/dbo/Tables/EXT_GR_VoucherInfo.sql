CREATE TABLE [dbo].[EXT_GR_VoucherInfo] (
    [Id]                 BIGINT         NOT NULL,
    [Ecode]              NVARCHAR (500) NOT NULL,
    [Vname]              NVARCHAR (500) NULL,
    [Denomination]       NVARCHAR (500) NULL,
    [Vcurrency]          NVARCHAR (500) NULL,
    [Vpassword]          NVARCHAR (500) NULL,
    [Snumber]            NVARCHAR (500) NULL,
    [IssueDate]          NVARCHAR (500) NULL,
    [ExpiryDate]         NVARCHAR (500) NOT NULL,
    [Vstatus]            NVARCHAR (500) NULL,
    [FinBookingCurrency] NVARCHAR (500) NOT NULL,
    [FinBookingValue]    NVARCHAR (500) NOT NULL,
    [InvoiceNumber]      NVARCHAR (255) NULL,
    [PayToMerchant]      NVARCHAR (255) NULL,
    [Misc1]              NVARCHAR (MAX) NULL,
    [Misc2]              NVARCHAR (MAX) NULL,
    [URLExpiryPeriod]    VARCHAR (50)   NULL,
    [MaskDateTime]       DATETIME       NULL,
    CONSTRAINT [PK_EXT_GR_VoucherInfo_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);

