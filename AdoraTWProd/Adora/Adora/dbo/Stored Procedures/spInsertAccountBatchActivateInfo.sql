-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE spInsertAccountBatchActivateInfo 
	-- Add the parameters for the stored procedure here
	@StartSequenceNumber BIGINT, 
	@EndSequenceNumber BIGINT,
	@Status INT,
	@Description NVARCHAR(1000),
	@CreateUTCTime BIGINT,
	@Id BIGINT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [dbo].[AccountBatchActivateInfo]
           ([StartSequenceNumber]
           ,[EndSequenceNumber]
           ,[Status]
           ,[Description]
           ,[CreateUTCTime])
     VALUES
           (@StartSequenceNumber
           ,@EndSequenceNumber
           ,@Status
           ,@Description
           ,@CreateUTCTime)

	SET @Id = SCOPE_IDENTITY();
END
