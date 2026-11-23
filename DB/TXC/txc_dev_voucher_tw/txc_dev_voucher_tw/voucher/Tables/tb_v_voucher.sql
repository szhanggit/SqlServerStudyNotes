CREATE TABLE [voucher].[tb_v_voucher] (
    [id]                                 BIGINT          NOT NULL,
    [voucher_number]                     VARCHAR (50)    NOT NULL,
    [voucher_generator_id]               INT             NOT NULL,
    [partition_number]                   INT             NOT NULL,
    [state_id]                           TINYINT         NOT NULL,
    [batch_id]                           INT             NOT NULL,
    [passcode]                           VARCHAR (20)    NULL,
    [pincode]                            VARCHAR (100)   NULL,
    [face_value_with_tax]                DECIMAL (18, 2) NULL,
    [balance]                            BIGINT          NULL,
    [frozen_amount]                      BIGINT          NOT NULL,
    [sequence_number]                    BIGINT          NULL,
    [issued_on]                          DATETIME        NULL,
    [activated_on]                       DATETIME        NULL,
    [expiry_on]                          DATETIME        NULL,
    [master_voucher_id]                  BIGINT          NULL,
    [master_voucher_id_partition_number] INT             NULL,
    [memo]                               NVARCHAR (1000) NULL,
    [captured_count]                     SMALLINT        NOT NULL,
    [voucher_extension]                  NVARCHAR (MAX)  NULL,
    [association_status_id]              TINYINT         NULL,
    PRIMARY KEY NONCLUSTERED ([id] ASC) ON [PRIMARY],
    CONSTRAINT [FK_voucher_association_status] FOREIGN KEY ([association_status_id]) REFERENCES [voucher].[tb_as_association_status] ([id]),
    CONSTRAINT [FK_voucher_batch] FOREIGN KEY ([batch_id]) REFERENCES [voucher].[tb_ib_inventory_batch] ([id]),
    CONSTRAINT [FK_voucher_state] FOREIGN KEY ([state_id]) REFERENCES [voucher].[tb_vs_voucher_state] ([id]),
    CONSTRAINT [UK_voucher_number_voucher_generator_id] UNIQUE NONCLUSTERED ([voucher_number] ASC, [voucher_generator_id] ASC, [partition_number] ASC) ON [RangeParitionScheme10K] ([partition_number])
) ON [RangeParitionScheme10K] ([partition_number]);


GO
CREATE NONCLUSTERED INDEX [IX_voucher_batch_id]
    ON [voucher].[tb_v_voucher]([batch_id] ASC)
    INCLUDE([id], [voucher_number], [state_id])
    ON [RangeParitionScheme10K] ([partition_number]);


GO
CREATE NONCLUSTERED INDEX [IX_voucher_sequence_number]
    ON [voucher].[tb_v_voucher]([sequence_number] ASC)
    INCLUDE([id], [voucher_number], [state_id])
    ON [RangeParitionScheme10K] ([partition_number]);


GO
CREATE NONCLUSTERED INDEX [IX_voucher_master_voucher_id]
    ON [voucher].[tb_v_voucher]([master_voucher_id] ASC, [master_voucher_id_partition_number] ASC)
    ON [RangeParitionScheme100] ([master_voucher_id_partition_number]);

