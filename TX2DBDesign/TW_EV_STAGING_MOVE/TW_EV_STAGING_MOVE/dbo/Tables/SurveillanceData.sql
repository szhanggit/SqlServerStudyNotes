CREATE TABLE [dbo].[SurveillanceData] (
    [Id]         INT           IDENTITY (1, 1) NOT NULL,
    [Name]       NVARCHAR (50) NOT NULL,
    [DBArea]     NVARCHAR (50) NOT NULL,
    [Status]     INT           NOT NULL,
    [CreateTime] DATETIME      NOT NULL,
    [CloseTime]  DATETIME      NULL,
    [Operator]   NVARCHAR (50) NULL,
    CONSTRAINT [PK_SurveillanceData_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IDX_SurveillanceData_Status]
    ON [dbo].[SurveillanceData]([Status] ASC);

