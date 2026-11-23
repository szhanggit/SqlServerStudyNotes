CREATE PROCEDURE [order].[sp_ins_insert_wallet_link]
	@IsSuccess bit output,
	@ErrorMessage nvarchar(250) output,
@WalletAlias nvarchar(20),
@WalletCode nvarchar(20),
@RCN nvarchar(100),
@BeneficiaryInfoId bigint,
@OrderId int,
@WalletGroupBy int
AS
BEGIN
	SET XACT_ABORT ON;

	BEGIN TRY

	    BEGIN TRANSACTION;
		
		SET @IsSuccess = 0;
		SET @ErrorMessage = null;

		INSERT INTO tb_w_wallet ([wallet_alias], [wallet_code], [guid], [rcn], [order_id], [wallet_group_by], [CreatedOn])
		VALUES (@WalletAlias, @WalletCode, NEWID(), @RCN, @OrderId, @WalletGroupBy, GETDATE())

		DECLARE @WalletId bigint = SCOPE_IDENTITY()

		INSERT INTO tb_wc_wallet_combo ([wallet_id], [voucher_id])
		SELECT @WalletId, V.Id
		FROM tb_vc_voucher_core v WITH(nolock) 
		WHERE v.beneficiary_id = @BeneficiaryInfoId

		IF @@ROWCOUNT > 0
			BEGIN
		SET @IsSuccess = 1;

	END
		ELSE
			BEGIN
		SET @ErrorMessage = 'failed to insert wallet link';
	END

		stop_process:

		IF @IsSuccess = 0
			BEGIN
		ROLLBACK TRANSACTION;
	END
        ELSE
			BEGIN
		COMMIT TRANSACTION;
	END
	END TRY
	BEGIN CATCH
       IF @@TRANCOUNT > 0
       BEGIN
		ROLLBACK TRANSACTION
	END;

	   THROW;
	END CATCH
END