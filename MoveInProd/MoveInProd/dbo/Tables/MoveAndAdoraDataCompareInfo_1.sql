CREATE TABLE [dbo].[MoveAndAdoraDataCompareInfo] (
    [Id]             BIGINT         IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [MoveAmount]     BIGINT         NULL,
    [AdoraAmount]    BIGINT         NULL,
    [IsEqual]        BIT            NULL,
    [IsGenerateFile] BIT            NULL,
    [CompareDateInt] BIGINT         NULL,
    [CreatedOn]      DATETIME       NULL,
    [LastUpdate]     DATETIME       NULL,
    [Comments]       NVARCHAR (MAX) NULL,
    [IsDataCorrect]  BIT            NULL,
    CONSTRAINT [PK_MoveAndAdoraDataCompareInfo_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);

