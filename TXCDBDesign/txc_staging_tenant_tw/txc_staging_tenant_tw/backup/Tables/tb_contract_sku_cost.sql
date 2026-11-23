CREATE TABLE [backup].[tb_contract_sku_cost] (
    [id]               INT             IDENTITY (1, 1) NOT NULL,
    [contract_id]      INT             NOT NULL,
    [sku_id]           INT             NOT NULL,
    [cost]             DECIMAL (18, 2) NOT NULL,
    [valid_start_date] DATETIME        NOT NULL,
    [valid_end_date]   DATETIME        NOT NULL,
    [status_id]        INT             NOT NULL,
    [created_by]       NVARCHAR (50)   NOT NULL,
    [created_datetime] DATETIME        NOT NULL,
    [updated_by]       NVARCHAR (50)   NULL,
    [updated_datetime] DATETIME        NULL
);

