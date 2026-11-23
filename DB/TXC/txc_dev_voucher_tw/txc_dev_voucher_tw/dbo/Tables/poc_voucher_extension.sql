CREATE TABLE [dbo].[poc_voucher_extension] (
    [voucher_id]           INT            NOT NULL,
    [voucher_generator_id] INT            NOT NULL,
    [extension]            NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_voucher_extension] PRIMARY KEY CLUSTERED ([voucher_id] ASC)
);

