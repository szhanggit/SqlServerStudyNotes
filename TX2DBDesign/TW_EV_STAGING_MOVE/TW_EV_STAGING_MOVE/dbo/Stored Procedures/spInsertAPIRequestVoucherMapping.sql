
CREATE PROCEDURE [dbo].[spInsertAPIRequestVoucherMapping] 
	@RequestId VARCHAR(50),
    @VoucherNumber VARCHAR(50),
    @ProgramCode VARCHAR(20),
	@IsSuccess INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRAN
	BEGIN TRY

    DECLARE @ProgramId INT
    SELECT @ProgramId = Id from dbo.Program with(nolock) where IdentityCode = @ProgramCode

    INSERT INTO dbo.ApiRequestVoucherMapping (RequestId, VoucherNumber, ProgramId, CreatedDate)
    SELECT @RequestId, @VoucherNumber, @ProgramId, GETDATE()
		
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
		begin
			set @IsSuccess = 0;
			ROLLBACK TRANSACTION;			
		end
	END CATCH;
	IF @@TRANCOUNT > 0
	begin
		set @IsSuccess = 1;
		COMMIT TRANSACTION;	
	end
END
