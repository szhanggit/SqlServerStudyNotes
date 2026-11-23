CREATE TABLE [dbo].[EXT_GR_VoucherInfo_Buffer] (
    [SessionId]          VARCHAR (50)   NOT NULL,
    [ProgramId]          INT            NOT NULL,
    [VoucherNumber]      VARCHAR (50)   NOT NULL,
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
    [CreatedOn]          DATETIME       NOT NULL,
    [InvoiceNumber]      NVARCHAR (255) NULL,
    [PayToMerchant]      NVARCHAR (255) NULL,
    [Misc1]              NVARCHAR (255) NULL,
    [Misc2]              NVARCHAR (255) NULL,
    [URLExpiryPeriod]    VARCHAR (50)   NULL,
    CONSTRAINT [UK_EXT_GR_VoucherInfo_Buffer_ProgramId_VoucherNumber] UNIQUE NONCLUSTERED ([ProgramId] ASC, [VoucherNumber] ASC)
);

