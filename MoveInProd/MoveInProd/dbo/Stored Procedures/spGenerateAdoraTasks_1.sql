
CREATE PROCEDURE spGenerateAdoraTasks @OrderId INT
	,@PieceNumber INT
	,@SessionId varchar(50) = null
	,@IsSuccess BIT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	IF EXISTS(select 1 from dbo.AdoraTask WITH(NOLOCK) where OrderId = @OrderId)
	BEGIN
		SET @IsSuccess = 1;
		RETURN;
	END

	BEGIN TRAN
	BEGIN TRY
		
		DECLARE @totalCount INT = (SELECT MAX(OrderSN) FROM dbo.VoucherOrderBuffer WITH(NOLOCK) WHERE OrderId = @OrderId);
		DECLARE @StartOrderSN INT = 0;
		DECLARE @EndOrderSN INT = 0;
		DECLARE @i INT = 0

		IF @SessionId IS NULL
			SET @SessionId = CONVERT(varchar(50),NEWID());

		--插入AdoraTask
		WHILE @EndOrderSN < @totalCount
		BEGIN
			SET @StartOrderSN = @i * @PieceNumber + 1
			SET @EndOrderSN = (@i + 1) * @PieceNumber;

			IF(@EndOrderSN > @totalCount)
				SET @EndOrderSN = @totalCount
			
			INSERT dbo.AdoraTask(OrderId, StartOrderSN, EndOrderSN, [Status], CreationTime, SessionId)
						 VALUES(@OrderId, @StartOrderSN, @EndOrderSN, 2, GETDATE(), @SessionId)

			SET @i = @i + 1
		END

		--Update VoucherOrderBuffer 的 AdoraTaskId
		update vo set AdoraTaskId = t.Id
			from dbo.VoucherOrderBuffer vo JOIN dbo.AdoraTask t WITH(NOLOCK) ON vo.OrderSN BETWEEN t.StartOrderSN AND t.EndOrderSN
			where vo.OrderId = @OrderId AND t.OrderId = @OrderId
		
		COMMIT TRAN
		SET @IsSuccess = 1
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		SET @IsSuccess = 0
	END CATCH
END
