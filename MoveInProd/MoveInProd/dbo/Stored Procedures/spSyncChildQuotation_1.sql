

CREATE PROCEDURE [dbo].[spSyncChildQuotation]
    @MasterClientQuotationProductId INT
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

        SET NOCOUNT ON;
	
        DECLARE @ClientQuotationId INT;
        DECLARE @CurrentDate DATETIME;

        SET @CurrentDate = FORMAT(GETDATE(), 'yyyy-MM-dd');

        SELECT DISTINCT
                @ClientQuotationId = cq.Id
        FROM    dbo.ClientQuotationProduct AS t1 WITH ( NOLOCK )
                JOIN dbo.ClientQuotationProductCombo AS t2 WITH ( NOLOCK ) ON t2.ClientQuotationProductId = t1.Id
                JOIN dbo.ClientQuotationProduct AS cqp WITH ( NOLOCK ) ON t2.ChildClientQuotationProductId = cqp.Id
                JOIN dbo.ClientQuotation AS cq WITH ( NOLOCK ) ON cq.Id = cqp.ClientQuotationId
        WHERE   t1.Id = @MasterClientQuotationProductId

        IF @ClientQuotationId IS NULL
            BEGIN
                RETURN;
            END
	
        SELECT  P.ProductCode ,
                cqps.Id AS soldId
        INTO    #ProductTemp
        FROM    ClientQuotation CQ
                INNER JOIN ClientQuotationProduct CQP ON CQ.Id = CQP.ClientQuotationId
                INNER JOIN ProductVersion PV ON CQP.ProductVersionId = PV.Id
                INNER JOIN Product P ON PV.ProductId = P.Id
                JOIN dbo.ClientQuotationProductCombo AS mcqpc WITH ( NOLOCK ) ON mcqpc.ChildClientQuotationProductId = CQP.Id
                JOIN dbo.ClientQuotationProduct AS mcqp ON mcqp.Id = mcqpc.ClientQuotationProductId
                JOIN ( SELECT TOP 1
                                *
                       FROM     dbo.ClientQuotationProductSoldPrice WITH ( NOLOCK )
                       WHERE    ClientQuotationProductId = @MasterClientQuotationProductId
                       ORDER BY id DESC
                     ) AS cqps ON cqps.ClientQuotationProductId = mcqp.Id
        WHERE   CQ.Id = @ClientQuotationId
                AND mcqp.Id = @MasterClientQuotationProductId
	
        BEGIN TRY
            BEGIN TRANSACTION
			
			-- Change quotation product status.
            UPDATE  T1
            SET     T1.[Status] = 32 ,
                    [ApprovedBy] = 'TX2 Product Combo' ,
                    [ApprovedOn] = GETDATE()
            FROM    [dbo].[ClientQuotationProduct] AS T1
                    INNER JOIN [dbo].[ClientQuotation] AS T2 ON T1.ClientQuotationId = T2.Id
            WHERE   T2.Id = @ClientQuotationId
			
			-- Add quotation product sold price history
            INSERT  INTO [dbo].[ClientQuotationProductSoldPriceHistory]
                    ( ClientQuotationProductId ,
                      OldSoldPrice ,
                      NewSoldPrice ,
                      ApprovedBy ,
                      ApprovedOn ,
                      NewSoldPriceWithTax
                    )
                    SELECT  T2.Id ,
                            0 ,
                            cqps.SoldPriceWithoutTax ,
                            'TX2 Product Combo' ,
                            GETDATE() ,
                            cqps.SoldPriceWithTax
                    FROM    ( SELECT TOP 1
                                        *
                              FROM      dbo.ClientQuotationProductSoldPrice
                                        WITH ( NOLOCK )
                              WHERE     ClientQuotationProductId = @MasterClientQuotationProductId
                              ORDER BY  id DESC
                            ) AS cqps
                            INNER JOIN [dbo].[ClientQuotationProduct] AS cqp ON cqps.ClientQuotationProductId = cqp.Id
                            JOIN dbo.ClientQuotationProductCombo AS t1 WITH ( NOLOCK ) ON t1.ClientQuotationProductId = cqp.Id
                            JOIN dbo.ClientQuotationProduct AS t2 WITH ( NOLOCK ) ON t1.ChildClientQuotationProductId = t2.Id
                    WHERE   cqp.Id = @MasterClientQuotationProductId

			/*set previous validity end to the day before today */
            UPDATE  T1
            SET     T1.[ValidityEnd] = T4.ValidityEnd
            FROM    [dbo].[ClientQuotationProductSoldPrice] AS T1
                    INNER JOIN [dbo].[ClientQuotationProduct] AS T2 ON T1.ClientQuotationProductId = T2.Id
                    INNER JOIN [dbo].[ClientQuotation] AS T3 ON T2.ClientQuotationId = T3.Id
                    JOIN dbo.ClientQuotationProductCombo AS cqpc WITH ( NOLOCK ) ON cqpc.ChildClientQuotationProductId = t2.Id
                    JOIN dbo.ClientQuotationProduct AS cqp ON cqp.Id = cqpc.ClientQuotationProductId
					INNER JOIN ( SELECT TOP 1
                                            *
                                   FROM     dbo.ClientQuotationProductSoldPrice
                                            WITH ( NOLOCK )
                                   WHERE    ClientQuotationProductId = @MasterClientQuotationProductId and ValidityEnd < '3999-01-01'
                                   ORDER BY id DESC
                                 ) AS T4 ON T4.ClientQuotationProductId = cqp.Id
            WHERE   cqp.Id = @MasterClientQuotationProductId
                    AND T1.[ValidityEnd] = '3999-01-01 00:00:00.000'

            INSERT  INTO dbo.ClientQuotationProductSoldPrice
                    ( ClientQuotationProductId ,
                      SoldPriceWithoutTax ,
                      SoldPriceWithTax ,
                      ValueBasedSoldPriceWithoutTax ,
                      ValueBasedSoldPriceWithTax ,
                      ValidityFrom ,
                      ValidityEnd ,
                      Status ,
                      CreatedBy ,
                      CreatedOn ,
                      ApprovedBy ,
                      ApprovedOn
			        )
                    SELECT  T2.Id ,
							CASE 
								WHEN t6.ProductType = 1 THEN
									CASE 
										WHEN masterP.ProductType = 2 AND (masterP.ProductSubType = 6 OR masterP.ProductSubType = 8)
											THEN CONVERT(numeric(15,4), childPPPB.FaceValue * cqps.ValueBasedSoldPriceWithTax / masterPPVB.FaceValueWithTax)
										ELSE CONVERT(numeric(15,4),cqps.SoldPriceWithoutTax / childPPPB.Balance)
									END
								ELSE NULL
                            END,
                            CASE 
								WHEN t6.ProductType = 1 THEN
									CASE 
										WHEN masterP.ProductType = 2 AND (masterP.ProductSubType = 6 OR masterP.ProductSubType = 8)
											THEN CONVERT(numeric(15,4), childPPPB.FaceValueWithTax * cqps.ValueBasedSoldPriceWithTax / masterPPVB.FaceValueWithTax)
										ELSE CONVERT(numeric(15,4),cqps.SoldPriceWithTax / childPPPB.Balance)
									END
								ELSE NULL
                            END,
                            CASE 
								WHEN t6.ProductType = 2 THEN
									CASE 
										WHEN masterP.ProductType = 2 AND (masterP.ProductSubType = 6 OR masterP.ProductSubType = 8)
											THEN CONVERT(numeric(15,4), childPPVB.FaceValue * cqps.ValueBasedSoldPriceWithTax / masterPPVB.FaceValueWithTax)
										ELSE cqps.SoldPriceWithoutTax
									END
								ELSE NULL
                            END,
                            CASE 
								WHEN t6.ProductType = 2 THEN
									CASE 
										WHEN masterP.ProductType = 2 AND (masterP.ProductSubType = 6 OR masterP.ProductSubType = 8)
											THEN CONVERT(numeric(15,4), childPPVB.FaceValueWithTax * cqps.ValueBasedSoldPriceWithTax / masterPPVB.FaceValueWithTax)
										ELSE cqps.SoldPriceWithTax
									END
								ELSE NULL
                            END,
                            cqps.ValidityFrom ,
                            cqps.ValidityEnd ,
                            2 ,
                            'TX2 Product Combo' ,
                            GETDATE() ,
                            'TX2 Product Combo' ,
                            GETDATE()
                    FROM    [dbo].[ClientQuotationProduct] AS T2
                            INNER JOIN [dbo].[ClientQuotation] AS T3 ON T2.ClientQuotationId = T3.Id
                            JOIN dbo.ClientQuotationProductCombo AS cqpc WITH ( NOLOCK ) ON cqpc.ChildClientQuotationProductId = t2.Id
                            JOIN dbo.ClientQuotationProduct AS cqp ON cqp.Id = cqpc.ClientQuotationProductId
                            JOIN ( SELECT TOP 1
                                            *
                                   FROM     dbo.ClientQuotationProductSoldPrice
                                            WITH ( NOLOCK )
                                   WHERE    ClientQuotationProductId = @MasterClientQuotationProductId
                                   ORDER BY id DESC
                                 ) AS cqps ON cqps.ClientQuotationProductId = cqp.Id
                            JOIN dbo.ProductComboSet AS t5 WITH ( NOLOCK ) ON t5.Id = cqpc.ProductComboSetId
                            JOIN dbo.Product AS t6 WITH ( NOLOCK ) ON t6.Id = t5.ChildProductId
							LEFT JOIN dbo.ProductVersion masterPV WITH(NOLOCK) ON masterPV.Id = cqp.ProductVersionId
							LEFT JOIN dbo.Product masterP WITH(NOLOCK) ON masterP.Id = masterPV.ProductId
							LEFT JOIN dbo.ProductPricingValueBased masterPPVB WITH(NOLOCK) ON masterPPVB.Id = masterPV.ProductPricingValueBasedId
							LEFT JOIN dbo.ProductVersion childPV WITH(NOLOCK) ON childPV.Id = t5.ChildProductVersionId
							LEFT JOIN dbo.ProductPricingProductBased childPPPB WITH(NOLOCK) ON childPPPB.Id = childPV.ProductPricingProductBasedId
							LEFT JOIN dbo.ProductPricingValueBased childPPVB WITH(NOLOCK) ON childPPVB.Id = childPV.ProductPricingValueBasedId
                    WHERE   cqp.Id = @MasterClientQuotationProductId
	

			/* set ClientQuotationPricing previous validity end to the day before today */
            UPDATE  T1
            SET     [ValidityEnd] = DATEADD(SS, -1, T4.[ValidityFrom])
            FROM    [dbo].[ClientQuotationPricing] AS T1
                    INNER JOIN [dbo].[ClientQuotationProduct] AS T2 ON T1.ClientQuotationProductId = T2.Id
                    INNER JOIN [dbo].[ClientQuotation] AS T3 ON T2.ClientQuotationId = T3.Id
                    INNER JOIN [dbo].[ClientQuotationProductSoldPrice] AS T4 ON T4.ClientQuotationProductId = T1.ClientQuotationProductId
                    JOIN dbo.ClientQuotationProductCombo AS cqpc WITH ( NOLOCK ) ON cqpc.ChildClientQuotationProductId = t2.Id
                    JOIN dbo.ClientQuotationProduct AS cqp ON cqp.Id = cqpc.ClientQuotationProductId
            WHERE   cqp.Id = @MasterClientQuotationProductId
                    AND T1.[ValidityEnd] = '3999-01-01 00:00:00.000'
                    AND T4.[ValidityEnd] = '3999-01-01 00:00:00.000'
			
			/* Add data into ClientQuotationPricing */
            INSERT  INTO [dbo].[ClientQuotationPricing]
                    ( [ClientQuotationProductId] ,
                      [TransactionTypeId] ,
                      [InvoiceClient] ,
                      [ValueBasedInvoiceClient] ,
                      [ValidityFrom] ,
                      [ValidityEnd]
                    )
                    SELECT DISTINCT
                            T2.Id AS [ClientQuotationProductId] ,
                            T1.[TransactionTypeId] ,
                            CASE WHEN t6.ProductType = 1
                                 THEN ISNULL(T4.SoldPriceWithoutTax, 0)
                                      * T5.[FaceValueCoefficient]
                                 ELSE 0
                            END ,
                            CASE WHEN t6.ProductType = 2
                                 THEN ISNULL(T4.SoldPriceWithoutTax, 0)
                                      * T5.[FaceValueCoefficient]
                                 ELSE 0
                            END ,
                            T4.[ValidityFrom] ,
                            T4.[ValidityEnd]
                    FROM    [dbo].[ClientQuotationPricing] AS T1
                            INNER JOIN [dbo].[ClientQuotationProduct] AS T2 ON T1.ClientQuotationProductId = T2.Id
                            JOIN dbo.ClientQuotationProductCombo AS cqpc WITH ( NOLOCK ) ON cqpc.ChildClientQuotationProductId = t2.Id
                            JOIN dbo.ProductComboSet AS pcs WITH ( NOLOCK ) ON pcs.Id = cqpc.ProductComboSetId
                            JOIN dbo.Product AS t6 WITH ( NOLOCK ) ON t6.Id = pcs.ChildProductId
                            JOIN dbo.ClientQuotationProduct AS cqp ON cqp.Id = cqpc.ClientQuotationProductId
                            INNER JOIN [dbo].[ClientQuotation] AS T3 ON T2.ClientQuotationId = T3.Id
                            INNER JOIN ( SELECT TOP 1
                                                *
                                         FROM   dbo.ClientQuotationProductSoldPrice
                                                WITH ( NOLOCK )
                                         WHERE  ClientQuotationProductId = @MasterClientQuotationProductId
                                         ORDER BY id DESC
                                       ) AS T4 ON T4.ClientQuotationProductId = cqp.Id
                            INNER JOIN [dbo].[BusinessModelTransactionType] AS T5 ON T5.[TransactionTypeId] = T1.[TransactionTypeId]
                                                              AND T5.[BusinessModelId] = T3.BusinessModelId
                    WHERE   cqp.Id = @MasterClientQuotationProductId
		
			
			/*set previous validity end to the day before today */
            UPDATE  T1
            SET     T1.[ValidityEnd] = DATEADD(SS, -1, T4.[ValidityFrom])
            FROM    [dbo].[ClientQuotationProductServiceFeeTriggerTime] AS T1
                    INNER JOIN [dbo].[ClientQuotationProduct] AS T2 ON T1.ClientQuotationProductId = T2.Id
                    INNER JOIN [dbo].[ClientQuotation] AS T3 ON T2.ClientQuotationId = T3.Id
                    INNER JOIN [dbo].[ClientQuotationProductServiceFeeTriggerTime]
                    AS T4 ON T1.ClientQuotationProductId = T4.ClientQuotationProductId
                             AND T1.[ServiceFeeTriggerTimeId] = T4.[ServiceFeeTriggerTimeId]
                    JOIN dbo.ClientQuotationProductCombo AS cqpc WITH ( NOLOCK ) ON cqpc.ChildClientQuotationProductId = t2.Id
                    JOIN dbo.ClientQuotationProduct AS cqp ON cqp.Id = cqpc.ClientQuotationProductId
            WHERE   cqp.Id = @MasterClientQuotationProductId
                    AND T1.[ValidityEnd] = '3999-01-01 00:00:00.000'

            INSERT  INTO dbo.ClientQuotationProductServiceFeeTriggerTime
                    ( ClientQuotationProductId ,
                      ServiceFeeTriggerTimeId ,
                      SoldPrice ,
                      SoldPriceWithTax ,
                      ValidityFrom ,
                      ValidityEnd ,
                      Status ,
                      CreatedBy ,
                      CreatedOn ,
                      ApprovedBy ,
                      ApprovedOn
					 )
                    SELECT  T2.Id ,
                            cqps.ServiceFeeTriggerTimeId ,
                            cqps.SoldPrice ,
                            cqps.SoldPriceWithTax ,
                            cqps.ValidityFrom ,
                            cqps.ValidityEnd ,
                            cqps.Status ,
                            'TX2 Product Combo' ,
                            GETDATE() ,
                            'TX2 Product Combo' ,
                            GETDATE()
                    FROM    [dbo].[ClientQuotationProduct] AS T2 WITH ( NOLOCK )
                            INNER JOIN [dbo].[ClientQuotation] AS T3 WITH ( NOLOCK ) ON T2.ClientQuotationId = T3.Id
                            JOIN dbo.ClientQuotationProductCombo AS cqpc WITH ( NOLOCK ) ON cqpc.ChildClientQuotationProductId = t2.Id
                            JOIN dbo.ClientQuotationProduct AS cqp WITH ( NOLOCK ) ON cqp.Id = cqpc.ClientQuotationProductId
                            JOIN dbo.[ClientQuotationProductServiceFeeTriggerTime]
                            AS cqps WITH ( NOLOCK ) ON cqps.ClientQuotationProductId = cqp.Id
                    WHERE   cqp.Id = @MasterClientQuotationProductId
                            AND cqps.ValidityEnd = '3999-01-01 00:00:00.000'
				
			
            DECLARE @ProductCode VARCHAR(50)
            DECLARE @ProductType TINYINT
            DECLARE @SoldPriceWithTax NUMERIC(15, 4)
            DECLARE @FaceValueWithTax INT
            DECLARE @ValidityFrom DATETIME
            DECLARE @ValidityEnd DATETIME
            DECLARE @OrderLineTrustAccountId INT
            DECLARE @OrderLineId INT
            DECLARE @soldId INT
			
            DECLARE product_cursor CURSOR
            FOR
                SELECT  *
                FROM    #ProductTemp
			
            OPEN product_cursor
            FETCH NEXT FROM product_cursor INTO @ProductCode, @soldId
			
            WHILE @@FETCH_STATUS = 0
                BEGIN
                    IF @soldId IS NULL
                        BEGIN
                            FETCH NEXT FROM product_cursor INTO @ProductCode,
                                @soldId
                            CONTINUE;--Ã»ÓÐ±ä¼ÛµÄÎÞÐè´¦Àí
                        END

                    SELECT TOP 1
                            @ProductType = P.ProductType ,
                            @SoldPriceWithTax = CQPSP.SoldPriceWithTax ,
                            @FaceValueWithTax = PPV.FaceValueWithTax ,
                            @ValidityFrom = CQPSP.ValidityFrom ,
                            @ValidityEnd = CQPSP.ValidityEnd
                    FROM    ClientQuotationProductSoldPrice CQPSP
                            INNER JOIN ClientQuotationProduct CQP ON CQPSP.ClientQuotationProductId = CQP.Id
                            INNER JOIN ClientQuotation CQ ON CQP.ClientQuotationId = CQ.Id
                            INNER JOIN ProductVersion PV ON CQP.ProductVersionId = PV.Id
                            INNER JOIN Product P ON PV.ProductId = P.Id
                            LEFT OUTER JOIN ProductPricingValueBased PPV ON PV.ProductPricingValueBasedId = PPV.Id
                    WHERE   CQ.Id = @ClientQuotationId
                            AND P.ProductCode = @ProductCode
                    ORDER BY CQPSP.Id DESC
				
                    DECLARE trust_cursor CURSOR
                    FOR
                        SELECT  MAX(OLTA.Id) Id ,
                                OLTA.OrderLineId
                        FROM    ClientQuotation CQ
                                INNER JOIN ClientQuotationProduct CQP ON CQ.Id = CQP.ClientQuotationId
                                INNER JOIN ProductVersion PV ON CQP.ProductVersionId = PV.Id
                                INNER JOIN Product P ON PV.ProductId = P.Id
                                INNER JOIN OrderLine OL ON CQP.Id = OL.ClientQuotationProductId
                                INNER JOIN OrderLineTrustAccount OLTA ON OL.Id = OLTA.OrderLineId
                        WHERE   CQ.Id = @ClientQuotationId
                                AND P.ProductCode = @ProductCode
                                AND OLTA.TrustAccountOption = 0 -- Default
                        GROUP BY OLTA.OrderLineId
				
                    OPEN trust_cursor
                    FETCH NEXT FROM trust_cursor INTO @OrderLineTrustAccountId,
                        @OrderLineId
				
                    WHILE @@FETCH_STATUS = 0
                        BEGIN
                            BEGIN TRY
                                INSERT  INTO OrderLineTrustAccount
                                        ( OrderLineId ,
                                          TrustAccountId ,
                                          TrustAccountOption ,
                                          TrustAccountBatchNo ,
                                          Amount ,
                                          ExpiryPolicyId ,
                                          ExpiryDate ,
                                          ValidFrom ,
                                          ValidTo
                                        )
                                        SELECT  OrderLineId ,
                                                TrustAccountId ,
                                                TrustAccountOption ,
                                                TrustAccountBatchNo ,
                                                CASE @ProductType
                                                  WHEN 1
                                                  THEN @SoldPriceWithTax
                                                  WHEN 2
                                                  THEN @FaceValueWithTax
                                                END ,
                                                ExpiryPolicyId ,
                                                ExpiryDate ,
                                                @ValidityFrom ,
                                                ValidTo
                                        FROM    OrderLineTrustAccount
                                        WHERE   Id = @OrderLineTrustAccountId
					
                                UPDATE  OrderLineTrustAccount
                                SET     ValidTo = DATEADD(SS, -1,
                                                          @ValidityFrom)
                                WHERE   Id = @OrderLineTrustAccountId

                                FETCH NEXT FROM trust_cursor INTO @OrderLineTrustAccountId,
                                    @OrderLineId
                            END TRY
                            BEGIN CATCH
                                SELECT  ERROR_MESSAGE()
                            END CATCH
                        END
				
                    CLOSE trust_cursor
                    DEALLOCATE trust_cursor
				
                    FETCH NEXT FROM product_cursor INTO @ProductCode, @soldId
                END
			
            CLOSE product_cursor
            DEALLOCATE product_cursor
			
            COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH
            SELECT  ERROR_MESSAGE()
            ROLLBACK TRANSACTION;
        END CATCH

    END
