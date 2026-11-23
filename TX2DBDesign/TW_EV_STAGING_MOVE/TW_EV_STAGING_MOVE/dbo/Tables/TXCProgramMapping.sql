CREATE TABLE [dbo].[TXCProgramMapping] (
    [ProgramId]   INT NOT NULL,
    [TXCTenantId] INT NOT NULL,
    [ExternalId]  INT NULL,
    CONSTRAINT [PK_TXCProgramMapping] PRIMARY KEY CLUSTERED ([ProgramId] ASC)
);

