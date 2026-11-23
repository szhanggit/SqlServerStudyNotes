CREATE PROCEDURE dbo.spInsertExpirationPolicyHistory

	@ClientQuotationProductId int,
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
    
	update ClientQuotationProduct 
    set 
        ExpirySchemeId = @NewExpirySchemeId, 
        ExpirationDate = @NewExpirationDate, 
        LastUpdateDate = @UpdateDate, 
        UpdatedBy = @UpdateUser 
    where Id = @ClientQuotationProductId

    declare @VersionNo tinyint
    select @VersionNo = COALESCE(VersionNo,0) 
    from ExpirationPolicyHistory with(nolock) 
    where ClientQuotationProductId  = @ClientQuotationProductId and ClientQuotationProductComboId is null

	insert into ExpirationPolicyHistory (ClientQuotationProductId, ClientQuotationProductComboId, VersionNo, ExpirySchemeId, ExpirationDate, CreatedTime, CreatedBy) 
    values (@ClientQuotationProductId, null, COALESCE(@VersionNo + 1,0), @ExpirySchemeId, @ExpirationDate, @CreatedTime, @CreatedBy)
END