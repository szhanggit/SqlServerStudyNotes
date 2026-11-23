-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE spArchiveMultiAccountsTransaction
	-- Add the parameters for the stored procedure here	
	@ErrorMessage			nvarchar(4000)	OUTPUT
	,@ErrorLine				int				OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @maxid AS BIGINT
	DECLARE @steplen AS BIGINT
	DECLARE @minid AS BIGINT
	DECLARE @endid AS BIGINT
	--DECLARE @currentstep AS INT
	--DECLARE @maxsteps AS INT
	DECLARE @maxBusinessDay AS INT
	
	DECLARE @starbucksMerchantCode AS VARCHAR(50)
	SET @starbucksMerchantCode = CASE DB_NAME() WHEN 'TW_EV_DBS_ADORA' THEN '000000000000147' WHEN 'TW_EV_UAT_ADORA' THEN '000000000000134' ELSE '' END

	SELECT @maxid = MIN(MultiAccountsTransactionId) FROM [Transaction] WITH(NOLOCK)
	SET @steplen = 3000
	SET @endid = 1
	--SET @currentstep = 0
	--SET @maxsteps=100
	SET @maxBusinessDay = CONVERT(VARCHAR, GETDATE() - 9, 112)

	SELECT @minid = MIN(id) FROM dbo.MultiAccountsTransaction WITH(NOLOCK)
	--SELECT @endid = MAX(id) FROM dbo.MultiAccountsTransaction WITH(NOLOCK) WHERE id <= @minid + @steplen
	SET @endid = @minid + @steplen - 1
	IF @endid >= @maxid SET @endid = @maxid - 1

	WHILE(@minid < @maxid)
	BEGIN
	    BEGIN TRY
			BEGIN TRANSACTION;

			INSERT INTO MultiAccountsTransactionDetail_History
			SELECT t1.*
			FROM MultiAccountsTransactionDetail t1 JOIN MultiAccountsTransaction t2 ON t2.Id = t1.MultiAccountsTransactionId
			WHERE t2.id >= @minid AND t2.id <= @endid
				AND ((t2.MerchantCode = @starbucksMerchantCode AND t2.BusinessDay <= @maxBusinessDay) OR (t2.MerchantCode <> @starbucksMerchantCode))

			DELETE t1 
			FROM MultiAccountsTransactionDetail t1 JOIN MultiAccountsTransaction t2 ON t2.Id = t1.MultiAccountsTransactionId
			WHERE t2.id >= @minid AND t2.id <= @endid
				AND ((t2.MerchantCode = @starbucksMerchantCode AND t2.BusinessDay <= @maxBusinessDay) OR (t2.MerchantCode <> @starbucksMerchantCode))

			INSERT INTO FailureReversalDetail_History
			SELECT t1.*
			FROM FailureReversalDetail t1 JOIN MultiAccountsTransaction t2 ON t2.Id = t1.MultiAccountsTransactionId
			WHERE t2.id >= @minid AND t2.id <= @endid
				AND ((t2.MerchantCode = @starbucksMerchantCode AND t2.BusinessDay <= @maxBusinessDay) OR (t2.MerchantCode <> @starbucksMerchantCode))

			DELETE t1 
			FROM FailureReversalDetail t1 JOIN MultiAccountsTransaction t2 ON t2.Id = t1.MultiAccountsTransactionId
			WHERE t2.id >= @minid AND t2.id <= @endid
				AND ((t2.MerchantCode = @starbucksMerchantCode AND t2.BusinessDay <= @maxBusinessDay) OR (t2.MerchantCode <> @starbucksMerchantCode))


			INSERT INTO MultiAccountsTransaction_History
			SELECT t1.*
			FROM MultiAccountsTransaction t1 
			WHERE t1.id >= @minid AND t1.id <= @endid
				AND ((t1.MerchantCode = @starbucksMerchantCode AND t1.BusinessDay <= @maxBusinessDay) OR (t1.MerchantCode <> @starbucksMerchantCode))

			DELETE t1
			FROM MultiAccountsTransaction t1
			WHERE t1.id >= @minid AND t1.id <= @endid
				AND ((t1.MerchantCode = @starbucksMerchantCode AND t1.BusinessDay <= @maxBusinessDay) OR (t1.MerchantCode <> @starbucksMerchantCode))

			--SET @currentstep = @currentstep + 1

			WAITFOR DELAY '0:0:1' 

			--SELECT @minid = MIN(id) FROM dbo.MultiAccountsTransaction
			--SELECT @endid = MAX(id) FROM dbo.MultiAccountsTransaction WHERE id <= @minid + @steplen
			
			SET @minid = @endid + 1
			SET @endid = @minid + @steplen - 1
			IF @endid >= @maxid SET @endid = @maxid - 1
			
			COMMIT TRANSACTION;
		END TRY
		BEGIN CATCH
		
			SELECT @ErrorMessage = ERROR_MESSAGE()
			SELECT @ErrorLine = ERROR_LINE() 

			IF @@TRANCOUNT > 0
				BEGIN
					ROLLBACK;
				END;
            
		END CATCH;
	END
END
