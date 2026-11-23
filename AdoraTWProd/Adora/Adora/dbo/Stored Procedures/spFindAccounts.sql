-- =============================================
-- Author:		Steven Yu
-- Create date: 2014/5/28
-- Description:	Find Accounts
-- =============================================
CREATE PROCEDURE spFindAccounts
	-- Add the parameters for the stored procedure here
	@AcountNumber		varchar(50) = NULL
	,@ProgramCode		varchar(20)  = NULL
	,@ExternalOrderId	varchar(50)  = NULL
	,@Status			int  = NULL
	,@CreatedOnFrom		datetime  = NULL
	,@CreatedOnTo		datetime  = NULL
	,@LastTranOnFrom	datetime  = NULL
	,@LastTranOnTo		datetime  = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @sql nvarchar(2000)

	set @sql = 'SELECT 
			[AccountNumber]
			,ProgramCode
			,[Order]
			,Status
			,CreatedOn
			,LastTranOn
			,PinCode
			FROM(SELECT
			[AccountNumber]
			,P.[IdentityCode] AS ProgramCode
			,[ExternalOrderId] AS [Order]
			,[Status]
			,[CreatedOn]
			,[LastTranOn]
			,[PinCode]
	FROM [dbo].[Account] A
	INNER JOIN [dbo].[Program] P ON A.ProgramId = P.Id
	union all
	select 			[AccountNumber]
			,P.[IdentityCode] AS ProgramCode
			,[ExternalOrderId] AS [Order]
			,[Status]
			,[CreatedOn]
			,[LastTranOn]
			,[PinCode]
	FROM [dbo].[AccountHistory] AH
	INNER JOIN [dbo].[Program] P ON AH.ProgramId = P.Id) AS list'

	if(@AcountNumber is not null)
	begin
		set @sql = @sql + ' WHERE [AccountNumber] = ''' + @AcountNumber + ''''
	end

	if(@ProgramCode is not null)
	begin
		if charindex('WHERE', @sql)>0
		begin
			set @sql = @sql + ' AND [ProgramCode] = ''' + @ProgramCode + ''''
		end
		else
		begin
			set @sql = @sql + ' WHERE [ProgramCode] = ''' + @ProgramCode + ''''
		end
	end

	if(@ExternalOrderId is not null)
	begin
		if charindex('WHERE', @sql)>0
		begin
			set @sql = @sql + ' AND [Order] = ''' + @ExternalOrderId + ''''
		end
		else
		begin
			set @sql = @sql + ' WHERE [Order] = ''' + @ExternalOrderId + ''''
		end
	end

	if(@Status is not null)
	begin
		if charindex('WHERE', @sql)>0
		begin
			set @sql = @sql + ' AND [Status] & ' + CAST(@Status AS varchar(3)) + ' =  [Status]'
		end
		else
		begin
			set @sql = @sql + ' WHERE [Status] & ' + CAST(@Status AS varchar(3)) + ' = [Status]'
		end
	end

	if(@CreatedOnFrom is not null)
	begin
		if charindex('WHERE', @sql)>0
		begin
			set @sql = @sql + ' AND [CreatedOn] >= ''' + CAST(@CreatedOnFrom AS VARCHAR(20)) + ''''
		end
		else
		begin
			set @sql = @sql + ' WHERE [CreatedOn] >= ''' +  CAST(@CreatedOnFrom AS VARCHAR(20)) + ''''
		end
	end

	if(@CreatedOnTo is not null)
	begin
		if charindex('WHERE', @sql)>0
		begin
			set @sql = @sql + ' AND [CreatedOn] < ''' +  CAST(@CreatedOnTo AS VARCHAR(20)) + ''''
		end
		else
		begin
			set @sql = @sql + ' WHERE [CreatedOn] < ''' + CAST(@CreatedOnTo AS VARCHAR(20)) + ''''
		end
	end

	if(@LastTranOnFrom is not null)
	begin
		if charindex('WHERE', @sql)>0
		begin
			set @sql = @sql + ' AND [LastTranOn] >= ''' + CAST(@LastTranOnFrom AS VARCHAR(20)) + ''''
		end
		else
		begin
			set @sql = @sql + ' WHERE [LastTranOn] >= ''' + CAST(@LastTranOnFrom AS VARCHAR(20)) + ''''
		end
	end

	if(@LastTranOnTo is not null)
	begin
		if charindex('WHERE', @sql)>0
		begin
			set @sql = @sql + ' AND [LastTranOn] < ''' + CAST(@LastTranOnTo AS VARCHAR(20)) + ''''
		end
		else
		begin
			set @sql = @sql + ' WHERE [LastTranOn] < ''' + CAST(@LastTranOnTo AS VARCHAR(20)) + ''''
		end
	end

	exec(@sql)
END
