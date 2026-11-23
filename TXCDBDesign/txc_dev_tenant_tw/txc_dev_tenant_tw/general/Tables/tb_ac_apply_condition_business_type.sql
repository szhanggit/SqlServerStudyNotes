CREATE TABLE [general].[tb_ac_apply_condition_business_type] (
    [apply_condition_business_type_id] INT            IDENTITY (1, 1) NOT NULL,
    [apply_condition_id]               INT            NOT NULL,
    [business_type_id]                 INT            NOT NULL,
    [created_by]                       NVARCHAR (250) NOT NULL,
    [created_on]                       DATETIME       NOT NULL,
    [last_updated_by]                  NVARCHAR (250) NULL,
    [last_updated_on]                  DATETIME       NULL,
    [timestamp]                        ROWVERSION     NOT NULL,
    CONSTRAINT [PK_tb_ac_apply_condition_business_type] PRIMARY KEY CLUSTERED ([apply_condition_business_type_id] ASC),
    CONSTRAINT [UK_tb_ac_apply_condition_business_type] UNIQUE NONCLUSTERED ([apply_condition_id] ASC, [business_type_id] ASC)
);

