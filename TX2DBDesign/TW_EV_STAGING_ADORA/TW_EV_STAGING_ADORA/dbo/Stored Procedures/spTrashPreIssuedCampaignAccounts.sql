
CREATE PROCEDURE [dbo].[spTrashPreIssuedCampaignAccounts]
	@SessionId varchar(50),
	@MachineKey varchar(50),
	@retCount INT OUTPUT
AS
    BEGIN
        SET NOCOUNT ON;

        BEGIN TRAN

        BEGIN TRY
			UPDATE a SET a.STATUS = 8,[Checksum] = SUBSTRING(sys.fn_varbintohexstr(HASHBYTES('MD5', CONVERT(VARCHAR(500), CONVERT(VARCHAR, a.ProgramId)
+ '=' + a.AccountNumber
+ '=' + CONVERT(VARCHAR(10), ValueType)
+ '=' + CONVERT(VARCHAR(20), BalanceAvailable)
+ '=' + CONVERT(VARCHAR(20), BalanceFrozen)
+ '=8' +
+ '=' + @MachineKey))), 3, 32) FROM account a INNER JOIN PreIssuedCampaignAccountsBuffer PICAB ON a.AccountNumber = PICAB.AccountNumber AND a.ProgramId = PICAB.ProgramId AND a.status =2 AND PICAB.SessionId = @SessionId

		SET @retCount = @@ROWCOUNT
			
		DELETE FROM PreIssuedCampaignAccountsBuffer WHERE SessionId = @SessionId
        END TRY
        BEGIN CATCH
            SET @retCount = 0
            IF @@TRANCOUNT > 0
                ROLLBACK TRANSACTION;
        END CATCH;

        IF @@TRANCOUNT > 0
            COMMIT TRANSACTION;
    END
