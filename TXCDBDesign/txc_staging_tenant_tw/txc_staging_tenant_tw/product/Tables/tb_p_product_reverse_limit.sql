CREATE TABLE [product].[tb_p_product_reverse_limit] (
    [reverse_limit_id] INT            IDENTITY (1, 1) NOT NULL,
    [name]             NVARCHAR (50)  NOT NULL,
    [description]      NVARCHAR (500) NULL,
    [type]             TINYINT        NOT NULL,
    [valid_period]     INT            NOT NULL,
    [is_end_of_day]    BIT            NOT NULL,
    [created_by]       NVARCHAR (250) NOT NULL,
    [created_on]       DATETIME       NOT NULL,
    [last_updated_by]  NVARCHAR (250) NULL,
    [last_updated_on]  DATETIME       NULL,
    [timestamp]        ROWVERSION     NOT NULL,
    CONSTRAINT [PK_tb_p_product_reverse_limit] PRIMARY KEY CLUSTERED ([reverse_limit_id] ASC),
    CONSTRAINT [UK_tb_p_product_reverse_limit] UNIQUE NONCLUSTERED ([name] ASC)
);

