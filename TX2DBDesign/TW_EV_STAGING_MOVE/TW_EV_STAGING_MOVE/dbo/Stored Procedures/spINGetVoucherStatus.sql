
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE spINGetVoucherStatus 
	-- Add the parameters for the stored procedure here
	@OrderNumber VARCHAR(50),
	@VoucherNumbers VARCHAR(8000),
	@VoucherGUIDs VARCHAR(8000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @sql NVARCHAR(max);


	IF(@OrderNumber != '')
	BEGIN
    -- Insert statements for procedure here
		SELECT T1.VoucherNumber AS VoucherCode
			,T1.[GUID] AS VoucherGUID
			,T1.[Status] AS VoucherStatus
			,T1.TrashReason
			,T1.LastTranOn
			,T1.BalanceAvailable
			,T1.BalanceFrozen
			,T1.ExpiryDate  
		FROM Voucher AS T1 WITH(NOLOCK)
			JOIN [dbo].[OrderBeneficiaryInfo] AS T2 WITH(NOLOCK) ON T1.BeneficiaryInfoId = T2.Id
			JOIN [dbo].[OrderLine] AS T3 WITH(NOLOCK) ON T2.OrderLineId = T3.Id
			JOIN [dbo].[Order] AS T4  WITH(NOLOCK) ON T3.[OrderId] = T4.Id
		WHERE T4.OrderNumber = @OrderNumber
	END
	ELSE IF(@VoucherNumbers != '')
		BEGIN
			SET @sql = '
					SELECT VoucherNumber AS VoucherCode
					,[GUID] AS VoucherGUID
					,[Status] AS VoucherStatus
					,TrashReason
					,LastTranOn
					,BalanceAvailable
					,BalanceFrozen
					,ExpiryDate 
					FROM [dbo].[Voucher] WITH(NOLOCK)
					WHERE [VoucherNumber] IN (@VoucherNumbers)'
			SET @sql = REPLACE(@sql,'@VoucherNumbers',@VoucherNumbers);
			exec sp_executesql @sql
		END
	ELSE
		BEGIN
			SET @sql = '
					SELECT VoucherNumber AS VoucherCode
					,[GUID] AS VoucherGUID
					,[Status] AS VoucherStatus
					,TrashReason
					,LastTranOn
					,BalanceAvailable
					,BalanceFrozen
					,ExpiryDate 
					FROM [dbo].[Voucher] WITH(NOLOCK)
					WHERE [GUID] IN (@VoucherGUIDs)'
			SET @sql = REPLACE(@sql,'@VoucherGUIDs',@VoucherGUIDs);
			exec sp_executesql @sql
		END

END
