CREATE TABLE [dbo].[TX_KGB_Result] (
    [Id]             INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Name]           NVARCHAR (200) NOT NULL,
    [Result]         BIGINT         NULL,
    [Mark]           BIGINT         NOT NULL,
    [MarkOperation]  SMALLINT       NOT NULL,
    [IsActive]       BIT            NOT NULL,
    [LastUpdateTime] DATETIME       NULL,
    [NotifyChannel]  INT            NULL,
    [Level]          INT            NULL
);

