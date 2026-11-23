
Create PROCEDURE [dbo].[spUpdateTX2TOTXCTemplateMapping]
    @DataInput TX2TOTXCTemplateMappingParameter Readonly,
    @tenantName varchar(50),
    @tenantId int
AS
BEGIN

UPDATE ttm set ttm.ExternalTXCId = di.ExternalTXCId  
from TX2TOTXCTemplateMapping ttm 
inner join @DataInput di on di.TXConnectionId = ttm.TXConnectionId and di.TXTemplateType = ttm.TXTemplateType
inner join TXCTenant txct on txct.Id = ttm.TenantId
where txct.Id = @tenantId 

END
