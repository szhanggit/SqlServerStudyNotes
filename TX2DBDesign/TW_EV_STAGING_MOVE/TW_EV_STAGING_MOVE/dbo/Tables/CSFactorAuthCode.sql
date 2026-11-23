CREATE TABLE [dbo].[CSFactorAuthCode] (
    [CsuserId]       INT          NOT NULL,
    [FactorAuthCode] VARCHAR (20) NOT NULL,
    [UpdateTime]     DATETIME     NOT NULL,
    [LoginTime]      DATETIME     NULL
);


GO
CREATE NONCLUSTERED INDEX [idx_CSFactorAuthCode_CsuserId]
    ON [dbo].[CSFactorAuthCode]([CsuserId] ASC);

