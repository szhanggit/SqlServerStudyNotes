
CREATE PROCEDURE [dbo].[spCalcProductStat] @ErrorMessage NVARCHAR(4000) OUTPUT
	,@ErrorLine INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRAN

	BEGIN TRY
		--Update GeneratedQuantity for Edenred generated vouchers
		UPDATE ProductStat
		SET LastModifiedON = GETDATE()
			,GeneratedQuantity = t.GeneratedQuantity
		FROM (
			SELECT ps.ProductId
				,SUM(CASE 
						WHEN v.ProductId IS NULL
							THEN 0
						ELSE 1
						END) AS GeneratedQuantity
			FROM ProductStat ps
			LEFT JOIN Voucher v WITH(NOLOCK) ON v.VoucherNumber >= ps.MiniVoucherNumber
				AND v.VoucherNumber <= ps.MaxVoucherNumber
				AND LEN(v.VoucherNumber) = ps.VoucherNumberFullLength
			WHERE ps.VoucherNumberFullLength IS NOT NULL
			GROUP BY ps.ProductId
			) t
		WHERE ProductStat.ProductId = t.ProductId

		--Update GeneratedQuantity for 3rd party generated vouchers
		UPDATE ProductStat
		SET LastModifiedON = GETDATE()
			,GeneratedQuantity = t.GeneratedQuantity
		FROM (
			SELECT ps.ProductId
				,SUM(CASE 
						WHEN v.ProductId IS NULL
							THEN 0
						ELSE 1
						END) AS GeneratedQuantity
			FROM ProductStat ps
			LEFT JOIN Voucher v WITH(NOLOCK) ON ps.ProductId = v.ProductId
			WHERE ps.VoucherNumberFullLength IS NULL
			GROUP BY ps.ProductId
			) t
		WHERE ProductStat.ProductId = t.ProductId

		--Update InStockQuantity 
		UPDATE ProductStat
		SET LastModifiedON = GETDATE()
			,InStockQuantity = t.InStockQuantity
		FROM (
			SELECT ps.ProductId
				,count(v.ProductId) AS InStockQuantity
			FROM ProductStat ps
			LEFT JOIN voucher v WITH(NOLOCK) ON ps.ProductId = v.ProductId
				AND v.STATUS = 64
			GROUP BY ps.ProductId
			) t
		WHERE ProductStat.ProductId = t.ProductId
	END TRY

	BEGIN CATCH
		SELECT @ErrorMessage = ERROR_MESSAGE()

		SELECT @ErrorLine = ERROR_LINE()

		IF @@TRANCOUNT > 0
			ROLLBACK TRAN
	END CATCH

	IF @@TRANCOUNT > 0
		COMMIT TRAN
END
