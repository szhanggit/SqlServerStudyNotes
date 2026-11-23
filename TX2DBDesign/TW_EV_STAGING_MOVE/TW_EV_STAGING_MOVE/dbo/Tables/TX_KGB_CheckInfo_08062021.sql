CREATE TABLE [dbo].[TX_KGB_CheckInfo_08062021] (
    [Id]             INT            IDENTITY (1, 1) NOT NULL,
    [Name]           NVARCHAR (200) NOT NULL,
    [DBKey]          NVARCHAR (200) NOT NULL,
    [StoreProcedure] NVARCHAR (200) NOT NULL,
    [IsActive]       BIT            NOT NULL
);

