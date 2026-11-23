CREATE TABLE [dbo].[TPCVendor] (
    [Id]              BIGINT       IDENTITY (1, 1) NOT NULL,
    [VendorCode]      VARCHAR (50) NOT NULL,
    [IntervalMinutes] INT          DEFAULT ((0)) NOT NULL,
    [IsValid]         BIT          DEFAULT ((1)) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    UNIQUE NONCLUSTERED ([VendorCode] ASC)
);

