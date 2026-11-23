CREATE TABLE [dbo].[tb_eco_emv_client_order] (
    [id]                  BIGINT         IDENTITY (1, 1) NOT NULL,
    [file_id]             INT            NOT NULL,
    [quotation_id]        INT            NULL,
    [client_order_number] NVARCHAR (100) NOT NULL,
    [status]              INT            NOT NULL,
    [created_time]        DATETIME       NOT NULL,
    [updated_time]        DATETIME       NOT NULL,
    CONSTRAINT [PK_tb_eco_emv_client_order] PRIMARY KEY CLUSTERED ([id] ASC)
);

