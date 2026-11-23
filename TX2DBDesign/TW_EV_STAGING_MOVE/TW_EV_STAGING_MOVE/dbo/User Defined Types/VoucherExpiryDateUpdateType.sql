CREATE TYPE [dbo].[VoucherExpiryDateUpdateType] AS TABLE (
    [VoucherNumber] VARCHAR (50) NOT NULL,
    [ProgramId]     INT          NOT NULL,
    [ExpiryDate]    DATETIME     NOT NULL);

