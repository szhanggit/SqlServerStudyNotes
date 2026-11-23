
CREATE PROCEDURE [dbo].[spAssignDiveTasks] @OrderId INT
	,@PieceNumber INT
	,@IsSuccess BIT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @totalCount INT
	DECLARE @StartSN INT
	DECLARE @EndSN INT

	if(exists(select 1 from [DiveTask] with(nolock) where OrderId = @OrderId))
	BEGIN
		SET @IsSuccess = 1
		return
	END

	BEGIN TRAN

	BEGIN TRY
		DECLARE @table table
		(
			Id int identity(1,1),
			OrderLineId int,
			TotalCount int
		);
		DECLARE @rowCount INT;
		DECLARE @index INT = 1;
		DECLARE @OrderLineId INT;
		declare @sessionId varchar(50) = (select top 1 SessionId from AdoraTask with(nolock) where OrderId = @OrderId)

		insert @table(OrderLineId,TotalCount) SELECT OrderLineId,MAX(OrderLineSN) FROM VoucherOrder with(nolock) where OrderId = @OrderId group by OrderLineId
	
		set @rowCount = (select COUNT(1) from @table);
		
		WHILE @index <= @rowCount
		BEGIN
			SELECT @totalCount = TotalCount FROM @table where Id = @index
			SET @OrderLineId = (select OrderLineId from @table where Id = @index)
			SET @index = @index + 1;
			set @StartSN = 0;
			set @EndSN = 0;

			WHILE @EndSN < @totalCount
			BEGIN
				SET @StartSN = @EndSN + 1
				if(@EndSN + @PieceNumber < @totalCount)
				begin
					SET @EndSN = @EndSN + @PieceNumber
					SET @EndSN = (select MAX(OrderLineSN) from VoucherOrder with(nolock) where OrderBeneficiaryInfoId = (select OrderBeneficiaryInfoId from VoucherOrder where OrderLineId = @OrderLineId and  OrderLineSN = @EndSN))
				end
				Else
					SET @EndSN = @totalCount
	     
				INSERT INTO [dbo].[DiveTask] (
					[OrderId]
					,[OrderLineId]
					,[StartOrderLineSN]
					,[EndOrderLineSN]
					,[Status]
					,[CreationTime]
					,SessionId
				)
				VALUES (
					@OrderId
					,@OrderLineId
					,@StartSN
					,@EndSN
					,2
					,GETDATE()
					,@sessionId
				)
			END
		END
		
	END TRY
	BEGIN CATCH
			ROLLBACK TRAN
			SET @IsSuccess = 0
			return
	END CATCH

	COMMIT TRAN

	SET @IsSuccess = 1
END
