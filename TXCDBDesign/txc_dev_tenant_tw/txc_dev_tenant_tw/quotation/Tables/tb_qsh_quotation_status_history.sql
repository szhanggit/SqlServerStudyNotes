CREATE TABLE [quotation].[tb_qsh_quotation_status_history] (
    [id]             INT            IDENTITY (1, 1) NOT NULL,
    [quotation_id]   INT            NOT NULL,
    [operation]      INT            NOT NULL,
    [comment]        NVARCHAR (500) NULL,
    [operator]       NVARCHAR (50)  NOT NULL,
    [operation_time] DATETIME       NOT NULL,
    CONSTRAINT [PK_tb_qsh_quotation_status_history] PRIMARY KEY CLUSTERED ([id] ASC)
);

