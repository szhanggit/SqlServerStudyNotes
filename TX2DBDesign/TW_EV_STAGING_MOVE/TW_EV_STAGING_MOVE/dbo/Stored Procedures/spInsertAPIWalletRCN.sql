
CREATE PROCEDURE [dbo].[spInsertAPIWalletRCN]
@WalletAlias varchar(20),
@WalletCode varchar(20),
@OrderId int,
@WalletGroupBy int,
@EXT_IN_APIOrderInfoId int
AS
BEGIN
	BEGIN TRAN
	BEGIN TRY
		INSERT INTO Wallet ([WalletAlias], [WalletCode], [GUID], [OrderId], [WalletGroupBy], [CreatedOn])
		VALUES (@WalletAlias, @WalletCode, NEWID(), @OrderId, @WalletGroupBy, GETDATE())

		DECLARE @WalletId bigint = SCOPE_IDENTITY()

		INSERT INTO WalletCombo ([WalletId], [VoucherId])
		SELECT @WalletId, V.Id
		FROM EXT_IN_APIOrderInfo O
		INNER JOIN OrderBeneficiaryInfo OBI ON O.OrderBeneficiaryInfoId = OBI.Id
		INNER JOIN Voucher V ON OBI.Id = V.BeneficiaryInfoId
		WHERE O.Id = @EXT_IN_APIOrderInfoId

		COMMIT TRAN;
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN;
	END CATCH
END
