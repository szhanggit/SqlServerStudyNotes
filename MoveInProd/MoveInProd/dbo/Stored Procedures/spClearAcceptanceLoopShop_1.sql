
CREATE PROCEDURE [dbo].[spClearAcceptanceLoopShop]
	@MerchantId int, @ShopId int
AS
BEGIN
	DECLARE @AcceptanceLoopMerchantId TABLE (Id INT)

	BEGIN TRY
		BEGIN TRANSACTION


		-- Delete acceptance loop shop
		DELETE als2
		OUTPUT DELETED.AcceptanceLoopMerchantId INTO @AcceptanceLoopMerchantId
		from AcceptanceLoopShop als2 where als2.AcceptanceLoopMerchantId in (SELECT als.AcceptanceLoopMerchantId FROM dbo.AcceptanceLoopMerchant alm WITH(NOLOCK) 
		INNER JOIN dbo.AcceptanceLoopShop als WITH(NOLOCK) ON als.AcceptanceLoopMerchantId = alm.Id
		WHERE alm.MerchantId = @MerchantId AND als.ShopId = @ShopId);

		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		IF (@@TRANCOUNT > 0)
			ROLLBACK TRANSACTION;
		THROW
	END CATCH
END
