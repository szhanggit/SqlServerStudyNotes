
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
		from AcceptanceLoopShop als2 where als2.Id in (SELECT als.Id FROM dbo.AcceptanceLoopMerchant alm WITH(NOLOCK) 
		INNER JOIN dbo.AcceptanceLoopShop als WITH(NOLOCK) ON als.AcceptanceLoopMerchantId = alm.Id
		WHERE alm.MerchantId = @MerchantId AND als.ShopId = @ShopId);

		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		IF (@@TRANCOUNT > 0)
			ROLLBACK TRANSACTION;
		THROW
	END CATCH

    -- Return product id
	SELECT DISTINCT d.Id
	FROM @AcceptanceLoopMerchantId a
	INNER JOIN AcceptanceLoopMerchant b
		ON a.Id = b.Id
	INNER JOIN AcceptanceLoop c
		ON b.AcceptanceLoopId = c.Id
	INNER JOIN Product d
		ON c.Id = d.AcceptanceLoopId
END
