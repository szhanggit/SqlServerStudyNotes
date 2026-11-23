
CREATE PROCEDURE dbo.spVoucherStockMoving 
@SourceProductCode VARCHAR(100), 
@DestinationProductCode VARCHAR(100), 

@SExpiryDate DATETIME = null, 
@SAvailableStartDate int, 
@SAvailableEndDate int, 


@RequiredAmount INT,
@ExpiryDate DATETIME = null, 
@AvailableStartDate DATETIME, 
@AvailableEndDate DATETIME, 
@ResponseCode VARCHAR(10) OUTPUT,
@ErrorMessage NVARCHAR(4000) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

----------------------------------------------------	
DECLARE @GUID varchar(1000);
set @GUID = NewID();
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = N'VoucherMovingLog')
BEGIN
    CREATE TABLE [dbo].[VoucherMovingLog](
	Id INT PRIMARY KEY IDENTITY (1, 1),
	[VoucherReservationBatchId] [int] NULL,
	[Amount] [int] NULL,
	[Increase] [int] NULL,
	[GUID] VARCHAR(1000) NOT NULL,
	[DateTime] DATETIME NOT null
) 
END


--Msg:
--E0001	Source Product cannot be empty.
--E0002	Destination Product cannot be empty.
--E0003 Amount cannot be less than or equal to zero.
--E0004	They are in different program.
--E0005	Cannot find the available source batch.
--E0006 Available StartDate cannot be null.
--E0007 Available EndDate cannot be null.
--E0008 Do not have enough vouchers.
--Init
DECLARE @SExpiryDateStr VARCHAR(50) = CONVERT(varchar, @SExpiryDate, 23);
DECLARE @ExpiryDateStr VARCHAR(50) = CONVERT(varchar, @ExpiryDate, 23);
DECLARE @SourceProductId INT;
DECLARE @DestinationProductId INT;
DECLARE @SourceProgramId INT;
DECLARE @DestinationProgramId INT;
DECLARE @SourceStockTable VARCHAR(100);
DECLARE @DestinationStockTable VARCHAR(100);
DECLARE @VoucherReservationCodeId INT;
DECLARE @VoucherReservationBatchId INT;
DECLARE @NewVoucherReservationBatchId INT;
DECLARE @BatchNo VARCHAR(20);
DECLARE @AvailableStartDateStr VARCHAR(8);
DECLARE @AvailableEndDateStr VARCHAR(8);
DECLARE @AvailableStartDateInt INT;
DECLARE @AvailableEndDateInt INT;
DECLARE @TotalAvailableVoucherNum INT;
SET @TotalAvailableVoucherNum = 0;
DECLARE @Random INT;
SET @Random = CRYPT_GEN_RANDOM(3) % 9000;
SET @BatchNo = @DestinationProductCode + CONVERT(varchar(10), @Random);

	DECLARE @Updated table( 
    [VoucherNumber] varchar(100),
    [ProgramId] int);
	CREATE TABLE #TempVoucher (
    [VoucherNumber] varchar(100),
    [ProgramId] int);

--Product Code Processing
IF @SourceProductCode IS NOT NULL AND @SourceProductCode != ''
BEGIN
	SELECT @SourceProductId = Id, @SourceProgramId = ProgramId FROM Product WITH(nolock) WHERE ProductCode = @SourceProductCode;
END
ELSE
BEGIN
	set @ResponseCode = 'E0001';
	RETURN;
END

IF @DestinationProductCode IS NOT NULL AND @DestinationProductCode != ''
BEGIN
	SELECT @DestinationProductId = Id, @DestinationProgramId = ProgramId FROM Product WITH(nolock) WHERE ProductCode = @DestinationProductCode;
END
ELSE
BEGIN
	set @ResponseCode = 'E0002';
	RETURN;
END

IF @RequiredAmount <= 0
BEGIN
	set @ResponseCode = 'E0003';
	RETURN;
END

--Check Program Id
IF @SourceProgramId != @DestinationProgramId
BEGIN
	set @ResponseCode = 'E0004';
	RETURN;
END
SELECT @SourceStockTable = VoucherStockTableName FROM dbo.ProgramVoucherRoute WITH(nolock) WHERE ProgramId = @SourceProgramId;
SELECT @DestinationStockTable = VoucherStockTableName FROM dbo.ProgramVoucherRoute WITH(nolock) WHERE ProgramId = @DestinationProgramId;

------------------------------
--Dates Processing
if @SExpiryDate = '1900-01-01 00:00:00'
begin
	SET @SExpiryDate = '1900-01-01 00:00:00';
	SET @SExpiryDateStr = '1900-01-01 00:00:00';
end
ELSE IF @SExpiryDate IS NULL OR @SExpiryDate = ''
BEGIN
	SET @SExpiryDate = NULL;
	SET @SExpiryDateStr = 'Empty';
END

IF @SAvailableStartDate IS NULL OR @SAvailableStartDate = ''
BEGIN
	set @ResponseCode = 'E1006';
	RETURN;
END

IF @SAvailableEndDate IS NULL OR @SAvailableEndDate = ''
BEGIN
	set @ResponseCode = 'E1007';
	RETURN;
END


------------------------------

--Dates Processing
IF @ExpiryDate IS NOT NULL and (@ExpiryDate != '' OR @ExpiryDate = '1900-01-01')
BEGIN
	SET @ExpiryDate = @ExpiryDate;
END
ELSE
BEGIN
	SET @ExpiryDate = NULL;
	SET @ExpiryDateStr = 'Empty';
END

IF @AvailableStartDate IS NOT NULL AND (@AvailableStartDate != '' OR @AvailableStartDate = '1900-01-01')
BEGIN
	SET @AvailableStartDateStr = CONVERT(VARCHAR(8), @AvailableStartDate, 112);
	SET @AvailableStartDateInt = CAST(CAST (@AvailableStartDateStr AS NUMERIC(19,4)) AS INT);
END
ELSE
BEGIN
	set @ResponseCode = 'E0006';
	RETURN;
END

IF @AvailableEndDate IS NOT NULL AND (@AvailableEndDate != '' OR @AvailableEndDate = '1900-01-01')
BEGIN
	SET @AvailableEndDateStr = CONVERT(VARCHAR(8), @AvailableEndDate, 112);
	SET @AvailableEndDateInt = CAST(CAST (@AvailableEndDateStr AS NUMERIC(19,4)) AS INT);
END
ELSE
BEGIN
	set @ResponseCode = 'E0007';
	RETURN;
END

--Check the available vouchers
DECLARE @TotalAvailableVoucherCheckSql NVARCHAR(max);
SET @TotalAvailableVoucherCheckSql = 'SELECT @OutTotalAvailableVoucherNum = COUNT(*) FROM VoucherReservationBatch vrb WITH(nolock) 
INNER JOIN '+@SourceStockTable+' stock WITH(nolock) ON vrb.Id = stock.ReservationBatchId
WHERE vrb.ProductId = @SourceProductId AND stock.StockStatus = 0';
exec SP_EXECUTESQL @TotalAvailableVoucherCheckSql, N'@SourceProductId int, @OutTotalAvailableVoucherNum int output', @SourceProductId=@SourceProductId, @OutTotalAvailableVoucherNum=@TotalAvailableVoucherNum OUTPUT;



IF @TotalAvailableVoucherNum > 0
BEGIN
	CREATE TABLE #TempTable (
		Id INT PRIMARY KEY IDENTITY (1, 1),
		VoucherReservationBatchId INT,
		BatchNo VARCHAR(100),
		Code INT,
		Num INT
	);

	DECLARE @CreateTempTableSql NVARCHAR(max);
	
	if @SExpiryDate is null AND @SExpiryDateStr != '1900-01-01'
	begin
		SET @CreateTempTableSql = '
			INSERT INTO #TempTable (VoucherReservationBatchId, BatchNo, Num, Code)
			SELECT MAX(T.Id) AS VoucherReservationBatchId, T.BatchNo, COUNT(*) AS Num, MAX(T.VoucherReservationCodeId) As Code FROM 
			(
			select top(@RequiredAmount) * from (
			SELECT  b.Id, b.BatchNo, b.VoucherCount, b.VoucherReservationCodeId, b.AvailableStartDate, b.AvailableEndDate, (case when p.RequireExpiryDate != 1 then b.ExpiryDate else stock.ExpiryDate end) as ExpiryDate, Stock.VoucherNumber
						FROM    VoucherReservationBatch b WITH ( NOLOCK ) 
											JOIN VoucherReservationCode code WITH(NOLOCK) ON code.Id = b.VoucherReservationCodeId
											join Product p with(nolock) ON b.ProductId = p.Id
											LEFT JOIN '+@SourceStockTable+' stock WITH (NOLOCK) ON stock.ReservationBatchId = b.Id AND stock.StockStatus = 0 and stock.ProductId = @SourceProductId
						WHERE b.ProductId = @SourceProductId) tem
			WHERE tem.AvailableStartDate = @SAvailableStartDate AND tem.AvailableEndDate = @SAvailableEndDate AND tem.VoucherNumber is not null AND tem.ExpiryDate is null order by BatchNo
			) AS [T] GROUP BY T.BatchNo
		';
		exec SP_EXECUTESQL @CreateTempTableSql, N'@SourceProductId int, @RequiredAmount int, @SAvailableStartDate varchar(50), @SAvailableEndDate varchar(50)', 
		@SourceProductId=@SourceProductId, @RequiredAmount=@RequiredAmount, @SAvailableStartDate=@SAvailableStartDate, @SAvailableEndDate=@SAvailableEndDate;
	end
	else
	begin
		SET @CreateTempTableSql = '
			INSERT INTO #TempTable (VoucherReservationBatchId, BatchNo, Num, Code)
			SELECT MAX(T.Id) AS VoucherReservationBatchId, T.BatchNo, COUNT(*) AS Num, MAX(T.VoucherReservationCodeId) As Code FROM 
			(
			select top(@RequiredAmount) * from (
			SELECT  b.Id, b.BatchNo, b.VoucherCount, b.VoucherReservationCodeId, b.AvailableStartDate, b.AvailableEndDate, (case when p.RequireExpiryDate != 1 then b.ExpiryDate else stock.ExpiryDate end) as ExpiryDate, Stock.VoucherNumber
						FROM    VoucherReservationBatch b WITH ( NOLOCK ) 
											JOIN VoucherReservationCode code WITH(NOLOCK) ON code.Id = b.VoucherReservationCodeId
											join Product p with(nolock) ON b.ProductId = p.Id
											LEFT JOIN '+@SourceStockTable+' stock WITH (NOLOCK) ON stock.ReservationBatchId = b.Id AND stock.StockStatus = 0 and stock.ProductId = @SourceProductId
						WHERE b.ProductId = @SourceProductId) tem 
			WHERE tem.AvailableStartDate = @SAvailableStartDate AND tem.AvailableEndDate = @SAvailableEndDate AND tem.VoucherNumber is not null AND tem.ExpiryDate = @SExpiryDate order by BatchNo
			) AS [T] GROUP BY T.BatchNo
		';
		exec SP_EXECUTESQL @CreateTempTableSql, N'@SourceProductId int, @RequiredAmount int, @SAvailableStartDate varchar(50), @SAvailableEndDate varchar(50), @SExpiryDate DateTime', 
		@SourceProductId=@SourceProductId, @RequiredAmount=@RequiredAmount, @SAvailableStartDate=@SAvailableStartDate, @SAvailableEndDate=@SAvailableEndDate, @SExpiryDate=@SExpiryDate;
	end
	
	BEGIN TRAN
	BEGIN TRY
	UPDATE vrb
	SET vrb.VoucherCount = vrb.VoucherCount - t.Num
	FROM #TempTable t WITH(nolock) 
	LEFT JOIN VoucherReservationBatch vrb WITH(nolock) ON t.VoucherReservationBatchId = vrb.Id;

	SELECT @VoucherReservationCodeId = vrb.VoucherReservationCodeId
	FROM #TempTable t WITH(nolock) 
	LEFT JOIN VoucherReservationBatch vrb WITH(nolock) ON t.VoucherReservationBatchId = vrb.Id 
	WHERE t.Id = 1;
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
          @RequiredAmount  , -- VoucherCount - int
          @VoucherReservationCodeId , -- VoucherReservationCodeId - int
          @BatchNo  , -- Description - nvarchar(500)
          GETDATE() , -- CreatedOn - datetime
          @DestinationProductId,  -- ProductId - int
		  @ExpiryDate,
		  @AvailableStartDateInt,
		  @AvailableEndDateInt
        )

	set @NewVoucherReservationBatchId = SCOPE_IDENTITY();
    INSERT INTO [dbo].[VoucherMovingLog]([VoucherReservationBatchId], [Amount], [Increase], [GUID], [DateTime])
	VALUES (@NewVoucherReservationBatchId, @RequiredAmount, 1, @GUID, GETDATE());

	DECLARE @EachTopAmount INT;
	DECLARE @BusinessCursor as CURSOR;
	DECLARE @LoopVoucherReservationBatchId INT;
	SET @BusinessCursor = CURSOR FOR
	select VoucherReservationBatchId from #TempTable
	OPEN @BusinessCursor;
	FETCH NEXT FROM @BusinessCursor INTO @LoopVoucherReservationBatchId;
	WHILE @@FETCH_STATUS = 0
	BEGIN
	-------------
	SET @EachTopAmount = 0;
	SELECT @EachTopAmount = Num FROM #TempTable WITH(nolock) WHERE VoucherReservationBatchId = @LoopVoucherReservationBatchId;


	DECLARE @StockUpdatingSql NVARCHAR(max);
	if @ExpiryDate is null
	begin	
	SET @StockUpdatingSql = '
			UPDATE TOP (@RequiredAmount) '+@SourceStockTable+'
			set ProductId = @DestinationProductId,
			ReservationBatchId = @NewVoucherReservationBatchId
			OUTPUT deleted.VoucherNumber, deleted.ProgramId
			INTO #TempVoucher
			WHERE ProductId = @SourceProductId
			AND StockStatus  = 0
			AND ReservationBatchId = @VoucherReservationBatchId
	';

	exec SP_EXECUTESQL @StockUpdatingSql, 
	N'@RequiredAmount int, @DestinationProductId int, @NewVoucherReservationBatchId int, @SourceProductId int, @VoucherReservationBatchId int', 
	@RequiredAmount=@EachTopAmount, @DestinationProductId=@DestinationProductId, @NewVoucherReservationBatchId=@NewVoucherReservationBatchId,
	@SourceProductId=@SourceProductId, @VoucherReservationBatchId=@LoopVoucherReservationBatchId;

	end
	else
	begin
	SET @StockUpdatingSql = '
			UPDATE TOP (@RequiredAmount) '+@SourceStockTable+'
			set ProductId = @DestinationProductId,
			ReservationBatchId = @NewVoucherReservationBatchId,
			ExpiryDate = @ExpiryDate
			OUTPUT deleted.VoucherNumber, deleted.ProgramId
			INTO #TempVoucher
			WHERE ProductId = @SourceProductId
			AND StockStatus  = 0
			AND ReservationBatchId = @VoucherReservationBatchId
	';

	exec SP_EXECUTESQL @StockUpdatingSql, 
	N'@RequiredAmount int, @DestinationProductId int, @NewVoucherReservationBatchId int, @ExpiryDate DateTime, @SourceProductId int, @VoucherReservationBatchId int', 
	@RequiredAmount=@EachTopAmount, @DestinationProductId=@DestinationProductId, @NewVoucherReservationBatchId=@NewVoucherReservationBatchId, @ExpiryDate=@ExpiryDate,
	@SourceProductId=@SourceProductId, @VoucherReservationBatchId=@LoopVoucherReservationBatchId;
	
	end


	INSERT INTO [dbo].[VoucherMovingLog]([VoucherReservationBatchId], [Amount], [Increase], [GUID], [DateTime])
	VALUES (@LoopVoucherReservationBatchId, @EachTopAmount, -1, @GUID, GETDATE());
	
	if exists (	select * from #TempVoucher u
	inner join Voucher v with(nolock) on u.VoucherNumber = v.VoucherNumber AND u.ProgramId = v.ProgramId)
	begin
		update v
		set v.ProductId = @DestinationProductId
		from #TempVoucher u
		inner join Voucher v with(nolock) on u.VoucherNumber = v.VoucherNumber AND u.ProgramId = v.ProgramId
	end
	delete from #TempVoucher;
	----------------
	FETCH NEXT FROM @BusinessCursor INTO @LoopVoucherReservationBatchId;
	END




	set @ResponseCode = '0000';	
				
	
	END TRY
	BEGIN CATCH
		set @ErrorMessage = ERROR_MESSAGE();	
		ROLLBACK TRAN
		return
	END CATCH
	COMMIT TRAN	
END
ELSE
BEGIN
	set @ResponseCode = 'E0008';
	RETURN;
END

----------------------------------------------------	
END
