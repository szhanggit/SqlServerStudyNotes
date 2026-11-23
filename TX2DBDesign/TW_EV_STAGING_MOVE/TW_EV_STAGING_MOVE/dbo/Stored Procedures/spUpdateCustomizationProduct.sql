
CREATE PROCEDURE [dbo].[spUpdateCustomizationProduct] 
	@NewCustomizationProduct CustomizationProductType READONLY
    ,@ClientQuotationProductId INT
	,@IsSuccess INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRAN
	BEGIN TRY


    -- insert existing CustomizationProduct to CustomizationProductHistory
    INSERT INTO CustomizationProductHistory (ClientQuotationProductComboId, VersionNumber, CustomizationSectionId, SectionNumber, ActivationStart, ActivationEnd, CreatedBy, VersionTime)
    SELECT cqpc.Id, cp.VersionNumber, cp.CustomizationSectionId, cp.SectionNumber, cp.ActivationStart, cp.ActivationEnd, cp.CreatedBy, cp.VersionTime
        FROM CustomizationProduct cp WITH(NOLOCK) 
        LEFT JOIN ClientQuotationProductCombo cqpc WITH(NOLOCK) on cp.Id = cqpc.CustomizationProductId
        WHERE ClientQuotationProductId = @ClientQuotationProductId
    
    -- delete existing CustomizationProduct
    DELETE FROM CustomizationProduct WHERE Id in (SELECT cp.Id
        FROM CustomizationProduct cp WITH(NOLOCK) 
        LEFT JOIN ClientQuotationProductCombo cqpc WITH(NOLOCK) on cp.Id = cqpc.CustomizationProductId
        WHERE ClientQuotationProductId = @ClientQuotationProductId)

	-- insert new values of CustomizationProduct
	declare @newIds as Table (
		[Id]							[int] NOT NULL,
		[ClientQuotationProductComboId] [int] NOT NULL,
		[VersionNumber]					[int] NOT NULL,
		[CustomizationSectionId]		[int] NOT NULL,
		[SectionNumber]					[tinyint] NOT NULL,
		[ActivationStart]				[datetime] NOT NULL,
		[ActivationEnd]					[datetime] NOT NULL,
		[CreatedBy]						[nvarchar](50) NOT NULL,
		[VersionTime]					[datetime] NOT NULL)
    INSERT INTO CustomizationProduct (ClientQuotationProductComboId, VersionNumber, CustomizationSectionId, SectionNumber, ActivationStart, ActivationEnd, CreatedBy, VersionTime)
		OUTPUT Inserted.* into @newIds
    SELECT ClientQuotationProductComboId, VersionNumber, CustomizationSectionId, SectionNumber, ActivationStart, ActivationEnd, CreatedBy, VersionTime
    FROM @NewCustomizationProduct n

	-- update ClientQuotationProductCombo with new Ids
	 update ClientQuotationProductCombo
	 set CustomizationProductId = n.Id
	 from ClientQuotationProductCombo cqpc with(nolock)
	 join @newIds n on cqpc.Id = n.ClientQuotationProductComboId

		
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
