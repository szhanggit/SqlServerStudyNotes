CREATE TABLE [dbo].[TX_KGB_Result_08062021] (
    [Id]             INT             IDENTITY (1, 1) NOT NULL,
    [Name]           NVARCHAR (200)  NOT NULL,
    [Result]         BIGINT          NULL,
    [Mark]           BIGINT          NOT NULL,
    [MarkOperation]  SMALLINT        NOT NULL,
    [IsActive]       BIT             NOT NULL,
    [LastUpdateTime] DATETIME        NULL,
    [NotifyChannel]  INT             NULL,
    [Level]          INT             NULL,
    [AlertMessage]   NVARCHAR (2000) NULL
);

