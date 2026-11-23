
CREATE PROCEDURE [dbo].[spGetProductVoucherSupplierOperationParameter]
    @VoucherSupplierId INT ,
    @ProductId INT
AS
    BEGIN

        SELECT  t1.OperationCode ,
                t2.Name ,
                t3.ParameterValue
        FROM    dbo.VoucherSupplierOperation AS t1 WITH ( NOLOCK )
                JOIN dbo.VoucherSupplierOperationParameter AS t2 WITH ( NOLOCK ) ON t2.VoucherSupplierOperationId = t1.Id
                JOIN dbo.ProductVoucherSupplierOperationParameter AS t3 WITH ( NOLOCK ) ON t3.VoucherSupplierOperationParameterId = t2.Id
        WHERE   VoucherSupplierId = @VoucherSupplierId
                AND ProductId = @ProductId
 
    END
    
