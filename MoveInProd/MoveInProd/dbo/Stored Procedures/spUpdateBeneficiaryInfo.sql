create proc spUpdateBeneficiaryInfo
    @clientOrderNumber VARCHAR(50),
    @email VARCHAR(100) = NULL,
    @mobile VARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
 
	DECLARE @rowCount INT = 0;

    IF @email IS NOT NULL
	BEGIN
        UPDATE dbo.OrderBeneficiaryInfo SET Email = @email WHERE ClientOrderNumber = @clientOrderNumber;
		SET @rowCount = @@ROWCOUNT;
	END
    ELSE IF @mobile IS NOT NULL
	BEGIN
        UPDATE dbo.OrderBeneficiaryInfo SET Mobile = @mobile WHERE ClientOrderNumber = @clientOrderNumber;
		SET @rowCount = @@ROWCOUNT;
	END

	SELECT @rowCount;
END
