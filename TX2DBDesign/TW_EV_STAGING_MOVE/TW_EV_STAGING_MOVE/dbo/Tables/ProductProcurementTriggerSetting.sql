CREATE TABLE [dbo].[ProductProcurementTriggerSetting] (
    [Id]                     INT           NOT NULL,
    [ProcurementQty]         INT           NULL,
    [NeedProcurementTrigger] BIT           NOT NULL,
    [CreatedBy]              NVARCHAR (50) NOT NULL,
    [CreatedOn]              DATETIME      NOT NULL,
    [ModifiedBy]             NVARCHAR (50) NULL,
    [ModifiedOn]             DATETIME      NULL,
    CONSTRAINT [PK_ProductProcurementTriggerSetting] PRIMARY KEY CLUSTERED ([Id] ASC)
);

