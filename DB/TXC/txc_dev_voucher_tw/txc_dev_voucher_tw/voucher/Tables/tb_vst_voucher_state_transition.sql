CREATE TABLE [voucher].[tb_vst_voucher_state_transition] (
    [id]                    SMALLINT      NOT NULL,
    [state_transition_name] VARCHAR (100) NOT NULL,
    [from_state_id]         TINYINT       NOT NULL,
    [to_state_id]           TINYINT       NOT NULL,
    PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_voucher_state_machine_state_from] FOREIGN KEY ([from_state_id]) REFERENCES [voucher].[tb_vs_voucher_state] ([id]),
    CONSTRAINT [FK_voucher_state_machine_state_to] FOREIGN KEY ([to_state_id]) REFERENCES [voucher].[tb_vs_voucher_state] ([id])
);

