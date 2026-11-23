CREATE TABLE [dbo].[AccountHistory] (
    [AccountNumber]                  VARCHAR (50)     NOT NULL,
    [ProgramId]                      INT              NOT NULL,
    [ProductId]                      INT              NOT NULL,
    [ExternalOrderId]                VARCHAR (50)     NULL,
    [AccountNumberHashed]            VARCHAR (50)     NOT NULL,
    [BalanceAvailable]               INT              NOT NULL,
    [BalanceFrozen]                  INT              NOT NULL,
    [ValueType]                      INT              NOT NULL,
    [TopupMode]                      INT              NOT NULL,
    [Status]                         INT              NOT NULL,
    [Checksum]                       VARCHAR (50)     NOT NULL,
    [TranCount]                      INT              NOT NULL,
    [TranAmountAccumulated]          INT              NOT NULL,
    [AcceptanceLoopId]               INT              NOT NULL,
    [RestrictionId]                  INT              NULL,
    [ExpirationPolicyId]             INT              NULL,
    [Password]                       VARCHAR (16)     NULL,
    [ActiveFrom]                     DATETIME         NOT NULL,
    [ActiveTo]                       DATETIME         NOT NULL,
    [CreatedOn]                      DATETIME         NOT NULL,
    [LastTranOn]                     DATETIME         NULL,
    [LastTranDate]                   INT              NULL,
    [LastTranTime]                   BIGINT           NULL,
    [BlockedOn]                      DATETIME         NULL,
    [ActivatedOn]                    DATETIME         NULL,
    [ExpiredOn]                      DATETIME         NULL,
    [ModifyVersion]                  INT              DEFAULT ((0)) NOT NULL,
    [AccountNumberLength]            TINYINT          NOT NULL,
    [AccountGUID]                    UNIQUEIDENTIFIER NULL,
    [IsNotifyClient]                 BIT              DEFAULT ((0)) NOT NULL,
    [ClientNotificationProviderCode] VARCHAR (50)     NULL,
    [ConsumeTime]                    DATETIME         NULL,
    [ConsumeMerchantCode]            VARCHAR (50)     NULL,
    [ConsumeShopCode]                VARCHAR (50)     NULL,
    [ConsumeTerminalSSN]             VARCHAR (50)     NULL,
    [BalanceInitialized]             INT              NOT NULL,
    [PinCode]                        VARCHAR (100)    NULL,
    [MasterAccountNumber]            VARCHAR (50)     NULL,
    [MasterRedemptionTranCode]       VARCHAR (20)     NULL,
    [MasterProgramIdentityCode]      VARCHAR (50)     NULL,
    [SequenceNumber]                 BIGINT           NULL,
    CONSTRAINT [PK_AccountHistory_AccountNumber_ProgramId] PRIMARY KEY CLUSTERED ([AccountNumber] ASC, [ProgramId] ASC),
    CONSTRAINT [FK_AccountArchive_ALAcceptanceLoop_ALId] FOREIGN KEY ([AcceptanceLoopId]) REFERENCES [dbo].[AcceptanceLoop] ([Id]),
    CONSTRAINT [FK_AccountArchive_Product_ProductId] FOREIGN KEY ([ProductId]) REFERENCES [dbo].[Product] ([Id]),
    CONSTRAINT [FK_AccountArchive_Program_ProgramId] FOREIGN KEY ([ProgramId]) REFERENCES [dbo].[Program] ([Id]),
    CONSTRAINT [FK_AccountArchive_RVRestrictionVelocity_RVId] FOREIGN KEY ([RestrictionId]) REFERENCES [dbo].[Restriction] ([Id]),
    CONSTRAINT [FK_AccountHistory_ExpirationPolicy_ExpirationPolicyId] FOREIGN KEY ([ExpirationPolicyId]) REFERENCES [dbo].[ExpirationPolicy] ([Id])
);


GO
-- =============================================
-- Author:		Steven Yu
-- Create date: 2014/5/28
-- Description:	Save the status change into database.
-- =============================================
create TRIGGER [dbo].[trRecordStatusForHistory]
   ON  [dbo].[AccountHistory]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	INSERT INTO [dbo].[AccountStatusHistory]
           ([AccountNumber]
           ,[ProgramId]
           ,[Status]
           ,[StartTime])
     SELECT i.[AccountNumber]
			,i.[ProgramId]
			,i.[Status]
			,GETUTCDATE()
	FROM inserted i
	join deleted d on i.AccountNumber = d.AccountNumber and i.ProgramId = d.ProgramId and i.Status <> d.Status
END

GO
-- =============================================
-- Author:		Steven Yu
-- Create date: 2014/5/28
-- Description:	Save the status change into database.
-- =============================================
create TRIGGER [dbo].trRecordTranDateTimeForHistory
   ON  [dbo].[AccountHistory]
   AFTER INSERT,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE [dbo].[AccountHistory]
	SET [LastTranDate] = CAST(CONVERT(VARCHAR(8), i.[LastTranOn], 112) AS INT)
		,[LastTranTime] = replace(replace(REPLACE(CONVERT(varchar(19) , i.[LastTranOn], 20),':',''),' ',''),'-','')
	FROM [dbo].[AccountHistory] AH
	INNER JOIN inserted i ON AH.AccountNumber = i.AccountNumber AND AH.ProgramId = i.ProgramId AND i.[LastTranOn] IS NOT NULL
END


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '1--Product Based
   2--Face Value Based', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'AccountHistory', @level2type = N'COLUMN', @level2name = N'ValueType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '1--no topup
   2--can topup', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'AccountHistory', @level2type = N'COLUMN', @level2name = N'TopupMode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '        Created = 0,
           Active = 1,
           Expired = 2,
           Trashed = 3,
           Blocked = 4,
           Used = 5', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'AccountHistory', @level2type = N'COLUMN', @level2name = N'Status';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Default count/day', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'AccountHistory', @level2type = N'COLUMN', @level2name = N'TranCount';

