CREATE TABLE [dbo].[PreIssuedCampaignVoucherRequestInfo] (
    [Id]                     INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [OrderNumber]            VARCHAR (50) NOT NULL,
    [OrderBeneficiaryInfoId] BIGINT       NULL,
    [ProductCode]            VARCHAR (50) NOT NULL,
    [VoucherQuantity]        INT          NOT NULL,
    [CreatedOn]              DATETIME     NOT NULL,
    [CreatedBy]              VARCHAR (50) NOT NULL,
    [ProcessStatus]          INT          NOT NULL,
    [GeneratedQTY]           INT          DEFAULT ((0)) NULL,
    [TrashedQTY]             INT          DEFAULT ((0)) NULL,
    [IsTrashActionDone]      BIT          DEFAULT ((0)) NULL,
    [IsClearCacheDone]       BIT          DEFAULT ((0)) NULL,
    [TrashDate]              DATETIME     NULL,
    CONSTRAINT [PK_PreIssuedCampaignVoucherRequestInfo] PRIMARY KEY CLUSTERED ([Id] ASC)
);

