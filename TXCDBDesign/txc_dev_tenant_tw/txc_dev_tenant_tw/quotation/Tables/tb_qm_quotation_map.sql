CREATE TABLE [quotation].[tb_qm_quotation_map] (
    [id]                  INT IDENTITY (1, 1) NOT NULL,
    [master_quotation_id] INT NOT NULL,
    [child_quotation_id]  INT NOT NULL,
    CONSTRAINT [PK_tb_qm_quotation_map] PRIMARY KEY CLUSTERED ([id] ASC)
);

