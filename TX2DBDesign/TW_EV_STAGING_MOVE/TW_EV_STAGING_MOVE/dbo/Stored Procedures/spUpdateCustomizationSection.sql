
CREATE PROCEDURE [dbo].[spUpdateCustomizationSection] 
	@NewCustomizationSection CustomizationSectionType READONLY
    ,@ClientQuotationProductId INT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRAN
	BEGIN TRY

	update dbo.ClientQuotationProduct
	set EnableCustomization = 1
	where Id = @ClientQuotationProductId

    INSERT INTO CustomizationSectionHistory (VersionNumber, ClientQuotationProductId, SCVTemplateId, SectionNumber, Title, [Description], ActivationStart, ActivationEnd, CreatedBy, VersionTime)
    SELECT VersionNumber, ClientQuotationProductId, SCVTemplateId, SectionNumber, Title, [Description], ActivationStart, ActivationEnd, CreatedBy, VersionTime
    FROM CustomizationSection WHERE ClientQuotationProductId = @ClientQuotationProductId
    
    DELETE FROM CustomizationSection WHERE ClientQuotationProductId = @ClientQuotationProductId

    INSERT INTO CustomizationSection (VersionNumber, ClientQuotationProductId, SCVTemplateId, SectionNumber, Title, [Description], ActivationStart, ActivationEnd, CreatedBy, VersionTime)
    SELECT VersionNumber, ClientQuotationProductId, SCVTemplateId, SectionNumber, Title, [Description], ActivationStart, ActivationEnd, CreatedBy, VersionTime
    FROM @NewCustomizationSection
		
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
		begin
			ROLLBACK TRANSACTION;			
		end
	END CATCH;
	IF @@TRANCOUNT > 0
	begin
		COMMIT TRANSACTION;	
	end

    SELECT Id, VersionNumber, ClientQuotationProductId, SectionNumber
    FROM CustomizationSection with(nolock)
    WHERE ClientQuotationProductId = @ClientQuotationProductId
END
