CREATE TABLE [voucher].[tb_as_association_status] (
    [id]          TINYINT       NOT NULL,
    [status]      VARCHAR (100) NOT NULL,
    [row_version] ROWVERSION    NOT NULL,
    CONSTRAINT [PK_association_status_id] PRIMARY KEY CLUSTERED ([id] ASC)
);

