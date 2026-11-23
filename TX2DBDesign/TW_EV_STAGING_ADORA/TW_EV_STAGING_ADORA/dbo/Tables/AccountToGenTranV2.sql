CREATE TABLE [dbo].[AccountToGenTranV2] (
    [AccountNumber] VARCHAR (50) NOT NULL,
    [ProgramCode]   VARCHAR (20) NOT NULL,
    [HostSSN]       VARCHAR (20) NULL,
    [TranAmount]    INT          NOT NULL,
    [TranType]      INT          NOT NULL,
    [PlanDateTime]  DATETIME     NOT NULL,
    [ActiveTo]      DATETIME     NOT NULL,
    [SessionId]     VARCHAR (50) NULL
);


GO
CREATE NONCLUSTERED INDEX [IDX_AccountToGenTranV2_SessionId]
    ON [dbo].[AccountToGenTranV2]([SessionId] ASC);

