CREATE TABLE [order].[tb_gocd_gr_order_create_detail] (
    [id]                  BIGINT         IDENTITY (1, 1) NOT NULL,
    [client_order_id]     INT            NOT NULL,
    [gr_order_id]         NVARCHAR (250) NOT NULL,
    [client_order_number] NVARCHAR (100) NULL,
    [program_name]        NVARCHAR (250) NULL,
    [beneficiary_name]    NVARCHAR (200) NULL,
    [awared_by]           NVARCHAR (100) NULL,
    [email]               NVARCHAR (200) NULL,
    [product_code]        NVARCHAR (100) NULL,
    [quantity]            INT            NULL,
    [quotation_number]    NVARCHAR (100) NULL,
    [publish_time]        DATETIME       NULL,
    [expiry_date_type]    INT            NULL,
    [mobile]              NVARCHAR (50)  NULL,
    [expiry_date]         NVARCHAR (50)  NULL,
    [expiry_time]         NVARCHAR (50)  NULL,
    [memo]                NVARCHAR (500) NULL,
    [reservation_code]    NVARCHAR (100) NULL,
    [sub_program]         NVARCHAR (25)  NULL,
    [Misc_1]              NVARCHAR (25)  NULL,
    [misc_2]              NVARCHAR (25)  NULL,
    [misc_3]              NVARCHAR (25)  NULL,
    [redemption_id]       NVARCHAR (20)  NULL,
    [status]              INT            NOT NULL,
    [result]              NVARCHAR (500) NULL,
    [optimistic_lock]     NVARCHAR (64)  NULL,
    CONSTRAINT [unique_tb_gocd_gr_order_create_detail] UNIQUE NONCLUSTERED ([gr_order_id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IDX_order_tb_gocd_gr_client_order_gr_order_id]
    ON [order].[tb_gocd_gr_order_create_detail]([gr_order_id] ASC);

