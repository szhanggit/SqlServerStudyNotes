CREATE TABLE [dbo].[TXCAcceptanceLoopMerchant] (
    [acceptance_loop_merchant_id] INT            IDENTITY (1, 1) NOT NULL,
    [acceptance_loop_id]          INT            NOT NULL,
    [merchant_id]                 INT            NOT NULL,
    [status]                      BIT            NOT NULL,
    [created_by]                  NVARCHAR (250) NOT NULL,
    [created_on]                  DATETIME       NOT NULL,
    [last_updated_by]             NVARCHAR (250) NULL,
    [last_updated_on]             DATETIME       NULL,
    CONSTRAINT [PK_TXCAcceptanceLoopMerchant] PRIMARY KEY CLUSTERED ([acceptance_loop_merchant_id] ASC) WITH (FILLFACTOR = 90)
);

