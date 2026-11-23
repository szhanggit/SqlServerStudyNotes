
CREATE PROCEDURE [dbo].[spInsertProduct]
    @ProgramCode VARCHAR(20) ,
    @VendorCode VARCHAR(50) ,
    @ProductCode VARCHAR(50) ,
    @VendorProductCode NVARCHAR(200) ,
    @ProductName NVARCHAR(200) = NULL ,
    @CurrencyCode NVARCHAR(50) = NULL ,
    @Amount VARCHAR(50) = NULL,
	@CountryCode VARCHAR(50) = NULL,
	@Rsv1 NVARCHAR(50) = NULL
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        DECLARE @VendorId INT
        SELECT  @VendorId = Id
        FROM    dbo.Vendor
        WHERE   ProgramCode = @ProgramCode
                AND VendorCode = @VendorCode
		
        IF @VendorId IS NOT NULL
            BEGIN

                IF ( NOT EXISTS ( SELECT    *
                                  FROM      dbo.Vendor AS t1 WITH ( NOLOCK )
                                            JOIN dbo.Product AS t2 WITH ( NOLOCK ) ON t2.VendorId = t1.Id
                                  WHERE     t1.ProgramCode = @ProgramCode
                                            AND t1.VendorCode = @VendorCode
                                            AND t2.ProductCode = @ProductCode )
                   )
                    BEGIN
                        INSERT  INTO dbo.Product
                                ( ProgramCode ,
                                  VendorId ,
                                  ProductCode ,
                                  VendorProductCode ,
                                  ProductName ,
                                  CurrencyCode ,
								  CountryCode,
                                  Amount ,
								  Rsv1,
                                  Status
                                )
                        VALUES  ( @ProgramCode ,
                                  @VendorId ,
                                  @ProductCode ,
                                  @VendorProductCode ,
                                  @ProductName ,
                                  @CurrencyCode ,
								  @CountryCode,
                                  @Amount ,
								  @Rsv1,
                                  1
                                )
                    END
                ELSE
                    BEGIN
                        UPDATE  dbo.Product
                        SET     VendorProductCode = @VendorProductCode ,
                                ProductName = @ProductName ,
                                Amount = @Amount,
								CurrencyCode = @CurrencyCode,
								CountryCode = @CountryCode,
								Rsv1 = @Rsv1
                        WHERE   ProgramCode = @ProgramCode
                                AND VendorId = @VendorId
                                AND ProductCode = @ProductCode

                    END

            END

    END

