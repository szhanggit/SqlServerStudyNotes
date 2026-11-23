CREATE TABLE [dbo].[ProductLevelBatch] (
    [Id]                  BIGINT       IDENTITY (1, 1) NOT NULL,
    [BatchNo]             VARCHAR (20) NOT NULL,
    [Status]              TINYINT      CONSTRAINT [DF_ProductLevelBatch_Status] DEFAULT ((0)) NOT NULL,
    [ExecuteStartTime]    DATETIME     NULL,
    [ExecuteEndTime]      DATETIME     NULL,
    [TotalProductCount]   INT          NULL,
    [SuccessProductCount] INT          CONSTRAINT [DF_ProductLevelBatch_SuccessProductCount] DEFAULT ((0)) NULL,
    [FailProductCount]    INT          CONSTRAINT [DF_ProductLevelBatch_FailProductCount] DEFAULT ((0)) NULL,
    [CreatedOn]           DATETIME     CONSTRAINT [DF_ProductLevelBatch_CreatedOn] DEFAULT (getdate()) NULL,
    [CreatedBy]           VARCHAR (50) NULL,
    CONSTRAINT [PK_ProductLevelBatch] PRIMARY KEY CLUSTERED ([Id] ASC)
);

