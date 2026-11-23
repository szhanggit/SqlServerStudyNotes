CREATE TABLE [voucher].[tb_v_voucher] (
    [id]                    BIGINT           IDENTITY (1, 1) NOT NULL,
    [voucher_number]        VARCHAR (50)     NOT NULL,
    [voucher_generator_id]  INT              NOT NULL,
    [guid]                  UNIQUEIDENTIFIER NOT NULL,
    [alias]                 VARCHAR (50)     NULL,
    [passcode]              VARCHAR (20)     NULL,
    [state_id]              TINYINT          NOT NULL,
    [batch_id]              INT              NOT NULL,
    [external_pin]          VARCHAR (100)    NULL,
    [balance]               BIGINT           NULL,
    [frozen_amount]         BIGINT           NOT NULL,
    [sequence_number]       BIGINT           NULL,
    [issued_on]             DATETIME         NULL,
    [activated_on]          DATETIME         NULL,
    [expiry_on]             DATETIME         NULL,
    [memo]                  NVARCHAR (1000)  NULL,
    [master_voucher_id]     BIGINT           NULL,
    [captured_count]        SMALLINT         NOT NULL,
    [voucher_extension]     NVARCHAR (MAX)   NULL,
    [association_status_id] TINYINT          NULL,
    [row_version]           ROWVERSION       NOT NULL,
    CONSTRAINT [PK_voucher_id] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_voucher_association_status] FOREIGN KEY ([association_status_id]) REFERENCES [voucher].[tb_as_association_status] ([id]),
    CONSTRAINT [FK_voucher_batch] FOREIGN KEY ([batch_id]) REFERENCES [voucher].[tb_ib_inventory_batch] ([id]),
    CONSTRAINT [FK_voucher_master_voucher] FOREIGN KEY ([master_voucher_id]) REFERENCES [voucher].[tb_v_voucher] ([id]),
    CONSTRAINT [FK_voucher_state] FOREIGN KEY ([state_id]) REFERENCES [voucher].[tb_vs_voucher_state] ([id]),
    CONSTRAINT [UK_voucher_guid] UNIQUE NONCLUSTERED ([guid] ASC),
    CONSTRAINT [UK_voucher_number_voucher_generator_id] UNIQUE NONCLUSTERED ([voucher_number] ASC, [voucher_generator_id] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_voucher_alias]
    ON [voucher].[tb_v_voucher]([alias] ASC) WHERE ([alias] IS NOT NULL);


GO
CREATE NONCLUSTERED INDEX [IX_voucher_voucher_number]
    ON [voucher].[tb_v_voucher]([voucher_number] ASC)
    INCLUDE([id], [state_id]);


GO
CREATE NONCLUSTERED INDEX [IX_voucher_sequence_number]
    ON [voucher].[tb_v_voucher]([sequence_number] ASC)
    INCLUDE([id], [voucher_number], [state_id]);


GO
CREATE NONCLUSTERED INDEX [IX_voucher_batch_id]
    ON [voucher].[tb_v_voucher]([batch_id] ASC)
    INCLUDE([id], [voucher_number], [state_id]);


GO
CREATE NONCLUSTERED INDEX [IX_voucher_master_voucher_id]
    ON [voucher].[tb_v_voucher]([master_voucher_id] ASC)
    INCLUDE([id], [voucher_number], [state_id]);

