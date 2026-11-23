CREATE TABLE [merchant_info].[tb_pt_pin_type] (
    [id]          TINYINT        IDENTITY (1, 1) NOT NULL,
    [description] NVARCHAR (100) NOT NULL,
    CONSTRAINT [PK_tb_pt_pin_type] PRIMARY KEY CLUSTERED ([id] ASC)
);

