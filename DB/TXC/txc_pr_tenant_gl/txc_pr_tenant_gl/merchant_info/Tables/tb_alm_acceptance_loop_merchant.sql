CREATE TABLE [merchant_info].[tb_alm_acceptance_loop_merchant] (
    [acceptance_loop_merchant_id] INT            IDENTITY (1, 1) NOT NULL,
    [acceptance_loop_id]          INT            NOT NULL,
    [merchant_id]                 INT            NOT NULL,
    [status]                      BIT            NOT NULL,
    [created_by]                  NVARCHAR (250) NOT NULL,
    [created_on]                  DATETIME       NOT NULL,
    [last_updated_by]             NVARCHAR (250) NULL,
    [last_updated_on]             DATETIME       NULL,
    [timestamp]                   ROWVERSION     NOT NULL,
    CONSTRAINT [PK_tb_alm_acceptance_loop_merchant] PRIMARY KEY CLUSTERED ([acceptance_loop_merchant_id] ASC),
    CONSTRAINT [FK_tb_alm_acceptance_loop_merchant_tb_al_acceptance_loop] FOREIGN KEY ([acceptance_loop_id]) REFERENCES [merchant_info].[tb_al_acceptance_loop] ([acceptance_loop_id]),
    CONSTRAINT [FK_tb_alm_acceptance_loop_merchant_tb_m_merchant] FOREIGN KEY ([merchant_id]) REFERENCES [merchant_info].[tb_m_merchant] ([id])
);

