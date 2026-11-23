CREATE TABLE [dbo].[MoveVoucherLog] (
    [Id]                INT           IDENTITY (1, 1) NOT NULL,
    [SourceProductCode] VARCHAR (50)  NOT NULL,
    [TargetProductCode] VARCHAR (50)  NOT NULL,
    [Quantity]          INT           NOT NULL,
    [CreateTime]        DATETIME      NOT NULL,
    [Operator]          NVARCHAR (30) NOT NULL,
    CONSTRAINT [PK_MoveVoucherLog_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);

