CREATE TYPE [dbo].[tvp_sku_overlap_check] AS TABLE (
    [SkuNumber] NVARCHAR (128) NOT NULL,
    [StartDate] DATETIME       NULL,
    [EndDate]   DATETIME       NULL);

