	
CREATE PROCEDURE spMaskedEXT_GR_VoucherInfo
	-- Add the parameters for the stored procedure here
		@vendor_code varchar(50),
		@IsSuccess					BIT		OUTPUT
		
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	BEGIN TRAN

	BEGIN TRY
		set @IsSuccess =0

		select 
		ecode as VoucherNumber ,
		RequestId,
		ExtendId
		into #VoucherList
		from EXT_GR_VoucherInfo as EXT with(nolock)
		inner join(SELECT 
		VoucherGUID as GUID, RequestId, VoucherNumber,ActivatedOn, ExtendId
		FROM RequestRelatedToVouchersRecord as RR with(NOLOCK) 
		inner join Voucher  as v  with(nolock) on v.GUID = RR.VoucherGUID
		where VendorCode = @vendor_code and DATEDIFF(month, ActivatedOn, GETDATE()) > =6) as BB_vdetails on BB_vdetails.ExtendId = EXT.id
		where EXT.MaskDateTime is null


		declare @RequestID varchar(100)
		declare @VoucherNumber varchar(100)
		declare @ExtendId bigint
		IF NOT EXISTS (SELECT 1 FROM #VoucherList)
		  BEGIN 
			set @IsSuccess =  1
		  END 
		ELSE
		  BEGIN
			while exists (select  RequestId, VoucherNumber, ExtendId from #VoucherList)
			begin

				select top 1 
				@RequestId = RequestId
				,@VoucherNumber = VoucherNumber
				,@ExtendId = ExtendId

				from #VoucherList


				update EXT_GR_VoucherInfo
				set ecode = FORMAT(getdate(),'yyyyMMdd'), MaskDateTime = getdate()
				where ecode = @VoucherNumber and id = @ExtendId

				update [dbo].[APILog]
				SET ResponseMessage = replace(ResponseMessage , @VoucherNumber, FORMAT(getdate(),'yyyyMMdd'))
				where RequestId = @RequestID

				update [dbo].[VoucherSupplierAPILog_TPC]
				SET ResponseMessage = replace(ResponseMessage , @VoucherNumber, FORMAT(getdate(),'yyyyMMdd'))
				where RequestId = @RequestID

				delete #VoucherList
				where 
				RequestId = @RequestId
				and	VoucherNumber = @VoucherNumber


			end
			
				set @IsSuccess =  1
		  END

			


		
	END TRY
	BEGIN CATCH
		SET @IsSuccess = 0
			IF @@TRANCOUNT > 0
				ROLLBACK TRANSACTION;
	END CATCH;
	
	IF @@TRANCOUNT > 0
		COMMIT TRANSACTION;

	DROP table #VoucherList
END
