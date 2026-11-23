CREATE TABLE [order].[tb_gocd_gr_client_order] (
    [id]                  BIGINT         IDENTITY (1, 1) NOT NULL,
    [file_id]             INT            NOT NULL,
    [quotation_id]        NVARCHAR (100) NULL,
    [client_order_number] NVARCHAR (100) NOT NULL,
    [status]              INT            NOT NULL,
    [created_time]        DATETIME       NOT NULL,
    [updated_time]        DATETIME       NOT NULL,
    CONSTRAINT [PK_tb_gocd_gr_client_order] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IDX_order_tb_gocd_gr_client_order_file_id]
    ON [order].[tb_gocd_gr_client_order]([file_id] ASC);

