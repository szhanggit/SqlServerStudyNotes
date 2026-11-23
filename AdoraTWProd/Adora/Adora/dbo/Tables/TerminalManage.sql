CREATE TABLE [dbo].[TerminalManage] (
    [MerchantCode]           VARCHAR (50)     NOT NULL,
    [ShopCode]               VARCHAR (50)     NULL,
    [TerminalCode]           VARCHAR (50)     NULL,
    [ProgramCode]            VARCHAR (50)     NOT NULL,
    [ManageType]             SMALLINT         NOT NULL,
    [ManageDate]             INT              NOT NULL,
    [ManageDateTime]         DATETIME         NOT NULL,
    [ManageLocalDate]        INT              NOT NULL,
    [ManageLocalDateTime]    DATETIME         NOT NULL,
    [ManageTerminalDateTime] DATETIME         NOT NULL,
    [RequestParameters]      NVARCHAR (MAX)   NULL,
    [NodeNum]                INT              NULL,
    [CallerIp]               VARCHAR (15)     NULL,
    [Channel]                VARCHAR (20)     NULL,
    [ReturnParameters]       NVARCHAR (MAX)   NULL,
    [ResponseCode]           VARCHAR (5)      NULL,
    [ManageGUID]             UNIQUEIDENTIFIER NULL,
    [Rsv1]                   NVARCHAR (255)   NULL,
    [Rsv2]                   NVARCHAR (255)   NULL,
    [Rsv3]                   NVARCHAR (255)   NULL
);

