CREATE TABLE [dbo].[tb_gr_svrh_send_voucher_request_history] (
    [request_Id]              NVARCHAR (64) NOT NULL,
    [gr_client_order_line_id] INT           NOT NULL,
    CONSTRAINT [PK_tb_gr_svrh_send_voucher_request_history] PRIMARY KEY CLUSTERED ([request_Id] ASC, [gr_client_order_line_id] ASC)
);

