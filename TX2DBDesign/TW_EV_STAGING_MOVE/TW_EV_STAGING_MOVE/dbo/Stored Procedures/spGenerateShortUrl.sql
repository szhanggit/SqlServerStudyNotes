CREATE PROCEDURE [dbo].[spGenerateShortUrl]
    @SessionId VARCHAR(50) ,
    @ShortUrlAuthCodeGenerationWay TINYINT ,
    @ReturnCode VARCHAR(20) OUTPUT
AS
BEGIN
	set nocount on;
    BEGIN TRY	
    BEGIN TRANSACTION
        INSERT INTO StockShortUrl(VoucherId ,VoucherAlias ,AuthCode)
			SELECT VoucherId ,VoucherAlias ,AuthCode FROM StockShortUrlTemp WHERE SessionId = @SessionId;
		DELETE temp from StockShortUrlTemp temp join StockShortUrl u on u.VoucherId = temp.VoucherId WHERE SessionId = @SessionId;
		select VoucherId from StockShortUrlTemp where SessionId = @SessionId;
		SET @ReturnCode = IIF(exists(select 1 from StockShortUrlTemp where SessionId = @SessionId),'1','0')
		DELETE from StockShortUrlTemp WHERE SessionId = @SessionId;
		COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        SET @ReturnCode = '3'
        ROLLBACK TRANSACTION;
    END CATCH
END
