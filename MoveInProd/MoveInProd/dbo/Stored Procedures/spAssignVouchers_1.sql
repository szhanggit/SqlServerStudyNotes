-- =============================================
-- Author:		Knight YAO
-- Create date: 2014/12/18
-- Description:	Assign voucher.
-- =============================================
CREATE PROCEDURE [dbo].[spAssignVouchers]
	@OrderLineId				INT,
	@ProductId					INT,
	@IsSuccess					BIT		OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	BEGIN TRAN

	BEGIN TRY
		DECLARE @MaxQuantity as int
		declare @ToAssignNumber as int
		create table #seed (id int)

		select t2.Id as BenId, (t2.VoucherQuantity-isnull(t3.AssignedQuantity,0)) as ToAssignQuantity
		into #BensToAssign
		from OrderBeneficiaryInfo t2
		left join 
			 (select obi.Id as BenId,count(v.Id) as AssignedQuantity
		      from OrderBeneficiaryInfo obi
		      join Voucher v on obi.Id=v.BeneficiaryInfoId
	          where obi.OrderLineId = @OrderLineId
		      group by obi.Id
		) t3 on t2.Id = t3.BenId
		where (t2.VoucherQuantity-isnull(t3.AssignedQuantity,0)) >0 
		and t2.OrderLineId = @OrderLineId

		select @MaxQuantity = max(ToAssignQuantity)
		from #BensToAssign

		select @ToAssignNumber = sum(ToAssignQuantity)
		from #BensToAssign
		where ToAssignQuantity > 0

		if(@MaxQuantity<=0)
		begin
		   SET @IsSuccess = 1
		   return
		end

		while(@MaxQuantity > 0)
		begin
		  insert into #seed values(@MaxQuantity)
		  set @MaxQuantity = @MaxQuantity -1
		end	

		DECLARE @VoucherReservationCodeId int

		select @VoucherReservationCodeId = ol.VoucherReservationCodeId
		from  OrderLine ol
		where ol.Id = @OrderLineId

		update t0
		set t0.BeneficiaryInfoId=t2.BenId
		from Voucher t0
			join
			(select ROW_NUMBER() OVER(ORDER BY v.Id ) AS RowId, v.Id 
			 from Voucher v 
			 inner join VoucherReservationBatch b on v.ReservationBatchId = b.Id
			 inner join VoucherReservationCode c on b.VoucherReservationCodeId = c.Id	 
			 where v.Status=64 
			   and v.ProductId = @ProductId
			   and v.BeneficiaryInfoId is null
			   and c.Id = @VoucherReservationCodeId
			) t1 on t0.Id = t1.Id
			join
			(select ROW_NUMBER() OVER(ORDER BY BenId ) AS RowId, * 
			 from #seed s 
				  cross join #BensToAssign b 
			 where s.id <= b.ToAssignQuantity
			 ) t2 on t1.RowId = t2.RowId 
		 where t0.Status=64 
		   and t0.BeneficiaryInfoId is null

	
	    if(@@ROWCOUNT <> @ToAssignNumber)
		   set @IsSuccess = 0
		else
		   SET @IsSuccess = 1
		
	END TRY
	BEGIN CATCH
		SET @IsSuccess = 0
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
	END CATCH;

	IF @@TRANCOUNT > 0
		COMMIT TRANSACTION;
END

