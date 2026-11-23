CREATE TYPE [dbo].[ProductRedeemDateBlacklistSetType] AS TABLE (
    [BlackDate] DATE NOT NULL,
    PRIMARY KEY CLUSTERED ([BlackDate] ASC));

