CREATE TABLE [redemption].[tb_sc_starbucks_clearing] (
    [id]                BIGINT       NOT NULL,
    [pos_id]            INT          NOT NULL,
    [business_day]      INT          NOT NULL,
    [shift_code]        VARCHAR (50) NOT NULL,
    [clearing_type]     SMALLINT     NOT NULL,
    [terminal_ssn]      VARCHAR (50) NOT NULL,
    [received_datetime] DATETIME     NOT NULL,
    CONSTRAINT [PK_tb_sc_starbucks_clearing] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_tb_sc_starbucks_clearing_p_pos] FOREIGN KEY ([pos_id]) REFERENCES [redemption].[tb_p_pos] ([id])
);

