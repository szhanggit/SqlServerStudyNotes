CREATE PROCEDURE up_ChangeVoucherProduct
 @OldProductCode varchar(50),
 @NewProductCode varchar(50)
AS
BEGIN
	DECLARE @OldProductId INT
	DECLARE @NewProductId INT

	DECLARE @SelectBatchRowNumber INT
	DECLARE @UpdateBatchRowNumber INT
	DECLARE @SelectVoucherRowNumber INT
	DECLARE @UpdateVoucherRowNumber INT

	SET @OldProductId = 0
	SET @NewProductId = 0

	BEGIN TRAN

	BEGIN TRY
		
		SELECT @OldProductId = Id 
		FROM [dbo].[Product]
		WHERE [ProductCode] = @OldProductCode

		SELECT @NewProductId = Id 
		FROM [dbo].[Product]
		WHERE [ProductCode] = @NewProductCode

		IF @OldProductId = 0
			BEGIN
				PRINT 'Old Product not exist'
				RETURN
			END
	
		IF @OldProductId = 0
		BEGIN
			PRINT 'New Product not exist'
			RETURN
		END

		--1. Set Product to Inactive 
		UPDATE [dbo].[Product]
		SET [Status] = 0
		WHERE [ProductCode] = @OldProductCode;


		SELECT @SelectBatchRowNumber = COUNT(1)
		FROM [dbo].[VoucherReservationBatch]
		WHERE [ProductId] = @OldProductId;

		--2. 更新VoucherReservationBatch
		UPDATE 	[dbo].[VoucherReservationBatch]
		SET [ProductId] = @NewProductId
		WHERE [ProductId] = @OldProductId;

		SET @UpdateBatchRowNumber = @@rowcount;

		IF @SelectBatchRowNumber != @UpdateBatchRowNumber
		BEGIN
			ROLLBACK TRANSACTION;
			PRINT 'Update VoucherReservationBatch Fail';
			RETURN;
		END

		SELECT @SelectVoucherRowNumber = COUNT(1)
		FROM [dbo].[Voucher]
		WHERE [ProductId] = @OldProductId
		AND [Status] = 64;

		--3. 更新Voucher的Product
		UPDATE [dbo].[Voucher]
		SET [ProductId] = @NewProductId
		WHERE [ProductId] = @OldProductId
		AND [Status] = 64
		
		SET @UpdateVoucherRowNumber = @@rowcount;

		IF @SelectVoucherRowNumber != @UpdateVoucherRowNumber
		BEGIN
			ROLLBACK TRANSACTION;
			PRINT 'Update Voucher Fail';
			RETURN;
		END

		COMMIT TRANSACTION;
	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION;
	END CATCH
END

--5. 更新Authorization DB中Account的Procut