-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spUpdateBatchTransactionTask]
	-- Add the parameters for the stored procedure here
	@Id bigint,
	@Status int,
	@ExecuteStartTime datetime
AS
BEGIN
	SET NOCOUNT ON;

    UPDATE [BatchTransactionTask] 
		SET [Status] = @Status
			,ExecuteStartTime = @ExecuteStartTime
	WHERE ID = @Id
	
END
