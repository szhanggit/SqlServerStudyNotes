
CREATE PROCEDURE [dbo].[spUpdateVoucherExpiryNotificationConfiguration]
	@Email VARCHAR (100),
	@ProductCode VARCHAR (50),
	@ProgramId INT,
	@Days INT
AS
BEGIN
	SET NOCOUNT ON;
	IF EXISTS (Select 1 from [dbo].[VoucherExpiryNotificationConfiguration] Where ProductCode = @ProductCode and ProgramId = @ProgramId)
	BEGIN
		Update [dbo].[VoucherExpiryNotificationConfiguration] 
		Set Email = @Email, [Days]=@Days
		Where ProductCode = @ProductCode and ProgramId = @ProgramId
	END
	ELSE
	BEGIN
		Insert [dbo].[VoucherExpiryNotificationConfiguration](Email,ProductCode,ProgramId,[Days]) VALUES(@Email,@ProductCode,@ProgramId,@Days)
	END
END
