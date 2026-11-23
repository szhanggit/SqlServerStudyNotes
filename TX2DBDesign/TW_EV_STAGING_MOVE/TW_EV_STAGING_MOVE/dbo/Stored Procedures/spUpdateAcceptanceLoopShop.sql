
CREATE PROCEDURE [dbo].[spUpdateAcceptanceLoopShop]
	@AcceptanceLoopUpdateId VARCHAR(50)
AS
BEGIN
	DECLARE @AcceptanceLoopMerchantId TABLE (Id INT)

	BEGIN TRY
		BEGIN TRANSACTION

		-- Get all existing products accepted by the shop
		SELECT a.Id ProductId, b.Id AcceptanceLoopId, c.Id AcceptanceLoopMerchantId, c.MerchantId, d.Id AcceptanceLoopShopId, d.ShopId
		INTO #Current
		FROM Product a
		INNER JOIN AcceptanceLoop b
			ON a.AcceptanceLoopId = b.Id
		INNER JOIN AcceptanceLoopMerchant c
			ON b.Id = c.AcceptanceLoopId
		INNER JOIN AcceptanceLoopShop d
			ON c.Id = d.AcceptanceLoopMerchantId
		WHERE d.ShopId IN (SELECT DISTINCT ShopId FROM AcceptanceLoopBuffer WHERE AcceptanceLoopUpdateId = @AcceptanceLoopUpdateId)

		-- Delete acceptance loop shop
		DELETE a
		OUTPUT DELETED.AcceptanceLoopMerchantId INTO @AcceptanceLoopMerchantId
		FROM AcceptanceLoopShop a
		INNER JOIN #Current b
			ON a.Id = b.AcceptanceLoopShopId
		LEFT OUTER JOIN AcceptanceLoopBuffer c
			ON c.AcceptanceLoopUpdateId = @AcceptanceLoopUpdateId AND b.ProductId = c.ProductId AND b.ShopId = c.ShopId
		WHERE c.AcceptanceLoopUpdateId IS NULL

		-- Insert acceptance loop shop
		INSERT INTO AcceptanceLoopShop (AcceptanceLoopMerchantId, ShopId)
		OUTPUT INSERTED.AcceptanceLoopMerchantId INTO @AcceptanceLoopMerchantId
		SELECT d.Id, a.ShopId
		FROM AcceptanceLoopBuffer a
		INNER JOIN Product b
			ON a.ProductId = b.Id
		INNER JOIN AcceptanceLoop c
			ON b.AcceptanceLoopId = c.Id
		INNER JOIN AcceptanceLoopMerchant d
			ON c.Id = d.AcceptanceLoopId AND a.MerchantId = d.MerchantId
		LEFT OUTER JOIN #Current e
			ON a.ProductId = e.ProductId AND a.ShopId = e.ShopId
		WHERE e.ProductId IS NULL

		DROP TABLE #Current

		-- Clear buffer data
		DELETE AcceptanceLoopBuffer WHERE AcceptanceLoopUpdateId = @AcceptanceLoopUpdateId

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

