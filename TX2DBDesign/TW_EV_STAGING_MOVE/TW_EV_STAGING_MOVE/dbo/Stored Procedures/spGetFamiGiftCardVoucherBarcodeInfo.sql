CREATE PROCEDURE [dbo].[spGetFamiGiftCardVoucherBarcodeInfo]
    @VoucherNumber varchar(50)
AS
    BEGIN
        SET NOCOUNT ON;
		
        SELECT  ISNULL(fgc.Barcode1,'') as Barcode1,
                ISNULL(fgc.Barcode2,'') as Barcode2
        FROM    
            EXT_FamiGiftcard fgc with(nolock)
        WHERE   
		    fgc.Barcode1 = @VoucherNumber
    END