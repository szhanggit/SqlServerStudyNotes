CREATE TABLE [dbo].[tb_vo_voucher_order] (
    [order_id]                  INT          NOT NULL,
    [order_line_id]             INT          NOT NULL,
    [product_id]                INT          NOT NULL,
    [order_beneficiary_info_id] BIGINT       NOT NULL,
    [order_sn]                  INT          NOT NULL,
    [order_line_sn]             INT          NOT NULL,
    [order_beneficiary_info_sn] INT          NOT NULL,
    [voucher_id]                BIGINT       NULL,
    [voucher_response_code]     VARCHAR (50) NULL,
    [creation_time]             DATETIME     NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_tb_vo_voucher_order_voucher_id]
    ON [dbo].[tb_vo_voucher_order]([voucher_id] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tb_vo_voucher_order_order_beneficiary_id]
    ON [dbo].[tb_vo_voucher_order]([order_beneficiary_info_id] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tb_vo_voucher_order_order_line_id]
    ON [dbo].[tb_vo_voucher_order]([order_line_id] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tb_vo_voucher_order_order_id]
    ON [dbo].[tb_vo_voucher_order]([order_id] ASC);

