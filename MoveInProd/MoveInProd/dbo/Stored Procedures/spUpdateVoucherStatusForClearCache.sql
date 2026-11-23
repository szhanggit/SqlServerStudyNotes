-- =============================================
-- Author:		Steven Zhang
-- Create date: 2020/07/29
-- Description:	Generate voucher order lines.
-- =============================================
CREATE PROCEDURE spUpdateVoucherStatusForClearCache
	@Table varchar(50),
	@ProductId int,
	@AvailableStartDate varchar(50),
	@AvailableEndDate varchar(50),
	@ExpiryDate varchar(50) = null,
	@TaskId varchar(100)
AS
BEGIN
	BEGIN TRAN    
	BEGIN try   
		---------------------------------
		DECLARE @Sql nvarchar(max);
		DECLARE @CNT int = 0;
		DECLARE @RC INT;

		--https://www.hansmichiels.com/2016/09/18/how-to-protect-your-stored-procedures-against-multiple-concurrent-executions-sql-server-series/
		EXEC @RC = sp_getapplock
			 @Resource = 'StoredProcUsingAppLock',
			 @LockMode = 'Exclusive',
			 @LockOwner = 'Transaction',
			 @LockTimeout = 60000 -- 1 minute 

		IF @RC < 0
		BEGIN
			IF @@TRANCOUNT > 0 ROLLBACK TRAN;
			RETURN @RC
		END 

		if @ExpiryDate is null
		begin	
			insert into TempVoucherBuffer (VoucherNumber, ProgramId, TaskId) 
			select v.VoucherNumber, v.ProgramId, @TaskId as TaskId 
			from Voucher v with(nolock)
            inner join VoucherReservationBatch vrb with(nolock) on v.ReservationBatchId = vrb.Id 
			inner join Product p with(nolock) on v.ProductId = p.Id
            where v.ProductId = @ProductId AND v.[Status] = 256 AND vrb.AvailableStartDate = @AvailableStartDate
            AND vrb.AvailableEndDate = @AvailableEndDate AND (case when p.RequireExpiryDate = 1 then v.ExpiryDate else vrb.ExpiryDate end is null OR case when p.RequireExpiryDate = 1 then v.ExpiryDate else vrb.ExpiryDate end > '2999-01-01');
			
			set @Sql = 'update stock set stock.StockStatus = 0 from '+@Table+' stock with(nolock) 
                    inner join VoucherReservationBatch vrb with(nolock) on stock.ReservationBatchId = vrb.Id 
                    inner join TempVoucherBuffer buf with(nolock) on stock.VoucherNumber = buf.VoucherNumber 
                    AND stock.ProgramId = buf.ProgramId inner join Product p with(nolock) on stock.ProductId = p.Id where stock.ProductId = @ProductId AND stock.StockStatus = 1 
                    AND vrb.AvailableStartDate = @AvailableStartDate AND vrb.AvailableEndDate = @AvailableEndDate
                    AND (case when p.RequireExpiryDate = 1 then stock.ExpiryDate else vrb.ExpiryDate end is null OR case when p.RequireExpiryDate = 1 then stock.ExpiryDate else vrb.ExpiryDate end > ''2999-01-01'') AND buf.TaskId = @TaskId';
		
			exec SP_EXECUTESQL @Sql, N'@AvailableStartDate varchar(50), @AvailableEndDate varchar(50), @ProductId int, @TaskId varchar(50)', @AvailableStartDate=@AvailableStartDate, @AvailableEndDate=@AvailableEndDate, @ProductId=@ProductId, @TaskId=@TaskId;
		end
		else
		begin
			insert into TempVoucherBuffer (VoucherNumber, ProgramId, TaskId) select v.VoucherNumber, v.ProgramId, @TaskId as TaskId from Voucher v with(nolock)
            inner join VoucherReservationBatch vrb with(nolock) on v.ReservationBatchId = vrb.Id inner join Product p with(nolock) on v.ProductId = p.Id
            where v.ProductId = @ProductId AND v.[Status] = 256 AND vrb.AvailableStartDate = @AvailableStartDate
            AND vrb.AvailableEndDate = @AvailableEndDate AND case when p.RequireExpiryDate = 1 then v.ExpiryDate else vrb.ExpiryDate end = @ExpiryDate;
			
			set @Sql = 'update stock set stock.StockStatus = 0 from '+@Table+' stock with(nolock) 
                    inner join VoucherReservationBatch vrb with(nolock) on stock.ReservationBatchId = vrb.Id 
                    inner join TempVoucherBuffer buf with(nolock) on stock.VoucherNumber = buf.VoucherNumber 
                    AND stock.ProgramId = buf.ProgramId inner join Product p with(nolock) on stock.ProductId = p.Id where stock.ProductId = @ProductId AND stock.StockStatus = 1 
                    AND vrb.AvailableStartDate = @AvailableStartDate AND vrb.AvailableEndDate = @AvailableEndDate
                    AND case when p.RequireExpiryDate = 1 then stock.ExpiryDate else vrb.ExpiryDate end = @ExpiryDate AND buf.TaskId = @TaskId';
					
			exec SP_EXECUTESQL @Sql, N'@AvailableStartDate varchar(50), @AvailableEndDate varchar(50), @ProductId int, @TaskId varchar(50), @ExpiryDate varchar(50)', @AvailableStartDate=@AvailableStartDate, @AvailableEndDate=@AvailableEndDate, @ProductId=@ProductId, @TaskId=@TaskId, @ExpiryDate=@ExpiryDate;		
		end
		
		
		
		
		WHILE (1=1) 
        BEGIN 
            update top(1000) TempVoucherBuffer set SessionId = '1' where SessionId is null AND TaskId = @TaskId; 
			set @CNT = @@ROWCOUNT;
			IF(@CNT = 0) 
                BREAK;  
            update v set v.[Status] = 64 from Voucher v with(nolock) 
                inner join TempVoucherBuffer t with(nolock) on v.VoucherNumber = t.VoucherNumber AND v.ProgramId = t.ProgramId 
                where t.SessionId = '1' AND TaskId = @TaskId; 
            update TempVoucherBuffer set SessionId = '2' where SessionId = '1' AND TaskId = @TaskId; 
        END;


		delete vtbuf from TempVoucherBuffer buf with(nolock) 
			inner join Voucher v with(nolock) on buf.VoucherNumber = v.VoucherNumber AND buf.ProgramId = v.ProgramId
			inner join VoucherTrustAccountBuffer vtbuf with(nolock) on vtbuf.VoucherId = v.Id 
			where buf.TaskId = @TaskId;					
		delete from TempVoucherBuffer where TaskId = @TaskId;
		
		---------------------------------	
		COMMIT TRAN;    
		select 0    
	END try  
	begin catch 
		ROLLBACK TRAN   
		select - 1  
	end catch   
END
