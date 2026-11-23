CREATE PROCEDURE [dbo].[spVoucherStockMovingDesignated]
@DestinationProductCode VARCHAR(100),
@VoucherNumber VARCHAR (100),
@ExpiryDate DATETIME = null,
@TicketNumber nvarchar(500),
@ProductID INT,
@ProgramId INT,
@ErrorMessage NVARCHAR(4000) OUTPUT
AS
BEGIN

SET NOCOUNT ON;



DECLARE @BatchNo VARCHAR(20);
DECLARE @Random INT;
SET @Random = CRYPT_GEN_RANDOM(3) % 9000;
SET @BatchNo = @DestinationProductCode + CONVERT(varchar(10), @Random);
DECLARE @GUID varchar(1000);
set @GUID = NewID();
DECLARE @SourceVoucherReservationBatchId int;
DECLARE @NewVoucherReservationBatchId int;
DECLARE @AvailableStartDate INT;
DECLARE @AvailableEndDate INT;

BEGIN TRAN
BEGIN TRY
if exists (select 1 from VoucherStock_A stock with(nolock)
inner join VoucherReservationBatch vrb with(nolock) on stock.ReservationBatchId = vrb.Id AND stock.StockStatus = 0
where stock.VoucherNumber = @VoucherNumber)
begin
select @SourceVoucherReservationBatchId = vrb.Id, @AvailableStartDate = vrb.AvailableStartDate, @AvailableEndDate = vrb.AvailableEndDate from VoucherStock_A stock with(nolock)
inner join VoucherReservationBatch vrb with(nolock) on stock.ReservationBatchId = vrb.Id AND stock.StockStatus = 0
where stock.VoucherNumber = @VoucherNumber



INSERT INTO dbo.VoucherReservationBatch
( BatchNo ,
VoucherCount ,
VoucherReservationCodeId ,
[Description] ,
CreatedOn ,
ProductId ,
[ExpiryDate],
[AvailableStartDate],
[AvailableEndDate]
)
VALUES
( @BatchNo , -- BatchNo - varchar(20)
1 , -- VoucherCount - int
1 , -- VoucherReservationCodeId - int
@TicketNumber , -- Description-- ticket number - nvarchar(500)
GETDATE() , -- CreatedOn - datetime
@ProductID, -- ProductId - int
@ExpiryDate,
@AvailableStartDate,
@AvailableEndDate )


set @NewVoucherReservationBatchId = SCOPE_IDENTITY();


INSERT INTO [dbo].[VoucherMovingLog]([VoucherReservationBatchId], [Amount], [Increase], [GUID], [DateTime])
VALUES (@NewVoucherReservationBatchId, 1, 1, @GUID, GETDATE());

UPDATE VoucherStock_A
set ProductId = @ProductID,
ReservationBatchId = @NewVoucherReservationBatchId
WHERE VoucherNumber = @VoucherNumber AND ProgramId = @ProgramId

INSERT INTO [dbo].[VoucherMovingLog]([VoucherReservationBatchId], [Amount], [Increase], [GUID], [DateTime])
VALUES (@SourceVoucherReservationBatchId, 1, -1, @GUID, GETDATE());

UPDATE VoucherReservationBatch
SET VoucherCount = VoucherCount - 1
WHERE Id = @SourceVoucherReservationBatchId
end







COMMIT TRANSACTION;
END TRY
BEGIN CATCH
SELECT @ErrorMessage = ERROR_MESSAGE();
IF @@TRANCOUNT > 0
ROLLBACK TRANSACTION;
END CATCH;
END