CREATE TABLE [general].[tb_ep_expiration_policy] (
    [expiration_policy_id]      INT            IDENTITY (1, 1) NOT NULL,
    [name]                      NVARCHAR (100) NOT NULL,
    [print_description]         NVARCHAR (500) NULL,
    [type]                      TINYINT        NOT NULL,
    [valid_period]              INT            NULL,
    [is_end_of_day]             BIT            NOT NULL,
    [product_voucher_generator] INT            NOT NULL,
    [created_by]                NVARCHAR (250) NOT NULL,
    [created_on]                DATETIME       NOT NULL,
    [last_updated_by]           NVARCHAR (250) NULL,
    [last_updated_on]           DATETIME       NULL,
    [timestamp]                 ROWVERSION     NOT NULL,
    [display_name]              NVARCHAR (500) NULL,
    CONSTRAINT [PK_tb_ep_expiration_policy] PRIMARY KEY CLUSTERED ([expiration_policy_id] ASC),
    CONSTRAINT [UK_tb_ep_expiration_policy] UNIQUE NONCLUSTERED ([name] ASC)
);

