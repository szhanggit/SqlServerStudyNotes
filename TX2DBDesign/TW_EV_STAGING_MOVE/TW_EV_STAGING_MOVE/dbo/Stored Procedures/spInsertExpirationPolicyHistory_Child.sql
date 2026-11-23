CREATE PROCEDURE dbo.spInsertExpirationPolicyHistory_Child

	@ClientQuotationProductId int,
    @ClientQuotationProductComboId int,
	@ExpirySchemeId int,
	@ExpirationDate datetime = null,
	@CreatedTime datetime,
	@CreatedBy nvarchar(50), 
	@NewExpirySchemeId int,
	@NewExpirationDate datetime = null,
    @UpdateDate datetime,
	@UpdateUser nvarchar(50)

AS
BEGIN
	SET NOCOUNT ON;
    
	DECLARE @childCQPId INT = NULL;
	SELECT @childCQPId = ChildClientQuotationProductId FROM dbo.ClientQuotationProductCombo WITH(NOLOCK) WHERE Id = @ClientQuotationProductComboId;

	BEGIN TRY
	BEGIN TRAN
	update ClientQuotationProductCombo 
    set 
        ExpirySchemeId = @NewExpirySchemeId, 
        ExpirationDate = @NewExpirationDate, 
        LastUpdateDate = @UpdateDate, 
        UpdatedBy = @UpdateUser 
    where Id = @ClientQuotationProductComboId

	UPDATE dbo.ClientQuotationProduct SET 
		ExpirySchemeId = @NewExpirySchemeId, 
		ExpirationDate = @NewExpirationDate,
		LastUpdateDate = @UpdateDate, 
        UpdatedBy = @UpdateUser
		WHERE Id = @childCQPId;

	UPDATE dbo.OrderLine SET 
		ExpirationPolicyId = @NewExpirySchemeId, 
		DefaultExpirationDate = @NewExpirationDate
		WHERE ClientQuotationProductId = @childCQPId;

    declare @VersionNo tinyint
    select @VersionNo = COALESCE(VersionNo,0) 
    from ExpirationPolicyHistory with(nolock) 
    where ClientQuotationProductId  = @ClientQuotationProductId and ClientQuotationProductComboId = @ClientQuotationProductComboId

	insert into ExpirationPolicyHistory (ClientQuotationProductId, ClientQuotationProductComboId, VersionNo, ExpirySchemeId, ExpirationDate, CreatedTime, CreatedBy) 
    values (@ClientQuotationProductId, @ClientQuotationProductComboId, COALESCE(@VersionNo + 1,0), @ExpirySchemeId, @ExpirationDate, @CreatedTime, @CreatedBy)

		COMMIT;
	END TRY
	BEGIN CATCH
		ROLLBACK;
		THROW;
	END CATCH
END