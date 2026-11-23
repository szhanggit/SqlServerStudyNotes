CREATE TABLE [dbo].[VoucherCombo20220103] (
    [Id]                         BIGINT        IDENTITY (1, 1) NOT NULL,
    [MasterVoucherId]            BIGINT        NOT NULL,
    [ChildVoucherId]             BIGINT        NOT NULL,
    [Status]                     TINYINT       NOT NULL,
    [ComboOn]                    DATETIME      NOT NULL,
    [MasterRedemptionTranCode]   VARCHAR (50)  NULL,
    [UncomboOn]                  DATETIME      NULL,
    [UncomboBy]                  NVARCHAR (50) NULL,
    [MasterRedemptionTranAmount] INT           NULL
);

