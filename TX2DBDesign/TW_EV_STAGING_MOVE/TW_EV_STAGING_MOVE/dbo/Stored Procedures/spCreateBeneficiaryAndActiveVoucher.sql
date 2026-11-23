
CREATE PROCEDURE [dbo].[spCreateBeneficiaryAndActiveVoucher]
    @OrderLineId INT ,
    @Mobile VARCHAR(50) = NULL ,
    @Email VARCHAR(100) = NULL ,
    @VoucherQuantity INT ,
    @ActiveDate DATETIME = NULL ,
    @ExpirySchemeId INT ,
    @ExpiryDate DATETIME = NULL ,
    @ClientOrderNumber VARCHAR(50) = NULL ,
    @Memo NVARCHAR(1000) = NULL ,
    @ProductVersionId INT = NULL ,
    @EmailSubject NVARCHAR(500) = NULL ,
    @VoucherId BIGINT ,
	@AuthCode VARCHAR(10),
    @BeneficiaryInfoId BIGINT OUTPUT ,
    @resultParameter INT OUTPUT
AS
    BEGIN
        SET NOCOUNT ON;

        BEGIN TRAN

        BEGIN TRY

            INSERT  INTO dbo.OrderBeneficiaryInfo
                    ( OrderLineId ,
                      Mobile ,
                      Email ,
                      VoucherQuantity ,
                      ActiveDate ,
                      ExpirySchemeId ,
                      ExpiryDate ,
                      ClientOrderNumber ,
                      Memo ,
                      ProductVersionId 
		            )
            VALUES  ( @OrderLineId ,
                      @Mobile ,
                      @Email ,
                      @VoucherQuantity ,
                      @ActiveDate ,
                      @ExpirySchemeId ,
                      @ExpiryDate ,
                      @ClientOrderNumber ,
                      @Memo ,
                      @ProductVersionId 
		            )

            SELECT  @BeneficiaryInfoId = SCOPE_IDENTITY()

            INSERT  INTO dbo.OrderBeneficiaryInfoExtra
                    ( Id ,
                      EmailSubject ,
                      CreatedOn ,
                      IsServiceFeeCalculated
		            )
            VALUES  ( @BeneficiaryInfoId ,
                      @EmailSubject ,
                      GETDATE() ,
                      0
		            )

            UPDATE  Voucher
            SET     BeneficiaryInfoId = @BeneficiaryInfoId ,
                    Status = 2,
					AuthCode = @AuthCode
            WHERE   Id = @VoucherId

        END TRY

        BEGIN CATCH
            ROLLBACK TRAN

            SELECT  @resultParameter = -1
        END CATCH
      

        IF @@ERROR <> 0
            BEGIN
                ROLLBACK TRAN

                SELECT  @resultParameter = -1
            END
        ELSE
            BEGIN
                COMMIT TRAN

                SELECT  @resultParameter = 1
            END
    END
