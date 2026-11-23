-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spGetBarcodeInfoForDownload] 
	-- Add the parameters for the stored procedure here
	@OrderNumber  VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 
    -- Insert statements for procedure here
	BEGIN TRY 
		
	DECLARE @SqlString VARCHAR(8000)
	DECLARE @ProgramName NVARCHAR(50)
	DECLARE @ProgramCode NVARCHAR(50)

	SET @SqlString = ''

    DECLARE CusGetBarcodeByProgam CURSOR FOR
							SELECT DISTINCT T1.Name AS ProgramName,T1.IdentityCode AS ProgramCode FROM [dbo].[Program] AS T1
								INNER JOIN [dbo].[Product] AS T2 ON T1.Id = T2.ProgramId
								INNER JOIN [dbo].[ProductVersion] AS T3 ON T2.Id = T3.ProductId
								INNER JOIN [dbo].[OrderBeneficiaryInfo] AS T4 ON T3.Id = T4.ProductVersionId
								INNER JOIN [dbo].[OrderLine] AS T5 ON T4.OrderLineId = T5.Id
								INNER JOIN [dbo].[Order] AS T6 ON T5.OrderId = T6.Id
							WHERE T6.OrderNumber = @OrderNumber
    OPEN CusGetBarcodeByProgam 
    FETCH NEXT FROM CusGetBarcodeByProgam INTO @ProgramName,@ProgramCode
    WHILE (@@FETCH_STATUS = 0)
         BEGIN
				--HiLife
				IF(@ProgramName = 'TX2.0')
				BEGIN
					/*
					 * VoucherGenerator:Edenred = 1,HiLife = 2
					 *
					 */
					IF EXISTS ( SELECT 1 FROM [dbo].[Program] AS T1
									INNER JOIN [dbo].[Product] AS T2 ON T1.Id = T2.ProgramId
									INNER JOIN [dbo].[ProductVersion] AS T3 ON T2.Id = T3.ProductId
									INNER JOIN [dbo].[OrderBeneficiaryInfo] AS T4 ON T3.Id = T4.ProductVersionId
									INNER JOIN [dbo].[OrderLine] AS T5 ON T4.OrderLineId = T5.Id
									INNER JOIN [dbo].[Order] AS T6 ON T5.OrderId = T6.Id
									INNER JOIN [dbo].[VoucherNumberRule] AS T7 ON T2.VoucherNumberRuleId = T7.Id
								WHERE T7.[VoucherGenerator] = 2
								AND T6.OrderNumber = @OrderNumber)
						BEGIN 
							SET  @SqlString = 
							'SELECT
								T4.[GUID] AS VoucherGuid
								,ISNULL(T7.Barcode1,'''') AS Barcode1
								,ISNULL(T5.Barcode1Type,'''') AS Barcode1Type
								,ISNULL(T5.IsBarcode1DisplayText, 0) AS IsBarcode1DisplayText
								,ISNULL(T7.Barcode2,'''') AS Barcode2
								,ISNULL(T5.Barcode2Type,'''') AS Barcode2Type
								,ISNULL(T5.IsBarcode2DisplayText, 0) AS IsBarcode2DisplayText
								,ISNULL(T7.Barcode3,'''') AS Barcode3
								,ISNULL(T5.Barcode3Type,'''') AS Barcode3Type
								,ISNULL(T5.IsBarcode3DisplayText, 0) AS IsBarcode3DisplayText
								,ISNULL(T7.Barcode4,'''') AS Barcode4
								,ISNULL(T5.Barcode4Type,'''') AS Barcode4Type
								,ISNULL(T5.IsBarcode4DisplayText, 0) AS IsBarcode4DisplayText
								,T4.VoucherNumber AS Showcode
								,ISNULL(T5.ShowcodeType,'''')
								,ISNULL(T5.[IsShowcodeTypeDisplayText], 0) AS IsShowcodeDisplayText
								,ISNULL(T5.[IsShowcodeTypeEnabled], 0) AS IsShowcodeAPIEnabled
							FROM [Order] AS T1 WITH(NOLOCK)
								INNER JOIN OrderLine AS T2 WITH(NOLOCK) ON T1.Id = T2.OrderId
								INNER JOIN OrderBeneficiaryInfo AS T3  WITH(NOLOCK) ON T2.Id = T3.OrderLineId
								INNER JOIN Voucher AS T4  WITH(NOLOCK) ON T3.Id = T4.[BeneficiaryInfoId]
								INNER JOIN ProductBarcodeSetting AS T5 ON T4.ProductId = T5.Id
								INNER JOIN Product AS T6 ON T4.ProductId = T6.Id
								INNER JOIN VoucherExtendCode  AS T7 ON T4.Id = T7.Id
								INNER JOIN Program AS T8 ON T6.ProgramId = T8.Id
							WHERE T1.OrderNumber = '''
							SET @SqlString = @SqlString + @OrderNumber + ''''
							SET @SqlString = @SqlString + ' AND T8.[IdentityCode] = '''+ @ProgramCode + ''''
						END 
				END

				--SoftWorld
				IF(@ProgramName = 'SoftWorld')
				BEGIN
					IF(LEN(@SqlString) > 1)
					BEGIN
						SET @SqlString = @SqlString + ' 
						UNION ALL 
						'
					END

					SET  @SqlString = @SqlString + 
					'SELECT
						T4.[GUID] AS VoucherGuid
						,ISNULL(T7.Barcode1,'''') AS Barcode1
						,ISNULL(T5.Barcode1Type,'''') AS Barcode1Type
						,ISNULL(T5.IsBarcode1DisplayText, 0) AS IsBarcode1DisplayText
						,ISNULL(T7.Barcode2,'''') AS Barcode2
						,ISNULL(T5.Barcode2Type,'''') AS Barcode2Type
						,ISNULL(T5.IsBarcode2DisplayText, 0) AS IsBarcode2DisplayText
						,'''' AS Barcode3
						,ISNULL(T5.Barcode3Type,'''') AS Barcode3Type
						,ISNULL(T5.IsBarcode3DisplayText, 0) AS IsBarcode3DisplayText
						,'''' AS Barcode4
						,ISNULL(T5.Barcode4Type,'''') AS Barcode4Type
						,ISNULL(T5.IsBarcode4DisplayText, 0) AS IsBarcode4DisplayText
						,T4.VoucherNumber AS Showcode
						,ISNULL(T5.ShowcodeType,'''')
						,ISNULL(T5.[IsShowcodeTypeDisplayText], 0) AS IsShowcodeDisplayText
						,ISNULL(T5.[IsShowcodeTypeEnabled], 0) AS IsShowcodeAPIEnabled
					FROM [Order] AS T1 WITH(NOLOCK)
						INNER JOIN [OrderLine] AS T2 WITH(NOLOCK) ON T1.Id = T2.OrderId
						INNER JOIN [OrderBeneficiaryInfo] AS T3  WITH(NOLOCK) ON T2.Id = T3.OrderLineId
						INNER JOIN Voucher AS T4  WITH(NOLOCK) ON T3.Id = T4.[BeneficiaryInfoId]
						INNER JOIN ProductBarcodeSetting AS T5 ON T4.ProductId = T5.Id
						INNER JOIN Product AS T6 ON T4.ProductId = T6.Id
						INNER JOIN EXT_TW_SoftWorld  AS T7 ON T4.ExtendId = T7.Id
						INNER JOIN Program AS T8 ON T6.ProgramId = T8.Id
					WHERE T1.OrderNumber = '''
					SET @SqlString = @SqlString + @OrderNumber + ''''
					SET @SqlString = @SqlString + ' AND T8.IdentityCode = '''+ @ProgramCode + ''''
				END
	
				-- Family Mart
				IF(@ProgramName = 'FamilyMart')
				BEGIN
					IF(LEN(@SqlString) > 1)
					BEGIN
						SET @SqlString = @SqlString + ' 
						UNION ALL 
						'
					END

					SET  @SqlString = @SqlString + 
					' SELECT
						T4.[GUID] AS VoucherGuid
						,ISNULL(T7.Barcode1,'''') AS Barcode1
						,ISNULL(T5.Barcode1Type,'''') AS Barcode1Type
						,ISNULL(T5.IsBarcode1DisplayText, 0) AS IsBarcode1DisplayText
						,ISNULL(T7.Barcode2,'''') AS Barcode2
						,ISNULL(T5.Barcode2Type,'''') AS Barcode2Type
						,ISNULL(T5.IsBarcode2DisplayText, 0) AS IsBarcode2DisplayText
						,ISNULL(T7.Barcode3,'''') AS Barcode3
						,ISNULL(T5.Barcode3Type,'''') AS Barcode3Type
						,ISNULL(T5.IsBarcode3DisplayText, 0) AS IsBarcode3DisplayText
						,ISNULL(T7.Barcode4,'''') AS Barcode4
						,ISNULL(T5.Barcode4Type,'''') AS Barcode4Type
						,ISNULL(T5.IsBarcode4DisplayText, 0) AS IsBarcode4DisplayText
						,T4.VoucherNumber AS Showcode
						,ISNULL(T5.ShowcodeType,'''')
						,ISNULL(T5.[IsShowcodeTypeDisplayText], 0) AS IsShowcodeDisplayText
						,ISNULL(T5.[IsShowcodeTypeEnabled], 0) AS IsShowcodeAPIEnabled
					FROM [Order] AS T1 WITH(NOLOCK)
						INNER JOIN [OrderLine] AS T2 WITH(NOLOCK) ON T1.Id = T2.OrderId
						INNER JOIN [OrderBeneficiaryInfo] AS T3  WITH(NOLOCK) ON T2.Id = T3.OrderLineId
						INNER JOIN Voucher AS T4  WITH(NOLOCK) ON T3.Id = T4.[BeneficiaryInfoId]
						INNER JOIN ProductBarcodeSetting AS T5 ON T4.ProductId = T5.Id
						INNER JOIN Product AS T6 ON T4.ProductId = T6.Id
						INNER JOIN [EXT_TW_FamilyMart]  AS T7 ON T4.ExtendId = T7.Id
						INNER JOIN Program AS T8 ON T6.ProgramId = T8.Id
					WHERE T1.OrderNumber = '''
					SET @SqlString = @SqlString + @OrderNumber + ''''
					SET @SqlString = @SqlString + ' AND T8.IdentityCode = '''+ @ProgramCode + ''''
				END

				--SevenEleven
				IF(@ProgramName = '7-ELEVEN')
				BEGIN
					IF(LEN(@SqlString) > 1)
					BEGIN
						SET @SqlString = @SqlString + ' 
						UNION ALL 
						'
					END

					SET  @SqlString = @SqlString + 
					' SELECT
						T4.[GUID] AS VoucherGuid
						,ISNULL(T7.Barcode1,'''') AS Barcode1
						,ISNULL(T5.Barcode1Type,'''') AS Barcode1Type
						,ISNULL(T5.IsBarcode1DisplayText, 0) AS IsBarcode1DisplayText
						,ISNULL(T7.Barcode2,'''') AS Barcode2
						,ISNULL(T5.Barcode2Type,'''') AS Barcode2Type
						,ISNULL(T5.IsBarcode2DisplayText, 0) AS IsBarcode2DisplayText
						,'''' AS Barcode3
						,ISNULL(T5.Barcode3Type,'''') AS Barcode3Type
						,ISNULL(T5.IsBarcode3DisplayText, 0) AS IsBarcode3DisplayText
						,'''' AS Barcode4
						,ISNULL(T5.Barcode4Type,'''') AS Barcode4Type
						,ISNULL(T5.IsBarcode4DisplayText, 0) AS IsBarcode4DisplayText
						,T4.VoucherNumber AS Showcode
						,ISNULL(T5.ShowcodeType,'''')
						,ISNULL(T5.[IsShowcodeTypeDisplayText], 0) AS IsShowcodeDisplayText
						,ISNULL(T5.[IsShowcodeTypeEnabled], 0) AS IsShowcodeAPIEnabled
					FROM [Order] AS T1 WITH(NOLOCK)
						INNER JOIN [OrderLine] AS T2 WITH(NOLOCK) ON T1.Id = T2.OrderId
						INNER JOIN [OrderBeneficiaryInfo] AS T3  WITH(NOLOCK) ON T2.Id = T3.OrderLineId
						INNER JOIN Voucher AS T4  WITH(NOLOCK) ON T3.Id = T4.[BeneficiaryInfoId]
						INNER JOIN ProductBarcodeSetting AS T5 ON T4.ProductId = T5.Id
						INNER JOIN Product AS T6 ON T4.ProductId = T6.Id
						INNER JOIN EXT_TW_SEBarcode  AS T7 ON T4.ExtendId = T7.Id
						INNER JOIN Program AS T8 ON T6.ProgramId = T8.Id
					WHERE T1.OrderNumber = '''
					SET @SqlString = @SqlString + @OrderNumber + ''''
					SET @SqlString = @SqlString + ' AND T8.IdentityCode = '''+ @ProgramCode + ''''
				END

				--FamilyMartBardCodeOne
				IF(@ProgramName = 'FamilyMartBardCodeOne')
				BEGIN
					IF(LEN(@SqlString) > 1)
					BEGIN
						SET @SqlString = @SqlString + ' 
						UNION ALL 
						'
					END

					SET  @SqlString = @SqlString + 
					' SELECT
						T4.[GUID] AS VoucherGuid
						,ISNULL(T7.Bardcode1,'''') AS Barcode1
						,ISNULL(T5.Barcode1Type,'''') AS Barcode1Type
						,ISNULL(T5.IsBarcode1DisplayText, 0) AS IsBarcode1DisplayText
						,'''' AS Barcode2
						,ISNULL(T5.Barcode2Type,'''') AS Barcode2Type
						,ISNULL(T5.IsBarcode2DisplayText, 0) AS IsBarcode2DisplayText
						,'''' AS Barcode3
						,ISNULL(T5.Barcode3Type,'''') AS Barcode3Type
						,ISNULL(T5.IsBarcode3DisplayText, 0) AS IsBarcode3DisplayText
						,'''' AS Barcode4
						,ISNULL(T5.Barcode4Type,'''') AS Barcode4Type
						,ISNULL(T5.IsBarcode4DisplayText, 0) AS IsBarcode4DisplayText
						,T4.VoucherNumber AS Showcode
						,ISNULL(T5.ShowcodeType,'''')
						,ISNULL(T5.[IsShowcodeTypeDisplayText], 0) AS IsShowcodeDisplayText
						,ISNULL(T5.[IsShowcodeTypeEnabled], 0) AS IsShowcodeAPIEnabled
					FROM [Order] AS T1 WITH(NOLOCK)
						INNER JOIN [OrderLine] AS T2 WITH(NOLOCK) ON T1.Id = T2.OrderId
						INNER JOIN [OrderBeneficiaryInfo] AS T3  WITH(NOLOCK) ON T2.Id = T3.OrderLineId
						INNER JOIN Voucher AS T4  WITH(NOLOCK) ON T3.Id = T4.[BeneficiaryInfoId]
						INNER JOIN ProductBarcodeSetting AS T5 ON T4.ProductId = T5.Id
						INNER JOIN Product AS T6 ON T4.ProductId = T6.Id
						INNER JOIN EXT_TW_FamilyMartBardCodeOne  AS T7 ON T4.ExtendId = T7.Id
						INNER JOIN Program AS T8 ON T6.ProgramId = T8.Id
					WHERE T1.OrderNumber = '''
					SET @SqlString = @SqlString + @OrderNumber + ''''
					SET @SqlString = @SqlString + ' AND T8.IdentityCode = '''+ @ProgramCode + ''''
				END

				IF(@ProgramName = 'MyCard')
				BEGIN
					IF(LEN(@SqlString) > 1)
					BEGIN
						SET @SqlString = @SqlString + ' 
						UNION ALL 
						'
					END

					SET  @SqlString = @SqlString + 
					'SELECT
						T4.[GUID] AS VoucherGuid
						,ISNULL(T7.Barcode1,'''') AS Barcode1
						,ISNULL(T5.Barcode1Type,'''') AS Barcode1Type
						,ISNULL(T5.IsBarcode1DisplayText, 0) AS IsBarcode1DisplayText
						,ISNULL(T7.Barcode2,'''') AS Barcode2
						,ISNULL(T5.Barcode2Type,'''') AS Barcode2Type
						,ISNULL(T5.IsBarcode2DisplayText, 0) AS IsBarcode2DisplayText
						,'''' AS Barcode3
						,ISNULL(T5.Barcode3Type,'''') AS Barcode3Type
						,ISNULL(T5.IsBarcode3DisplayText, 0) AS IsBarcode3DisplayText
						,'''' AS Barcode4
						,ISNULL(T5.Barcode4Type,'''') AS Barcode4Type
						,ISNULL(T5.IsBarcode4DisplayText, 0) AS IsBarcode4DisplayText
						,T4.VoucherNumber AS Showcode
						,ISNULL(T5.ShowcodeType,'''') ShowcodeType
						,ISNULL(T5.[IsShowcodeTypeDisplayText], 0) AS IsShowcodeDisplayText
						,ISNULL(T5.[IsShowcodeTypeEnabled], 0) AS IsShowcodeAPIEnabled
					FROM [Order] AS T1 WITH(NOLOCK)
						INNER JOIN [OrderLine] AS T2 WITH(NOLOCK) ON T1.Id = T2.OrderId
						INNER JOIN [OrderBeneficiaryInfo] AS T3  WITH(NOLOCK) ON T2.Id = T3.OrderLineId
						INNER JOIN Voucher AS T4  WITH(NOLOCK) ON T3.Id = T4.[BeneficiaryInfoId]
						INNER JOIN ProductBarcodeSetting AS T5 ON T4.ProductId = T5.Id
						INNER JOIN Product AS T6 ON T4.ProductId = T6.Id
						INNER JOIN EXT_MyCard  AS T7 ON T4.ExtendId = T7.Id
						INNER JOIN Program AS T8 ON T6.ProgramId = T8.Id
					WHERE T1.OrderNumber = '''
					SET @SqlString = @SqlString + @OrderNumber + ''''
					SET @SqlString = @SqlString + ' AND T8.IdentityCode = '''+ @ProgramCode + ''''
				END
			FETCH NEXT FROM CusGetBarcodeByProgam INTO @ProgramName,@ProgramCode
         END
     CLOSE CusGetBarcodeByProgam 
     DEALLOCATE CusGetBarcodeByProgam 


	--PRINT @SqlString
	EXECUTE (@SqlString)

	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
		BEGIN
			SELECT 1
		END
	END CATCH
END
