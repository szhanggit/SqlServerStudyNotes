
CREATE PROCEDURE [dbo].[spSyncAcceptanceLoop]
	@AcceptanceLoopUpdateId VARCHAR(50)
AS
BEGIN
	DECLARE @AcceptanceLoopId TABLE (Id INT)
	
	BEGIN TRY
		BEGIN TRANSACTION
		
		-- Update acceptance loop status if exists
		UPDATE AcceptanceLoop		
		SET [Status] = b.[Status]
		FROM AcceptanceLoop a		
		JOIN AcceptanceLoopBuffer b
		ON b.ProductExternalId = a.ExternalId

		-- Insert acceptance loop if not exists
		INSERT INTO AcceptanceLoop (ProgramId, ProductId, ExternalId, Status)
		OUTPUT INSERTED.Id INTO @AcceptanceLoopId
		SELECT b.Id ProgramId, c.Id ProductId, a.ProductExternalId, a.Status
		FROM AcceptanceLoopBuffer a
		INNER JOIN Program b
			ON a.ProgramIdentityCode = b.IdentityCode
		INNER JOIN Product c
			ON a.ProductExternalId = c.ExternalId
		LEFT OUTER JOIN AcceptanceLoop d
			ON a.ProductExternalId = d.ExternalId
		WHERE a.AcceptanceLoopUpdateId = @AcceptanceLoopUpdateId
			AND d.Id IS NULL

		-- Delete acceptance loop merchant category
		DELETE a
		OUTPUT DELETED.AcceptanceLoopId INTO @AcceptanceLoopId
		FROM AcceptanceLoopCategory a
		INNER JOIN AcceptanceLoop b
			ON a.AcceptanceLoopId = b.Id
		INNER JOIN Product c
			ON b.ProductId = c.Id
		INNER JOIN Program d
			ON b.ProgramId = d.Id
		INNER JOIN AcceptanceLoopBuffer e
			ON e.ProgramIdentityCode = d.IdentityCode AND e.ProductExternalId = c.ExternalId AND e.AcceptanceLoopUpdateId = @AcceptanceLoopUpdateId
		INNER JOIN MerchantCategory f
			ON a.CategoryId = f.Id
		LEFT OUTER JOIN AcceptanceLoopCategoryBuffer g
			ON g.ProgramIdentityCode = d.IdentityCode AND g.ProductExternalId = c.ExternalId AND g.MerchantCategoryExternalId = f.ExternalId AND g.AcceptanceLoopUpdateId = @AcceptanceLoopUpdateId
		WHERE g.AcceptanceLoopUpdateId IS NULL

		-- Insert acceptance loop merchant category
		INSERT INTO AcceptanceLoopCategory (AcceptanceLoopId, CategoryId)
		OUTPUT INSERTED.AcceptanceLoopId INTO @AcceptanceLoopId
		SELECT d.Id AcceptanceLoopId, e.Id CategoryId
		FROM AcceptanceLoopCategoryBuffer a
		INNER JOIN Program b
			ON a.ProgramIdentityCode = b.IdentityCode
		INNER JOIN Product c
			ON a.ProductExternalId = c.ExternalId
		INNER JOIN AcceptanceLoop d
			ON d.ProgramId = b.Id AND d.ProductId = c.Id
		INNER JOIN MerchantCategory e
			ON a.MerchantCategoryExternalId = e.ExternalId
		LEFT OUTER JOIN AcceptanceLoopCategory f
			ON f.AcceptanceLoopId = d.Id AND f.CategoryId = e.Id
		WHERE a.AcceptanceLoopUpdateId = @AcceptanceLoopUpdateId
			AND f.Id IS NULL

		-- Delete acceptance loop merchant
		DELETE a
		OUTPUT DELETED.AcceptanceLoopId INTO @AcceptanceLoopId
		FROM AcceptanceLoopMerchant a
		INNER JOIN AcceptanceLoop b
			ON a.AcceptanceLoopId = b.Id
		INNER JOIN Product c
			ON b.ProductId = c.Id
		INNER JOIN Program d
			ON b.ProgramId = d.Id
		INNER JOIN AcceptanceLoopBuffer e
			ON e.ProgramIdentityCode = d.IdentityCode AND e.ProductExternalId = c.ExternalId AND e.AcceptanceLoopUpdateId = @AcceptanceLoopUpdateId
		INNER JOIN Merchant f
			ON a.MerchantId = f.Id
		LEFT OUTER JOIN AcceptanceLoopMerchantBuffer g
			ON g.ProgramIdentityCode = d.IdentityCode AND g.ProductExternalId = c.ExternalId AND g.MerchantExternalId = f.ExternalId AND g.AcceptanceLoopUpdateId = @AcceptanceLoopUpdateId
		WHERE g.AcceptanceLoopUpdateId IS NULL

		-- Insert acceptance loop merchant
		INSERT INTO AcceptanceLoopMerchant (AcceptanceLoopId, MerchantId)
		OUTPUT INSERTED.AcceptanceLoopId INTO @AcceptanceLoopId
		SELECT d.Id AcceptanceLoopId, e.Id MerchantId
		FROM AcceptanceLoopMerchantBuffer a
		INNER JOIN Program b
			ON a.ProgramIdentityCode = b.IdentityCode
		INNER JOIN Product c
			ON a.ProductExternalId = c.ExternalId
		INNER JOIN AcceptanceLoop d
			ON d.ProgramId = b.Id AND d.ProductId = c.Id
		INNER JOIN Merchant e
			ON a.MerchantExternalId = e.ExternalId
		LEFT OUTER JOIN AcceptanceLoopMerchant f
			ON f.AcceptanceLoopId = d.Id AND f.MerchantId = e.Id
		WHERE a.AcceptanceLoopUpdateId = @AcceptanceLoopUpdateId
			AND f.Id IS NULL

		-- Delete acceptance loop shop
		DELETE a
		OUTPUT DELETED.AcceptanceLoopId INTO @AcceptanceLoopId
		FROM AcceptanceLoopShop a
		INNER JOIN AcceptanceLoop b
			ON a.AcceptanceLoopId = b.Id
		INNER JOIN Product c
			ON b.ProductId  =c.Id
		INNER JOIN Program d
			ON b.ProgramId = d.Id
		INNER JOIN AcceptanceLoopBuffer e
			ON e.ProgramIdentityCode = d.IdentityCode AND e.ProductExternalId = c.ExternalId AND e.AcceptanceLoopUpdateId = @AcceptanceLoopUpdateId
		INNER JOIN Shop f
			ON a.ShopId = f.Id
		LEFT OUTER JOIN AcceptanceLoopShopBuffer g
			ON g.ProgramIdentityCode = d.IdentityCode AND g.ProductExternalId = c.ExternalId AND g.ShopExternalId = f.ExternalId AND g.AcceptanceLoopUpdateId = @AcceptanceLoopUpdateId
		WHERE g.AcceptanceLoopUpdateId IS NULL

		-- Insert acceptance loop shop
		INSERT INTO AcceptanceLoopShop (AcceptanceLoopId, ShopId)
		OUTPUT INSERTED.AcceptanceLoopId INTO @AcceptanceLoopId
		SELECT DISTINCT d.Id AcceptanceLoopId, e.Id ShopId
		FROM AcceptanceLoopShopBuffer a
		INNER JOIN Program b
			ON a.ProgramIdentityCode = b.IdentityCode
		INNER JOIN Product c
			ON a.ProductExternalId = c.ExternalId
		INNER JOIN AcceptanceLoop d
			ON d.ProgramId = b.Id AND d.ProductId = c.Id
		INNER JOIN Shop e
			ON a.ShopExternalId = e.ExternalId
		LEFT OUTER JOIN AcceptanceLoopShop f
			ON f.AcceptanceLoopId = d.Id AND f.ShopId = e.Id
		WHERE a.AcceptanceLoopUpdateId = @AcceptanceLoopUpdateId
			AND f.Id IS NULL

		DELETE AcceptanceLoopBuffer WHERE AcceptanceLoopUpdateId = @AcceptanceLoopUpdateId
		DELETE AcceptanceLoopCategoryBuffer WHERE AcceptanceLoopUpdateId = @AcceptanceLoopUpdateId
		DELETE AcceptanceLoopMerchantBuffer WHERE AcceptanceLoopUpdateId = @AcceptanceLoopUpdateId
		DELETE AcceptanceLoopShopBuffer WHERE AcceptanceLoopUpdateId = @AcceptanceLoopUpdateId

		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		IF (@@TRANCOUNT > 0)
			ROLLBACK TRANSACTION;
		THROW
	END CATCH

	SELECT DISTINCT Id FROM @AcceptanceLoopId
END
