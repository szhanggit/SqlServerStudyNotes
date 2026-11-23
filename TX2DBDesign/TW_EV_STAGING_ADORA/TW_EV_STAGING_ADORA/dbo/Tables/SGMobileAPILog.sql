CREATE TABLE [dbo].[SGMobileAPILog] (
    [RequestId]       VARCHAR (50)   NOT NULL,
    [RequestMessage]  NVARCHAR (MAX) NULL,
    [CreatedOn]       DATETIME       NOT NULL,
    [ResponseMessage] NVARCHAR (MAX) NULL,
    [ResponsedOn]     DATETIME       NULL,
    CONSTRAINT [PK_SGMobileAPILog] PRIMARY KEY CLUSTERED ([RequestId] ASC)
);

