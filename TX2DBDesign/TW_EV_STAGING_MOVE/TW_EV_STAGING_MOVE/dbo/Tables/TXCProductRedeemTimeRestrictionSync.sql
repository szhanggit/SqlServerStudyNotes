CREATE TABLE [dbo].[TXCProductRedeemTimeRestrictionSync] (
    [RunId]                             VARCHAR (50) NOT NULL,
    [TXCProductRedeemTimeRestrictionId] INT          NULL,
    [DayOfTheWeek]                      TINYINT      NULL,
    [StartTime]                         TIME (7)     NULL,
    [EndTime]                           TIME (7)     NULL
);


GO
CREATE CLUSTERED INDEX [IX_TXCProductRedeemTimeRestrictionSync]
    ON [dbo].[TXCProductRedeemTimeRestrictionSync]([RunId] ASC, [TXCProductRedeemTimeRestrictionId] ASC) WITH (FILLFACTOR = 90);

