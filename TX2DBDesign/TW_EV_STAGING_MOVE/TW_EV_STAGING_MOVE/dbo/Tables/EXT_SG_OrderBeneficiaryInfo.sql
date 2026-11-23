CREATE TABLE [dbo].[EXT_SG_OrderBeneficiaryInfo] (
    [Id]               BIGINT         NOT NULL,
    [MemberId]         NVARCHAR (255) NULL,
    [VoucherHistoryId] NVARCHAR (30)  NULL,
    CONSTRAINT [PK_EXT_SG_OrderBeneficiaryInfo_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);

