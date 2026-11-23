CREATE TABLE [dbo].[BatchTransaction] (
    [Id]                  BIGINT        IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [BatchNo]             VARCHAR (20)  NULL,
    [Status]              TINYINT       NOT NULL,
    [ExecuteStartTime]    DATETIME      NULL,
    [ExecuteEndTime]      DATETIME      NULL,
    [TotalVoucherCount]   INT           NOT NULL,
    [SuccessVoucherCount] INT           NULL,
    [FailVoucherCount]    INT           DEFAULT ((0)) NULL,
    [CreatedOn]           DATETIME      NOT NULL,
    [CreatedBy]           NVARCHAR (50) NOT NULL,
    [OrderNumber]         NVARCHAR (50) NULL,
    [RequestId]           NVARCHAR (50) NULL,
    [NeedToBeApproved]    INT           NULL,
    CONSTRAINT [PK_BatchTransaction_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);

