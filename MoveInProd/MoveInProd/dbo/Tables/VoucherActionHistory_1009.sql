CREATE TABLE [dbo].[VoucherActionHistory_1009] (
    [Id]           BIGINT          IDENTITY (1, 1) NOT NULL,
    [VoucherId]    BIGINT          NOT NULL,
    [ActionType]   SMALLINT        NOT NULL,
    [ActionResult] TINYINT         NOT NULL,
    [Operator]     NVARCHAR (50)   NOT NULL,
    [ActionTime]   DATETIME        NOT NULL,
    [Memo]         NVARCHAR (1000) NULL
);

