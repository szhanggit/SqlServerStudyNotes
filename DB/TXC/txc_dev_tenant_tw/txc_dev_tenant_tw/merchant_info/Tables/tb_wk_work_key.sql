CREATE TABLE [merchant_info].[tb_wk_work_key] (
    [id]         INT           IDENTITY (1, 1) NOT NULL,
    [value]      NVARCHAR (50) NOT NULL,
    [entity]     NVARCHAR (20) NULL,
    [created_on] DATETIME      NOT NULL,
    [expired_on] DATETIME      NULL,
    CONSTRAINT [PK_workkey] PRIMARY KEY CLUSTERED ([id] ASC)
);

