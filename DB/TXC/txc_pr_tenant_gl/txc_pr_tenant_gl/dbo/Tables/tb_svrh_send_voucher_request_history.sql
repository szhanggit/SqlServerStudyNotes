CREATE TABLE [dbo].[tb_svrh_send_voucher_request_history] (
    [request_Id]               NVARCHAR (64) NOT NULL,
    [emv_client_order_line_id] INT           NOT NULL,
    CONSTRAINT [PK_tb_svrh_send_voucher_request_history] PRIMARY KEY CLUSTERED ([request_Id] ASC, [emv_client_order_line_id] ASC)
);

