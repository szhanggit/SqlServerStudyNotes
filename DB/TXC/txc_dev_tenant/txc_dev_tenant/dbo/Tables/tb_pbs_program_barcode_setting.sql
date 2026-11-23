CREATE TABLE [dbo].[tb_pbs_program_barcode_setting] (
    [id]                      INT          IDENTITY (1, 1) NOT NULL,
    [program_id]              INT          NOT NULL,
    [barcode_index]           INT          NOT NULL,
    [barcode_type]            VARCHAR (20) NOT NULL,
    [is_barcode_display_text] BIT          NULL,
    [is_barcode_api_enabled]  BIT          NULL,
    CONSTRAINT [PK_programbarcodesetting_id] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_programbarcodesetting_ref_program_id] FOREIGN KEY ([program_id]) REFERENCES [dbo].[tb_p_program] ([id])
);

