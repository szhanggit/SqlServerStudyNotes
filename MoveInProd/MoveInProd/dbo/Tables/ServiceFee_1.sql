CREATE TABLE [dbo].[ServiceFee] (
    [Id]                      INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ServiceFeeNameId]        INT             NOT NULL,
    [ServiceFeeDescriptionId] INT             NOT NULL,
    [Comment]                 NVARCHAR (1000) NULL,
    [Level]                   TINYINT         NOT NULL,
    [CalculationMode]         TINYINT         NULL,
    [CalculationRule]         VARCHAR (50)    NULL,
    [Status]                  TINYINT         NOT NULL,
    CONSTRAINT [PK_ServiceFee_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ServiceFee_Dictionary_ServiceFeeDescriptionId] FOREIGN KEY ([ServiceFeeDescriptionId]) REFERENCES [dbo].[Dictionary] ([Id]),
    CONSTRAINT [FK_ServiceFee_Dictionary_ServiceFeeNameId] FOREIGN KEY ([ServiceFeeNameId]) REFERENCES [dbo].[Dictionary] ([Id])
);

