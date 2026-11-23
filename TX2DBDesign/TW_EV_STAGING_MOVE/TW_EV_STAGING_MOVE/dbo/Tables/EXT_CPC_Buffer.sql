CREATE TABLE [dbo].[EXT_CPC_Buffer] (
    [VoucherNumber]  VARCHAR (50) NOT NULL,
    [ProgramId]      INT          NOT NULL,
    [TrustStartDate] DATETIME     NULL,
    [TrustEndDate]   DATETIME     NULL,
    [SessionId]      VARCHAR (50) NOT NULL
);


GO
CREATE NONCLUSTERED INDEX [Index_EXT_CPC_Buffer_SessionId]
    ON [dbo].[EXT_CPC_Buffer]([SessionId] ASC);

