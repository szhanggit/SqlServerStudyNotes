CREATE TABLE [general].[tb_ac_apply_condition] (
    [apply_condition_id] INT            IDENTITY (1, 1) NOT NULL,
    [name]               NVARCHAR (255) NOT NULL,
    [condition]          NVARCHAR (MAX) NULL,
    [created_by]         NVARCHAR (250) NOT NULL,
    [created_on]         DATETIME       NOT NULL,
    [last_updated_by]    NVARCHAR (250) NULL,
    [last_updated_on]    DATETIME       NULL,
    [timestamp]          ROWVERSION     NOT NULL,
    CONSTRAINT [PK_tb_ac_apply_condition] PRIMARY KEY CLUSTERED ([apply_condition_id] ASC),
    CONSTRAINT [UK_tb_ac_apply_condition] UNIQUE NONCLUSTERED ([name] ASC)
);

