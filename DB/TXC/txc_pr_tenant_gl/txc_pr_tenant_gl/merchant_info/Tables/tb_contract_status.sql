CREATE TABLE [merchant_info].[tb_contract_status] (
    [id]    INT            IDENTITY (1, 1) NOT NULL,
    [value] NVARCHAR (128) NOT NULL,
    CONSTRAINT [pk_tb_contract_status] PRIMARY KEY CLUSTERED ([id] ASC)
);

