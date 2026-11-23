-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE spUpdateCPPurchaseOrderAvailableQuantity
	-- Add the parameters for the stored procedure here
	@OrderNumber VARCHAR(50),
	@IsSuccess BIT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	BEGIN TRAN

	BEGIN TRY
	
		DECLARE @TotalNumber INT
		DECLARE @UpdateNumber INT

		SET @IsSuccess = 0
	
		SELECT @TotalNumber=COUNT(*)	
		FROM (
				SELECT t1.Id
				FROM [dbo].[EXT_TW_CPPurchaseOrder] AS T1 
					INNER JOIN [dbo].[EXT_TW_CPOrderLine] AS T2 ON T1.Id = T2.CPPurchaseOrderId
					INNER JOIN [dbo].[OrderLine] AS T3 ON T2.OrderLineId = T3.Id
					INNER JOIN [dbo].[Order] AS T4 ON T3.OrderId = T4.Id
				WHERE T4.OrderNumber = @OrderNumber
					AND T4.[Status] = 1
				GROUP BY T1.Id) AS TEMP

		UPDATE T1
		SET T1.[AvailableQuantity] = T1.[AvailableQuantity]-TEMP.[Quantity]
		FROM [dbo].[EXT_TW_CPPurchaseOrder] AS T1
		INNER JOIN (
			SELECT T1.Id,SUM(T3.TotalQuantity) AS [Quantity]	
			FROM [dbo].[EXT_TW_CPPurchaseOrder] AS T1 
				INNER JOIN [dbo].[EXT_TW_CPOrderLine] AS T2 ON T1.Id = T2.CPPurchaseOrderId
				INNER JOIN [dbo].[OrderLine] AS T3 ON T2.OrderLineId = T3.Id
				INNER JOIN [dbo].[Order] AS T4 ON T3.OrderId = T4.Id
			WHERE T1.AvailableQuantity >=  T3.TotalQuantity
				AND T4.OrderNumber = @OrderNumber
				AND T4.[Status] = 1
			GROUP BY T1.Id) AS TEMP ON T1.Id = TEMP.Id

		SET @UpdateNumber = @@ROWCOUNT

		IF(@TotalNumber <> @UpdateNumber AND @@TRANCOUNT > 0)
			ROLLBACK TRANSACTION;
		ELSE		
			SET @IsSuccess = 1

			UPDATE [dbo].[Order]
			SET [Status] = 2
			WHERE OrderNumber = @OrderNumber

	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
	END CATCH

	IF @@TRANCOUNT > 0
		COMMIT TRANSACTION;

END

