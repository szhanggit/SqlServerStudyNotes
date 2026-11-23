CREATE PROCEDURE [dbo].[spTX2TOTXCTemplateMapping]
@SelectedTable TableTX2TOTXCTemplateMappingType READONLY
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT st.TenantId,tm.TXConnectionId,etv.TemplateId AS TX2TemplateId ,st.Id AS ExternalTXCId, st.TXTemplateType
    FROM @SelectedTable st 
	INNER JOIN dbo.TX2TOTXCTemplateMapping tm with(nolock) ON st.Id = tm.ExternalTXCId AND st.TenantId = tm.TenantId AND st.TXTemplateType = tm.TXTemplateType
    INNER JOIN dbo.EmailTemplateVersion etv with(nolock) ON etv.Id = tm.TXConnectionId 
    WHERE st.TXTemplateType = 1
	union
	SELECT st.TenantId,tm.TXConnectionId,stv.TemplateId AS TX2TemplateId ,st.Id AS ExternalTXCId, st.TXTemplateType
    FROM @SelectedTable st 
	INNER JOIN dbo.TX2TOTXCTemplateMapping tm with(nolock) ON st.Id = tm.ExternalTXCId AND st.TenantId = tm.TenantId AND st.TXTemplateType = tm.TXTemplateType
    INNER JOIN dbo.SLMSTemplateVersion stv with(nolock) ON stv.Id = tm.TXConnectionId 
    WHERE st.TXTemplateType = 2
END;