CREATE TABLE [trans].[tb_tc_transaction_channel] (
    [channel_id]   SMALLINT        IDENTITY (1, 1) NOT NULL,
    [channel_name] NVARCHAR (20)   NULL,
    [description]  NVARCHAR (1000) NULL
);

