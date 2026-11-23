CREATE TABLE [dbo].[Clearing_History] (
    [Id]                   BIGINT         NOT NULL,
    [ProgramCode]          VARCHAR (20)   NOT NULL,
    [MerchantCode]         VARCHAR (50)   NOT NULL,
    [TerminalSSN]          VARCHAR (50)   NOT NULL,
    [TranUtcDate]          INT            NOT NULL,
    [TranUtcDateTimeL]     BIGINT         NOT NULL,
    [TranUtcDateTime]      DATETIME       NOT NULL,
    [TranLocalDate]        INT            NOT NULL,
    [TranLocalDateTime]    DATETIME       NOT NULL,
    [TranTerminalDateTime] DATETIME       NOT NULL,
    [ShopCode]             VARCHAR (50)   NULL,
    [TerminalCode]         VARCHAR (50)   NULL,
    [ShiftCode]            VARCHAR (50)   NULL,
    [BusinessDay]          INT            NULL,
    [ClearingType]         SMALLINT       NOT NULL,
    [ResponseCode]         VARCHAR (5)    NULL,
    [NodeNum]              INT            NULL,
    [CallerIP]             VARCHAR (50)   NULL,
    [Channel]              VARCHAR (20)   NULL,
    [Parameters]           NVARCHAR (MAX) NULL
) ON [DATA2] TEXTIMAGE_ON [DATA2];

