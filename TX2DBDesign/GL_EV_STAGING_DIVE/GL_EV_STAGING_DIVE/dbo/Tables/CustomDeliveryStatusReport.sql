CREATE TABLE [dbo].[CustomDeliveryStatusReport] (
    [Id]             BIGINT         IDENTITY (1, 1) NOT NULL,
    [MessageId]      BIGINT         NOT NULL,
    [MessageSPId]    NVARCHAR (100) NOT NULL,
    [DLRType]        INT            NOT NULL,
    [Country]        NVARCHAR (50)  NOT NULL,
    [AssemblyName]   VARCHAR (100)  NOT NULL,
    [FullTypeName]   VARCHAR (100)  NOT NULL,
    [MethodName]     VARCHAR (100)  NOT NULL,
    [JSONParameters] NVARCHAR (MAX) NULL,
    [Status]         INT            NOT NULL,
    [CreatedOn]      DATETIME       NOT NULL,
    [UpdatedOn]      DATETIME       NULL,
    CONSTRAINT [PK_CustomDeliveryStatusReport_Id] PRIMARY KEY CLUSTERED ([Id] DESC)
);


GO
CREATE NONCLUSTERED INDEX [Index_Self_Status]
    ON [dbo].[CustomDeliveryStatusReport]([Status] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_CustomDeliveryStatusReport_CreatedOn]
    ON [dbo].[CustomDeliveryStatusReport]([CreatedOn] DESC);

