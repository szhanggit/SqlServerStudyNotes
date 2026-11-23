CREATE TABLE [merchant_info].[tb_al_acceptance_loop] (
    [acceptance_loop_id] INT            IDENTITY (1, 1) NOT NULL,
    [code]               NVARCHAR (550) NULL,
    [description]        NVARCHAR (100) NULL,
    [status]             BIT            NOT NULL,
    [created_by]         NVARCHAR (250) NOT NULL,
    [created_on]         DATETIME       NOT NULL,
    [last_updated_by]    NVARCHAR (250) NULL,
    [last_updated_on]    DATETIME       NULL,
    [is_default]         BIT            CONSTRAINT [DF_tb_al_acceptance_loop_is_default] DEFAULT ((0)) NOT NULL,
    [merchant_group_id]  INT            NULL,
    [timestamp]          ROWVERSION     NOT NULL,
    CONSTRAINT [PK_AcceptanceLoops] PRIMARY KEY CLUSTERED ([acceptance_loop_id] ASC),
    CONSTRAINT [FK_tb_al_acceptance_loop_tb_mg_merchant_group] FOREIGN KEY ([merchant_group_id]) REFERENCES [merchant_info].[tb_mg_merchant_group] ([merchant_group_id])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UQ_AcceptanceLoops_Code]
    ON [merchant_info].[tb_al_acceptance_loop]([code] ASC);

