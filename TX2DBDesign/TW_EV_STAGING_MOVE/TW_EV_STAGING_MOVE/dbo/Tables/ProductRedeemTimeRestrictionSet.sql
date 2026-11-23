CREATE TABLE [dbo].[ProductRedeemTimeRestrictionSet] (
    [Id]                             INT      IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ProductRedeemTimeRestrictionId] INT      NOT NULL,
    [DayOfTheWeek]                   TINYINT  NOT NULL,
    [StartTime]                      TIME (7) NOT NULL,
    [EndTime]                        TIME (7) NOT NULL,
    CONSTRAINT [PK_ProductRedeemTimeRestrictionSet] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ProductRedeemTimeRestrictionSet_ProductRedeemTimeRestriction_ProductRedeemTimeRestrictionId] FOREIGN KEY ([ProductRedeemTimeRestrictionId]) REFERENCES [dbo].[ProductRedeemTimeRestriction] ([Id])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '1--Mon
   2--Tue
   3--Wed
   4--Thu
   5--Fri
   6--Sat
   7--Sun', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ProductRedeemTimeRestrictionSet', @level2type = N'COLUMN', @level2name = N'DayOfTheWeek';

