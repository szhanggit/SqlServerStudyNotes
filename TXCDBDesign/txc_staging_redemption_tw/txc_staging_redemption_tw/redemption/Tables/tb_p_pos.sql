CREATE TABLE [redemption].[tb_p_pos] (
    [id]                     INT           IDENTITY (1, 1) NOT NULL,
    [program_id]             INT           NOT NULL,
    [merchant_id]            INT           NOT NULL,
    [shop_id]                INT           NULL,
    [terminal_identity_code] NVARCHAR (50) NULL,
    [row_version]            ROWVERSION    NOT NULL,
    CONSTRAINT [PK_tb_p_pos] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [UK_tb_p_pos_programId_merchantId_shopId_terminalIdentityCode] UNIQUE NONCLUSTERED ([program_id] ASC, [merchant_id] ASC, [shop_id] ASC, [terminal_identity_code] ASC)
);

