CREATE TABLE [dbo].[TX_KGB_CheckInfo] (
    [Id]             INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Name]           NVARCHAR (200) NOT NULL,
    [DBKey]          NVARCHAR (200) NOT NULL,
    [StoreProcedure] NVARCHAR (200) NOT NULL,
    [IsActive]       BIT            NOT NULL
);

