CREATE TABLE [product].[tb_p_product_voucher_number_rule] (
    [product_voucher_number_rule_id] INT          IDENTITY (1, 1) NOT NULL,
    [prefix]                         VARCHAR (15) NULL,
    [type]                           TINYINT      NOT NULL,
    [length]                         TINYINT      NOT NULL,
    [example]                        VARCHAR (50) NOT NULL,
    [voucher_number_algorithm_id]    INT          NOT NULL,
    [voucher_generator]              TINYINT      NOT NULL,
    CONSTRAINT [PK_tb_p_product_voucher_number_rule_id] PRIMARY KEY CLUSTERED ([product_voucher_number_rule_id] ASC)
);

