CREATE TABLE [dbo].[EXT_GR_OrderBeneficiaryInfo] (
    [Id]          BIGINT         NOT NULL,
    [ProgramName] NVARCHAR (255) NULL,
    [GROrderID]   NVARCHAR (255) NULL,
    [CreatedOn]   DATETIME       NOT NULL,
    [AwardBy]     NVARCHAR (255) NULL,
    [SubProgram]  NVARCHAR (255) NULL,
    [Misc1]       NVARCHAR (255) NULL,
    [Misc2]       NVARCHAR (255) NULL,
    [Misc3]       NVARCHAR (255) NULL,
    CONSTRAINT [PK_EXT_GR_OrderBeneficiaryInfo_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);

