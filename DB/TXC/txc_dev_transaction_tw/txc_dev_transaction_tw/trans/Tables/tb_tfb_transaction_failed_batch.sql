CREATE TABLE [trans].[tb_tfb_transaction_failed_batch] (
    [id]           INT IDENTITY (1, 1) NOT NULL,
    [order_id]     INT NOT NULL,
    [batch_number] INT NOT NULL,
    [batch_size]   INT NOT NULL,
    [status]       BIT NULL,
    CONSTRAINT [PK_tb_tfb_transaction_failed_batch] PRIMARY KEY CLUSTERED ([id] ASC)
);

