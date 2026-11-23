CREATE TABLE [quotation].[tb_qa_quotation_attachment] (
    [id]                INT            IDENTITY (1, 1) NOT NULL,
    [quotation_id]      INT            NOT NULL,
    [upload_file_type]  INT            NOT NULL,
    [file_name]         NVARCHAR (250) NOT NULL,
    [uploader]          NVARCHAR (250) NOT NULL,
    [uploaded_on]       DATETIME       NOT NULL,
    [account]           NVARCHAR (250) NULL,
    [file_content_type] NVARCHAR (250) NULL,
    [keyword]           NVARCHAR (250) NULL,
    CONSTRAINT [PK_tb_qa_quotation_attachment] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_tb_qa_quotation_attachment_tb_q_quotation] FOREIGN KEY ([quotation_id]) REFERENCES [quotation].[tb_q_quotation] ([id])
);

