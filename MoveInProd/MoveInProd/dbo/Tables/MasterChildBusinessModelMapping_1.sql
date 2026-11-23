CREATE TABLE [dbo].[MasterChildBusinessModelMapping] (
    [Id]                    INT IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [MasterBusinessModelId] INT NOT NULL,
    [ChildBusinessModelId]  INT NOT NULL,
    [IsPrepaid]             BIT NOT NULL,
    CONSTRAINT [PK_MasterChildBusinessModelMapping_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_MasterChildBusinessModelMapping_BusinessModel_ChildBusinessModelId] FOREIGN KEY ([ChildBusinessModelId]) REFERENCES [dbo].[BusinessModel] ([Id]),
    CONSTRAINT [FK_MasterChildBusinessModelMapping_BusinessModel_MasterBusinessModelId] FOREIGN KEY ([MasterBusinessModelId]) REFERENCES [dbo].[BusinessModel] ([Id])
);

