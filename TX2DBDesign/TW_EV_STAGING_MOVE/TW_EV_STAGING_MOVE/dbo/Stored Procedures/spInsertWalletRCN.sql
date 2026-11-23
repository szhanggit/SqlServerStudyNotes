
CREATE PROCEDURE [dbo].[spInsertWalletRCN]
@WalletAlias varchar(20),
@WalletCode varchar(20),
@OrderId int,
@WalletGroupBy int,
@ClientOrderLineId int
AS
BEGIN
	BEGIN TRAN
	BEGIN TRY
		INSERT INTO Wallet ([WalletAlias], [WalletCode], [GUID], [OrderId], [WalletGroupBy], [CreatedOn])
		VALUES (@WalletAlias, @WalletCode, NEWID(), @OrderId, @WalletGroupBy, GETDATE())

		DECLARE @WalletId bigint = SCOPE_IDENTITY()
		
		IF EXISTS(SELECT 1 FROM EMV_VoucherClientOrder WHERE ClientOrderLineId = @ClientOrderLineId)
		BEGIN
			INSERT INTO WalletCombo ([WalletId], [VoucherId])
			SELECT @WalletId, V.Id
			FROM EMV_VoucherClientOrder O
			INNER JOIN Voucher V ON O.ProgramId = V.ProgramId AND O.VoucherNumber = V.VoucherNumber
			WHERE O.ClientOrderLineId = @ClientOrderLineId
			
			UPDATE EMV_VoucherClientOrder SET WalletId = @WalletId
			WHERE ClientOrderLineId = @ClientOrderLineId
		END
		ELSE
		BEGIN
			INSERT INTO WalletCombo ([WalletId], [VoucherId])
			SELECT @WalletId, V.Id
			FROM EMV_ClientOrderLine COL
			INNER JOIN [Order] O ON COL.OrderNumber = O.OrderNumber
			INNER JOIN OrderLine OL ON O.Id = OL.OrderId
			INNER JOIN ClientQuotationProduct CQP ON COL.ClientQuotationProductId = CQP.Id AND OL.ClientQuotationProductId = CQP.Id
			INNER JOIN VoucherOrder VO ON O.Id = VO.OrderId AND OL.Id = VO.OrderLineId
			INNER JOIN OrderBeneficiaryInfo OBI ON VO.OrderBeneficiaryInfoId = OBI.Id AND OL.Id = OBI.OrderLineId AND COL.RCN = OBI.Memo
			INNER JOIN Voucher V ON VO.VoucherId = V.Id
			WHERE COL.Id = @ClientOrderLineId
		END
		
		COMMIT TRAN;
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN;
	END CATCH
END
