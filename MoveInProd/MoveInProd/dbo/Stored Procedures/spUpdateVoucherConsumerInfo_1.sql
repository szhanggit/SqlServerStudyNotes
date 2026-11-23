
CREATE PROCEDURE [dbo].[spUpdateVoucherConsumerInfo]
	@IsSuccess                BIT		OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON; 
	
    BEGIN TRANSACTION;
	
	SET @IsSuccess = 0;

	BEGIN TRY

		UPDATE Voucher
		SET ActivatedOn = ISNULL(VSB.ActivatedOn,V.ActivatedOn)
			,BalanceAvailable = VSB.BalanceAvailable
			,BalanceFrozen = VSB.BalanceFrozen
			,ExpiryDate = IIF(VSB.Status = 256 OR VSB.Status = 8, V.ExpiryDate,  VSB.ExpiryDate)
			,PublishedOn = VSB.PublishedOn
			,[Status] = VSB.[Status]
			,ConsumeTime = VSB.ConsumeTime
			,ConsumeMerchantCode = VSB.ConsumeMerchantCode
			,ConsumeShopCode = VSB.ConsumeShopCode
			,ConsumeTerminalSSN = VSB.ConsumeTerminalSSN
			,LastTranOn = VSB.LastTranOn
		FROM VoucherSyncBuffer AS VSB
			INNER JOIN Voucher AS V ON VSB.VoucherNumber = V.VoucherNumber
			INNER JOIN Program AS P ON VSB.ProgramCode = P.IdentityCode AND V.ProgramId = P.Id
				
	END TRY

	BEGIN CATCH

		IF @@TRANCOUNT > 0
				ROLLBACK TRANSACTION;
		RETURN
	END CATCH	

	IF @@TRANCOUNT > 0
		BEGIN
			COMMIT TRANSACTION;
			SET @IsSuccess = 1;
		END
END
