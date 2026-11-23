CREATE TABLE [dbo].[EXT_IN_EMVCancelRCN] (
    [EMV_ClientOrderLineId] INT      NOT NULL,
    [CreatedOn]             DATETIME NOT NULL,
    [Reason]                TINYINT  NULL,
    [CancellationDate]      DATETIME NULL
);


GO
CREATE NONCLUSTERED INDEX [Index_EMV_ClientOrderLineId]
    ON [dbo].[EXT_IN_EMVCancelRCN]([EMV_ClientOrderLineId] ASC);

