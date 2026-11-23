CREATE TABLE [dbo].[CTBCMapping] (
    [Id]           INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [UID]          NVARCHAR (50) NULL,
    [CTBCEditCode] NVARCHAR (50) NULL,
    [CTBCode]      NVARCHAR (50) NULL,
    [ProductCode]  VARCHAR (50)  NULL,
    [Type]         TINYINT       NULL,
    [CreationDate] DATETIME      DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_CTBCMapping_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90)
);

