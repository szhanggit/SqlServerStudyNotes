-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE spCheckIsSevenElevenMultipartBarcode 
	-- Add the parameters for the stored procedure here
	@ProductId INT,
	@SevenElevenProgramCode VARCHAR(50),
	@IsSevenElevenMultipartBarcode BIT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SET @IsSevenElevenMultipartBarcode = 0

	IF (EXISTS(SELECT 1 
	           FROM EXT_TW_ProductBarcodeSetting pbs JOIN dbo.Product p ON pbs.Id= p.Id
	                JOIN dbo.Program pg ON p.ProgramId=pg.Id
			   WHERE pg.IdentityCode = @SevenElevenProgramCode
			   	     AND p.Id = @ProductId
			   )
		)
		SET @IsSevenElevenMultipartBarcode = 1
	ELSE
		SET @IsSevenElevenMultipartBarcode = 0
END
