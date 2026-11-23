CREATE TABLE [trans].[tb_t_transaction] (
    [transaction_id]       BIGINT         IDENTITY (1, 1) NOT NULL,
    [entity_id]            BIGINT         NOT NULL,
    [reference_id]         BIGINT         NOT NULL,
    [trans_ref_type_id]    SMALLINT       NOT NULL,
    [transaction_datetime] DATETIME       NOT NULL,
    [transaction_amount]   BIGINT         NOT NULL,
    [created_on]           DATETIME       NOT NULL,
    [is_offline]           BIT            NULL,
    [generated_by]         NVARCHAR (250) NULL,
    [channel_id]           SMALLINT       NULL,
    [row_version]          ROWVERSION     NOT NULL,
    CONSTRAINT [PK_tb_t_transaction] PRIMARY KEY CLUSTERED ([transaction_id] ASC),
    CONSTRAINT [UQ_tb_transaction_entityId_referenceId_transRefTypeId] UNIQUE NONCLUSTERED ([entity_id] ASC, [reference_id] ASC, [trans_ref_type_id] ASC)
);

