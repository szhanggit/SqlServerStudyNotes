
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spAutoCalculateReimbursement] 
	-- Add the parameters for the stored procedure here
	@MerchantId INT,
	@StartDate INT,
	@EndDate INT,
	@TestBusinessModelId   INT,
	@IsSuccess BIT OUTPUT
AS
BEGIN

	SET NOCOUNT ON;
		
	BEGIN TRAN

	BEGIN TRY

		DECLARE	@ReimbursementId int
		DECLARE @ReimbursementTotalAmount INT
				
		SET @IsSuccess = 0
		--Get reimbursement total amount.
		SELECT @ReimbursementTotalAmount = SUM(RL.ReimbursementAmount)
		FROM ReimbursementLine AS RL
			JOIN ReimbursementScheme AS RS ON RL.ReimbursementSchemeId = RS.Id
			JOIN MerchantContract AS MC ON RS.MerchantContractId = MC.Id
			JOIN Merchant AS M ON MC.MerchantId = M.Id
		WHERE MC.MerchantId = @MerchantId
			AND RL.SettleDate BETWEEN  @StartDate AND @EndDate

		-- Insert reimbursement.
		INSERT INTO [dbo].[Reimbursement]
				   ([StartDate]
				   ,[EndDate]
				   ,[MerchantId]
				   ,[ReimbursementAmount]
				   ,[Status]
				   ,[CreatedOn]
				   ,[Title]
				   ,[CreationWay])
			 VALUES
				   (@StartDate
				   ,@EndDate
				   ,@MerchantId
				   ,ISNULL(@ReimbursementTotalAmount,0)
				   ,1
				   ,GETDATE()
				   ,''
				   ,1)
		
		-- Get reimbursement id.
		SET @ReimbursementId = SCOPE_IDENTITY()

		-- Update reimbursement line.
		UPDATE ReimbursementLine
		SET ReimbursementId = @ReimbursementId
		FROM ReimbursementLine AS RL
			JOIN ReimbursementScheme AS RS ON RL.ReimbursementSchemeId = RS.Id
			JOIN MerchantContract AS MC ON RS.MerchantContractId = MC.Id
			JOIN Merchant AS M ON MC.MerchantId = M.Id
		WHERE MC.MerchantId = @MerchantId
			AND RL.SettleDate BETWEEN  @StartDate AND @EndDate

		-- Insert reimbursement detail.
		-- Preprocess column [ClientQuotationProductId] for history data.
		INSERT INTO [dbo].[ReimbursementDetail]
			(ReimbursementId
			, ClientQuotationProductId
			, ReimbursementSchemeId
			, TransactionCount
			, CreatedOn)
		SELECT 
			ReimbursementId
			, ClientQuotationProductId
			, ReimbursementSchemeId
			, SUM(TransactionCount) AS TransactionCount
			, GETDATE()
		FROM [dbo].[ReimbursementLine] AS rl 
		INNER JOIN dbo.ClientQuotationProduct AS cqp WITH(NOLOCK) ON cqp.Id = rl.ClientQuotationProductId
		INNER JOIN dbo.ClientQuotation AS cq WITH(NOLOCK) ON cq.Id = cqp.ClientQuotationId
		WHERE [ReimbursementId] = @ReimbursementId AND cq.BusinessModelId != @TestBusinessModelId
		AND ClientQuotationProductId IS NOT NULL
		GROUP BY ReimbursementId,ClientQuotationProductId,ReimbursementSchemeId

		SET @IsSuccess = 1
	END TRY
	BEGIN CATCH
		SET @IsSuccess = 0

		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;

		SET @ErrorMessage = ERROR_MESSAGE()
        SET @ErrorSeverity = ERROR_SEVERITY()
        SET @ErrorState = ERROR_STATE()
		RAISERROR (@ErrorMessage,@ErrorSeverity,@ErrorState);

		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
	END CATCH;

	IF @@TRANCOUNT > 0
		COMMIT TRANSACTION;
END
