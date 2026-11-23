
CREATE PROCEDURE [dbo].[spAssignTasks] @OrderId INT
	,@PieceNumber INT
	,@sessionId varchar(50) = null
	,@IsSuccess BIT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @totalCount INT
	DECLARE @StartOrderSN INT
	DECLARE @EndOrderSN INT
	DECLARE @i INT = 0

  if(exists(select 1 from [VoucherOrder] with(nolock) where OrderId = @OrderId and AdoraTaskId is not null))
  BEGIN
    SET @IsSuccess = 1
    return
  END
  
	-- Insert statements for procedure here
	SELECT @totalCount = max(OrderSN)
	FROM VoucherOrder with(nolock)
	where OrderId = @OrderId

	WHILE @i * @PieceNumber < @totalCount
	BEGIN
	  
	  SET @StartOrderSN = @i * @PieceNumber + 1
	  if((@i+1)*@PieceNumber<@totalCount)
	     SET @EndOrderSN = (@i + 1) * @PieceNumber
	  Else
	     SET @EndOrderSN = @totalCount
	     
		INSERT INTO [dbo].[AdoraTask] (
			[OrderId]
			,[StartOrderSN]
			,[EndOrderSN]
			,[Status]
			,[CreationTime]
			)
		VALUES (
			@OrderId
			,@StartOrderSN
			,@EndOrderSN
			,1
			,GETDATE()
			)

		SET @i = @i + 1
	END

	BEGIN TRAN

	BEGIN TRY
		DECLARE @table table
		(
			Id int identity(1,1),
			AdoraTaskId int,
			StartOrderSN int,
			EndOrderSN int
		);

		insert @table(AdoraTaskId,StartOrderSN,EndOrderSN) SELECT Id,StartOrderSN,EndOrderSN FROM AdoraTask with(nolock) where OrderId = @OrderId order by Id

		declare @rowIndex int = 1;
		declare @taskCount int = (select count(1) from @table);
		declare @taskId int;
		declare @startSN int;
		declare @endSN int;

		while(@rowIndex <= @taskCount)
		begin
			set @taskId = (select AdoraTaskId from @table where Id = @rowIndex);
			set @startSN = (select StartOrderSN from @table where Id = @rowIndex);
			set @endSN = (select EndOrderSN from @table where Id = @rowIndex);
			set @rowIndex = @rowIndex + 1;
			update VoucherOrder set AdoraTaskId = @taskId where OrderId = @OrderId and OrderSN BETWEEN @startSN AND @endSN
		end

		--UPDATE [dbo].[VoucherOrder]
		--SET AdoraTaskId = at.Id
		--FROM [dbo].[AdoraTask] at
		--WHERE at.OrderId = @OrderId
		--	AND [dbo].[VoucherOrder].OrderId = @OrderId
		--	AND OrderSN BETWEEN at.StartOrderSN
		--		AND at.EndOrderSN

		IF @sessionId IS NULL
			SET @sessionId = CONVERT(varchar(50),NEWID());
		UPDATE [dbo].[AdoraTask] SET [Status] = 2,SessionId = @sessionId WHERE OrderId = @OrderId
		
	END TRY
	BEGIN CATCH
			ROLLBACK TRAN
			SET @IsSuccess = 0
			return
	END CATCH

	COMMIT TRAN

	SET @IsSuccess = 1
END
