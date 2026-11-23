CREATE TABLE [dbo].[EXT_CPC] (
    [Id]             BIGINT   NOT NULL,
    [TrustStartDate] DATETIME NULL,
    [TrustEndDate]   DATETIME NULL,
    CONSTRAINT [PK_EXT_CPC_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);

