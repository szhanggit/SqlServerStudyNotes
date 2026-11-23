CREATE TABLE [voucher].[tb_vtl_voucher_transition_log] (
    [id]                  BIGINT         IDENTITY (1, 1) NOT NULL,
    [voucher_id]          BIGINT         NOT NULL,
    [state_transition_id] SMALLINT       NOT NULL,
    [merchant_id]         INT            NULL,
    [shop_id]             INT            NULL,
    [tran_code]           VARCHAR (90)   NULL,
    [rsv1]                NVARCHAR (255) NULL,
    [request_amount]      BIGINT         NULL,
    [request_datetime]    DATETIME       NULL,
    [business_date]       DATETIME       NULL,
    [operator_id]         VARCHAR (50)   NULL,
    [reference_date]      DATETIME       NULL,
    [created_on]          DATETIME       NOT NULL,
    [row_version]         ROWVERSION     NOT NULL,
    PRIMARY KEY NONCLUSTERED ([id] ASC),
    CONSTRAINT [FK_voucher_log_state_transition] FOREIGN KEY ([state_transition_id]) REFERENCES [voucher].[tb_vst_voucher_state_transition] ([id])
);

