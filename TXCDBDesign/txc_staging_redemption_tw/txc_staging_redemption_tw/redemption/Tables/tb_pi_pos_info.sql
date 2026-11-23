CREATE TABLE [redemption].[tb_pi_pos_info] (
    [id]                   INT           IDENTITY (1, 1) NOT NULL,
    [pos_id]               INT           NOT NULL,
    [work_key]             VARCHAR (100) NULL,
    [work_key_expired_on]  DATETIME      NULL,
    [failed_attempt_count] INT           NOT NULL,
    [row_version]          ROWVERSION    NOT NULL,
    CONSTRAINT [PK_tb_pi_pos_info] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_tb_pi_pos_info_tb_p_pos] FOREIGN KEY ([pos_id]) REFERENCES [redemption].[tb_p_pos] ([id]),
    CONSTRAINT [UK_tb_pi_pos_info_pos_id] UNIQUE NONCLUSTERED ([pos_id] ASC)
);

