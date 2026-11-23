CREATE TABLE [dbo].[APIRequestVoucherMapping] (
    [Id]            BIGINT       IDENTITY (1, 1) NOT NULL,
    [RequestId]     VARCHAR (50) NULL,
    [ProgramId]     INT          NOT NULL,
    [VoucherNumber] VARCHAR (50) NOT NULL,
    [CreatedDate]   DATETIME     NOT NULL,
    CONSTRAINT [PK_APIRequestVoucherMapping_Id] PRIMARY KEY CLUSTERED ([Id] DESC)
);


GO
CREATE NONCLUSTERED INDEX [Index_APIRequestVoucherMapping_RequestId]
    ON [dbo].[APIRequestVoucherMapping]([RequestId] ASC);


GO
CREATE NONCLUSTERED INDEX [Index_APIRequestVoucherMapping_VoucherNumberProgramId]
    ON [dbo].[APIRequestVoucherMapping]([VoucherNumber] ASC, [ProgramId] ASC);

