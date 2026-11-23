
CREATE PROCEDURE spCreateChildClientQuotation
    @QuotationNumber VARCHAR(50) ,
    @IsSuccess BIT OUTPUT
AS
    BEGIN

        DECLARE @MasterClientQuotationProductId INT
        DECLARE @ChildClientQuotationId INT
        DECLARE @SequenceNextValue VARCHAR(100)
        DECLARE @ClientId INT
        DECLARE @now datetime = getdate()

        IF NOT EXISTS ( SELECT  1
                        FROM    dbo.ClientQuotation AS t1 WITH ( NOLOCK )
                                JOIN dbo.ClientQuotationProduct AS t2 WITH ( NOLOCK ) ON t2.ClientQuotationId = t1.Id
                                JOIN dbo.ClientQuotationProductCombo AS t3
                                WITH ( NOLOCK ) ON t3.ClientQuotationProductId = t2.Id
                        WHERE   t1.QuotationNumber = @QuotationNumber
                                AND t1.Status = 32
                                AND t3.ChildClientQuotationProductId IS NULL )
            BEGIN
                SELECT  @IsSuccess = 1
                RETURN
            END

        IF NOT EXISTS ( SELECT  *
                        FROM    dbo.Client WITH ( NOLOCK )
                        WHERE   Name = 'Smart Choice Voucher' )
            BEGIN
                SELECT  @IsSuccess = 0
                RETURN
            END
        ELSE
            BEGIN
                SELECT  @ClientId = Id
                FROM    dbo.Client WITH ( NOLOCK )
                WHERE   Name = 'Smart Choice Voucher'
            END

        BEGIN TRAN

        DECLARE db_cursor CURSOR
        FOR
            SELECT DISTINCT
                    t2.Id
            FROM    dbo.ClientQuotation AS t1 WITH ( NOLOCK )
                    JOIN dbo.ClientQuotationProduct AS t2 WITH ( NOLOCK ) ON t2.ClientQuotationId = t1.Id
                    JOIN dbo.ProductVersion AS t3 WITH ( NOLOCK ) ON t3.Id = t2.ProductVersionId
                    JOIN dbo.Product AS t4 WITH ( NOLOCK ) ON t4.Id = t3.ProductId
                                                              AND t4.IsMasterProduct = 1
                    JOIN dbo.ClientQuotationProductCombo AS t5 WITH ( NOLOCK ) ON t5.ClientQuotationProductId = t2.Id
            WHERE   t1.QuotationNumber = @QuotationNumber
                    AND t1.Status = 32
                    AND t5.ChildClientQuotationProductId IS NULL

        OPEN db_cursor  
        FETCH NEXT FROM db_cursor INTO @MasterClientQuotationProductId

        WHILE @@FETCH_STATUS = 0
            BEGIN 
                BEGIN TRY

                    EXEC dbo.getSequenceNextValue @SequenceName = 'Seq_QuotationNumber',
                        @IsFixReturnLength = 1, @ReturnLength = 4,
                        @PaddingCharacter = '0',
                        @ret = @SequenceNextValue OUTPUT

                    INSERT  INTO dbo.ClientQuotation
                            ( ClientId ,
                              QuotationNumber ,
                              ValidFrom ,
                              ValidTo ,
                              ProjectCode ,
                              ProjectName ,
                              QuotationType ,
                              BusinessModelId ,
                              Sales ,
                              ContactName ,
                              ContactPosition ,
                              ContactEmail ,
                              ContactPhone ,
                              Status ,
                              BusinessTypeId ,
                              EndClientId ,
                              CampaignType1Id ,
                              CampaignType2Id ,
                              AdvanceBilling ,
                              ServiceFeeType ,
                              IsIgnoreIssueNumberLimit ,
                              SalesEmail ,
                              BillingFrequency ,
                              BillingDate ,
                              PaymentTerm ,
                              BBXAdvanceBilling ,
                              AutoCreateBilling ,
                              FinanceEmail ,
                              ModifiedOn ,
                              SubBusinessModelId ,
                              FinanceExpireDays ,
                              CreatedBySystem
	                        )
                            SELECT  DISTINCT
                                    @ClientId ,
                                    CONVERT(VARCHAR(50), GETDATE(), 112)
                                    + @SequenceNextValue ,
                                    t1.ValidFrom ,
                                    t1.ValidTo ,
                                    'SCV_'+ convert(varchar,t2.Id) + '_' + NULLIF(t1.ProjectCode, '') AS ProjectCode,
                                    t1.ProjectName ,
                                    t1.QuotationType ,
                                    t3.BusinessModelId ,
                                    t1.Sales ,
                                    t1.ContactName ,
                                    t1.ContactPosition ,
                                    t1.ContactEmail ,
                                    t1.ContactPhone ,
                                    t1.Status ,
                                    t1.BusinessTypeId ,
                                    t1.EndClientId ,
                                    t1.CampaignType1Id ,
                                    t1.CampaignType2Id ,
                                    t1.AdvanceBilling ,
                                    t1.ServiceFeeType ,
                                    t1.IsIgnoreIssueNumberLimit ,
                                    t1.SalesEmail ,
                                    t1.BillingFrequency ,
                                    t1.BillingDate ,
                                    t1.PaymentTerm ,
                                    t1.BBXAdvanceBilling ,
                                    0 ,
                                    t1.FinanceEmail ,
                                    @now ,
                                    t1.SubBusinessModelId ,
                                    t1.FinanceExpireDays ,
                                    1
                            FROM    dbo.ClientQuotation AS t1 WITH ( NOLOCK )
                                    JOIN dbo.ClientQuotationProduct AS t2 WITH ( NOLOCK ) ON t2.ClientQuotationId = t1.Id
                                    JOIN dbo.ClientQuotationProductCombo AS t3
                                    WITH ( NOLOCK ) ON t3.ClientQuotationProductId = t2.Id
                            WHERE   t1.QuotationNumber = @QuotationNumber
                                    AND t1.Status = 32
                                    AND t3.ChildClientQuotationProductId IS NULL
                                    AND t2.Id = @MasterClientQuotationProductId

                    SELECT  @ChildClientQuotationId = SCOPE_IDENTITY()

                    INSERT  INTO dbo.ClientQuotationProduct
                            ( ClientQuotationId ,
                              ProductVersionId ,
                              ExpirySchemeId ,
                              MaxIssueVoucherNumber ,
                              CreatedBy ,
                              CreatedOn ,
                              Status ,
                              ApprovedBy ,
                              ApprovedOn ,
                              SystemProcessFee ,
                              ExpirationDate
				            )
                            SELECT DISTINCT
                                    @ChildClientQuotationId ,
                                    t6.Id ,
                                    t3.ExpirySchemeId ,
                                    t2.MaxIssueVoucherNumber ,
                                    t2.CreatedBy ,
                                    t2.CreatedOn ,
                                    t2.Status ,
                                    t2.ApprovedBy ,
                                    t2.ApprovedOn ,
                                    t2.SystemProcessFee ,
                                    t3.ExpirationDate
                            FROM    dbo.ClientQuotation AS t1 WITH ( NOLOCK )
                                    JOIN dbo.ClientQuotationProduct AS t2 WITH ( NOLOCK ) ON t2.ClientQuotationId = t1.Id
                                    JOIN dbo.ClientQuotationProductCombo AS t3
                                    WITH ( NOLOCK ) ON t3.ClientQuotationProductId = t2.Id
                                    JOIN dbo.ProductComboSet AS t4 WITH ( NOLOCK ) ON t4.Id = t3.ProductComboSetId
                                    JOIN dbo.Product AS t5 WITH ( NOLOCK ) ON t5.Id = t4.ChildProductId
                                    JOIN dbo.ProductVersion AS t6 WITH ( NOLOCK ) ON t6.ProductId = t5.Id
                                                              AND t6.IsCurrentVersion = 1
                            WHERE   t1.QuotationNumber = @QuotationNumber
                                    AND t1.Status = 32
                                    AND t3.ChildClientQuotationProductId IS NULL
                                    AND t2.Id = @MasterClientQuotationProductId

                    UPDATE  t6
                    SET     ChildClientQuotationProductId = t2.Id
                    FROM    dbo.ClientQuotation AS t1
                            JOIN dbo.ClientQuotationProduct AS t2 ON t2.ClientQuotationId = t1.Id
                            JOIN dbo.ProductVersion AS t3 WITH ( NOLOCK ) ON t3.Id = t2.ProductVersionId
                            JOIN dbo.Product AS t4 WITH ( NOLOCK ) ON t4.Id = t3.ProductId
                            JOIN dbo.ProductComboSet AS t5 WITH ( NOLOCK ) ON t5.ChildProductId = t4.Id
                            JOIN dbo.ClientQuotationProductCombo AS t6 WITH ( NOLOCK ) ON t6.ProductComboSetId = t5.Id
                            JOIN dbo.ClientQuotationProduct AS cqp ON cqp.Id = t6.ClientQuotationProductId
                            JOIN dbo.ClientQuotation AS cq ON cq.Id = cqp.ClientQuotationId
                    WHERE   cq.QuotationNumber = @QuotationNumber
                            AND cq.Status = 32
                            AND cqp.Id = @MasterClientQuotationProductId
                            AND t1.Id = @ChildClientQuotationId

                    INSERT  INTO dbo.ClientQuotationPricing
                            ( ClientQuotationProductId ,
                              TransactionTypeId ,
                              InvoiceClient ,
                              ValueBasedInvoiceClient ,
                              ValidityFrom ,
                              ValidityEnd
                            )
                            SELECT DISTINCT
                                    t3.ChildClientQuotationProductId ,
                                    t4.TransactionTypeId ,
                                    t4.InvoiceClient ,
                                    t4.ValueBasedInvoiceClient ,
                                    t4.ValidityFrom ,
                                    t4.ValidityEnd
                            FROM    dbo.ClientQuotation AS t1
                                    JOIN dbo.ClientQuotationProduct AS t2 ON t2.ClientQuotationId = t1.Id
                                    JOIN dbo.ClientQuotationProductCombo AS t3
                                    WITH ( NOLOCK ) ON t3.ClientQuotationProductId = t2.Id
                                    JOIN ClientQuotationPricing AS t4 ON t4.ClientQuotationProductId = t2.Id
                            WHERE   t1.QuotationNumber = @QuotationNumber
                                    AND t1.Status = 32
                                    AND t2.Id = @MasterClientQuotationProductId

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
                            SELECT DISTINCT
                                    t3.ChildClientQuotationProductId ,
                                    t4.ServiceFeeTriggerTimeId ,
                                    t4.SoldPrice ,
                                    t4.SoldPriceWithTax ,
                                    t4.ValidityFrom ,
                                    t4.ValidityEnd ,
                                    t4.Status ,
                                    t4.CreatedBy ,
                                    t4.CreatedOn ,
                                    t4.ApprovedBy ,
                                    t4.ApprovedOn
                            FROM    dbo.ClientQuotation AS t1
                                    JOIN dbo.ClientQuotationProduct AS t2 ON t2.ClientQuotationId = t1.Id
                                    JOIN dbo.ClientQuotationProductCombo AS t3
                                    WITH ( NOLOCK ) ON t3.ClientQuotationProductId = t2.Id
                                    JOIN ClientQuotationProductServiceFeeTriggerTime
                                    AS t4 ON t4.ClientQuotationProductId = t2.Id
                            WHERE   t1.QuotationNumber = @QuotationNumber
                                    AND t1.Status = 32
                                    AND t2.Id = @MasterClientQuotationProductId

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
							--Super Voucher 母产品的ValueBasedSoldPriceWithTax / FaceValueWithTax 得到一个比值 使用这个比值得到子产品的soldPrice
                            SELECT DISTINCT
                                    t3.ChildClientQuotationProductId ,
									CASE 
										WHEN t6.ProductType = 1 THEN
											CASE 
												WHEN masterP.ProductType = 2 AND (masterP.ProductSubType = 6 OR masterP.ProductSubType = 8)
													THEN CONVERT(numeric(15,4), childPPPB.FaceValue * t4.ValueBasedSoldPriceWithTax / masterPPVB.FaceValueWithTax)
												ELSE CONVERT(numeric(15,4),t4.SoldPriceWithoutTax / childPPPB.Balance)
											END
										ELSE NULL
                                    END,
									CASE 
										WHEN t6.ProductType = 1 THEN
											CASE 
												WHEN masterP.ProductType = 2 AND (masterP.ProductSubType = 6 OR masterP.ProductSubType = 8)
													THEN CONVERT(numeric(15,4), childPPPB.FaceValueWithTax * t4.ValueBasedSoldPriceWithTax / masterPPVB.FaceValueWithTax)
												ELSE CONVERT(numeric(15,4),t4.SoldPriceWithTax / childPPPB.Balance)
											END
										ELSE NULL
                                    END,
                                    CASE 
										WHEN t6.ProductType = 2 THEN
											CASE 
												WHEN masterP.ProductType = 2 AND (masterP.ProductSubType = 6 OR masterP.ProductSubType = 8)
													THEN CONVERT(numeric(15,4), childPPVB.FaceValue * t4.ValueBasedSoldPriceWithTax / masterPPVB.FaceValueWithTax)
												ELSE t4.SoldPriceWithoutTax
											END
										ELSE NULL
                                    END,
                                    CASE 
										WHEN t6.ProductType = 2 THEN
											CASE 
												WHEN masterP.ProductType = 2 AND (masterP.ProductSubType = 6 OR masterP.ProductSubType = 8)
													THEN CONVERT(numeric(15,4), childPPVB.FaceValueWithTax * t4.ValueBasedSoldPriceWithTax / masterPPVB.FaceValueWithTax)
												ELSE t4.SoldPriceWithTax
											END
										ELSE NULL
                                    END,
                                    t4.ValidityFrom ,
                                    t4.ValidityEnd ,
                                    t4.Status ,
                                    t4.CreatedBy ,
                                    t4.CreatedOn ,
                                    t4.ApprovedBy ,
                                    t4.ApprovedOn
                            FROM    dbo.ClientQuotation AS t1
                                    JOIN dbo.ClientQuotationProduct AS t2 ON t2.ClientQuotationId = t1.Id
                                    JOIN dbo.ClientQuotationProductCombo AS t3
                                    WITH ( NOLOCK ) ON t3.ClientQuotationProductId = t2.Id
                                    JOIN ClientQuotationProductSoldPrice AS t4 ON t4.ClientQuotationProductId = t2.Id
                                    JOIN dbo.ProductComboSet AS t5 WITH ( NOLOCK ) ON t5.Id = t3.ProductComboSetId
                                    JOIN dbo.Product AS t6 WITH ( NOLOCK ) ON t6.Id = t5.ChildProductId
									JOIN dbo.ProductVersion AS t7 WITH (NOLOCK) on t7.ProductId = t6.Id
											 AND t7.IsCurrentVersion = 1
									JOIN dbo.ProductVersion masterPV WITH(NOLOCK) ON masterPV.Id = t2.ProductVersionId
									JOIN dbo.Product masterP WITH(NOLOCK) ON masterP.Id = masterPV.ProductId
									LEFT JOIN dbo.ProductPricingValueBased masterPPVB WITH(NOLOCK) ON masterPPVB.Id = masterPV.ProductPricingValueBasedId
									LEFT JOIN dbo.ProductPricingValueBased childPPVB WITH(NOLOCK) ON childPPVB.Id = t7.ProductPricingValueBasedId
									LEFT JOIN dbo.ProductPricingProductBased childPPPB WITH(NOLOCK) ON childPPPB.Id = t7.ProductPricingProductBasedId
                            WHERE   t1.QuotationNumber = @QuotationNumber
                                    AND t1.Status = 32
                                    AND t2.Id = @MasterClientQuotationProductId

                    INSERT  INTO [dbo].[ClientQuotationProductSoldPriceHistory]
                            ( ClientQuotationProductId ,
                              OldSoldPrice ,
                              NewSoldPrice ,
                              ApprovedBy ,
                              ApprovedOn ,
                              NewSoldPriceWithTax
                            )
                            SELECT DISTINCT
                                    T2.Id ,
                                    0 ,
                                    ISNULL(T1.SoldPriceWithoutTax,
                                           t1.ValueBasedSoldPriceWithoutTax) ,
                                    'TX2 Product Combo' ,
                                    GETDATE() ,
                                    T1.SoldPriceWithTax
                            FROM    [dbo].[ClientQuotationProductSoldPrice] AS T1
                                    INNER JOIN [dbo].[ClientQuotationProduct]
                                    AS T2 ON T1.ClientQuotationProductId = T2.Id
                                    INNER JOIN [dbo].[ClientQuotation] AS T3 ON T2.ClientQuotationId = T3.Id
                            WHERE   T3.Id = @ChildClientQuotationId

                    INSERT  INTO dbo.ClientQuotationStatusHistory
                            ( ClientQuotationId ,
                              Operation ,
                              Comment ,
                              Operator ,
                              OperationTime
						
                            )
                    VALUES  ( @ChildClientQuotationId ,
                              1 ,
                              N'Created child quotation by tx2' ,
                              N'TX2 Product Combo' ,
                              GETDATE()
                            )

                END TRY
                BEGIN CATCH
                    SET @IsSuccess = 0
                    IF @@TRANCOUNT > 0
                        ROLLBACK TRANSACTION
                    CLOSE db_cursor  
                    DEALLOCATE db_cursor 
                    RETURN
                END CATCH;

                FETCH NEXT FROM db_cursor INTO @MasterClientQuotationProductId 
            END 

        CLOSE db_cursor  
        DEALLOCATE db_cursor 

        SET @IsSuccess = 1


        IF @@TRANCOUNT > 0
            COMMIT TRANSACTION;
    END
