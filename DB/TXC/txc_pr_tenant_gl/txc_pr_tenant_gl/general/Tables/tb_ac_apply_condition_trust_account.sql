CREATE TABLE [general].[tb_ac_apply_condition_trust_account] (
    [apply_condition_trust_account_id] INT            IDENTITY (1, 1) NOT NULL,
    [apply_condition_id]               INT            NOT NULL,
    [trust_account_id]                 INT            NOT NULL,
    [created_by]                       NVARCHAR (250) NOT NULL,
    [created_on]                       DATETIME       NOT NULL,
    [last_updated_by]                  NVARCHAR (250) NULL,
    [last_updated_on]                  DATETIME       NULL,
    [timestamp]                        ROWVERSION     NOT NULL,
    CONSTRAINT [PK_tb_ac_apply_condition_trust_account] PRIMARY KEY CLUSTERED ([apply_condition_trust_account_id] ASC),
    CONSTRAINT [UK_tb_ac_apply_condition_trust_account] UNIQUE NONCLUSTERED ([apply_condition_id] ASC, [trust_account_id] ASC)
);

