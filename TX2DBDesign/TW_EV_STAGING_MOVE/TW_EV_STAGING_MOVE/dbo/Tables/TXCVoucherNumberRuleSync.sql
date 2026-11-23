CREATE TABLE [dbo].[TXCVoucherNumberRuleSync] (
    [RunId]                VARCHAR (50)  NULL,
    [Id]                   INT           NULL,
    [VoucherNumberPrefix]  VARCHAR (15)  NULL,
    [VoucherNumberType]    TINYINT       NULL,
    [VoucherNumberLength]  INT           NULL,
    [VoucherNumberExample] VARCHAR (50)  NULL,
    [RuleName]             NVARCHAR (50) NULL,
    [VoucherGenerator]     TINYINT       NULL,
    [PinCodeType]          INT           NULL,
    [HasMultiBarcode]      BIT           NULL,
    [ShowCodeType]         VARCHAR (20)  NULL,
    [DisplayText]          BIT           NULL,
    [RequireExpiryDate]    BIT           NULL,
    [TXCMerchantId]        INT           NULL,
    [TX2MerchantId]        INT           NULL,
    [TXCAlgorithmId]       INT           NULL,
    [TX2AlgorithmId]       INT           NULL,
    [GeneratedBy]          TINYINT       NULL
);

