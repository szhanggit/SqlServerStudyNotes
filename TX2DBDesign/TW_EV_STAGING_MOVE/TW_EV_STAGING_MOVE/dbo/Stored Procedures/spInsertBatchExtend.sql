CREATE PROCEDURE [dbo].[spInsertBatchExtend]
	 @FileName NVARCHAR (300)  
	 ,@CreatedTime DATETIME  
	 ,@TotalRows INT  
	 ,@Status INT  
	 AS  
	BEGIN  
		SET NOCOUNT ON;  
		INSERT INTO [dbo].[BatchExtend] (  
		[FileName]  
		,[CreatedTime]  
		,[TotalRows]  
		,[Status]  
		)  
		VALUES(  
		@FileName  
		,@CreatedTime  
		,@TotalRows  
		,@Status  
		)
		
		SELECT SCOPE_IDENTITY()  	  
	END