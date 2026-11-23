CREATE TABLE [voucher].[tb_vs_voucher_state] (
    [id]          TINYINT       NOT NULL,
    [state_name]  VARCHAR (100) NOT NULL,
    [row_version] ROWVERSION    NOT NULL,
    CONSTRAINT [PK_voucher_state_id] PRIMARY KEY CLUSTERED ([id] ASC)
);

