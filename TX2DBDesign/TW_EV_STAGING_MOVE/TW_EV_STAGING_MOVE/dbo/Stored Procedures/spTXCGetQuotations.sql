
CREATE PROCEDURE [dbo].[spTXCGetQuotations]
	@QuotationId INT = NULL,
	@Keyword NVARCHAR(MAX) = NULL,
	@Status INT = NULL,
	@ClientCode VARCHAR(50) = NULL,
	@ValidOn Date = NULL,
	@PageSize INT = 20,
	@PageIndex INT = 0,
	@TotalCount INT = 0 OUTPUT
AS
BEGIN

DECLARE @StatusList TABLE
(
	Status INT NOT NULL
)

IF @Status IS NOT NULL
BEGIN
	DECLARE @I INT = 12
	DECLARE @TempStatus INT

	WHILE @Status > 0 AND @I>=0
	BEGIN
		SET @TempStatus = POWER(2, @I)

		IF @TempStatus <= @Status
		BEGIN
			INSERT INTO @StatusList VALUES (@TempStatus)
			SET @Status = @Status - @TempStatus
		END

		SET @I = @I - 1
	END
END

DECLARE @QuotationList TABLE
(
	Id INT NOT NULL
)

INSERT INTO @QuotationList
SELECT cq.Id
FROM ClientQuotation cq
INNER JOIN Client c ON cq.ClientId = c.Id
WHERE (@QuotationId IS NULL OR cq.Id = @QuotationId)
AND (@Keyword IS NULL OR cq.QuotationNumber LIKE N'%' + @Keyword + '%' OR cq.ProjectName LIKE N'%' + @Keyword + '%' OR c.Name LIKE N'%' + @Keyword + '%' OR cq.SalesEmail LIKE N'%' + @Keyword + '%')
AND (@Status IS NULL OR cq.Status IN (SELECT Status FROM @StatusList))
AND (@ClientCode IS NULL OR c.IdentityCode = @ClientCode)
AND (@ValidOn IS NULL OR (cq.ValidFrom <= @ValidOn AND cq.ValidTo >= @ValidOn))

SELECT @TotalCount = COUNT(1) FROM @QuotationList

SELECT
	cq.Id,
	cq.QuotationNumber,
	cq.CreatedBySystem,
	cm.ExternalId ClientId, --TXCClientId
	c.IdentityCode ClientIdentityCode,
	c.Name ClientName,
	cq.ProjectCode,
	cq.ProjectName,
	cq.QuotationType,
	COUNT(cqp.Id) ProductQuantity,
	cq.BusinessModelId,
	d1.Name BusinessModelName,
	cq.BusinessTypeId,
	d2.Name BusinessTypeName,
	cq.Sales,
	cq.SalesEmail,
	cq.ValidFrom,
	cq.ValidTo,
	cq.Status,
	cq.AdvanceBilling,
	cq.INBizModel INBusinessModelId,
	d3.Name INBusinessModelName
INTO #TEMP
FROM @QuotationList q
INNER JOIN ClientQuotation cq ON q.Id = cq.Id
INNER JOIN Client c ON cq.ClientId = c.Id
INNER JOIN BusinessModel bm ON cq.BusinessModelId = bm.Id
INNER JOIN Dictionary d1 ON bm.DisplayNameId = d1.Id
INNER JOIN Dictionary d2 ON cq.BusinessTypeId = d2.Id
LEFT OUTER JOIN BusinessModel bm2 ON cq.INBizModel = bm2.Id
LEFT OUTER JOIN Dictionary d3 ON bm2.DisplayNameId = d3.Id
INNER JOIN TXCClientMapping cm ON c.Id = cm.ClientId
LEFT OUTER JOIN ClientQuotationProduct cqp ON cq.Id = cqp.ClientQuotationId
GROUP BY
	cq.Id,
	cq.QuotationNumber,
	cq.CreatedBySystem,
	cm.ExternalId,
	c.IdentityCode,
	c.Name,
	cq.ProjectCode,
	cq.ProjectName,
	cq.QuotationType,
	cq.BusinessModelId,
	d1.Name,
	cq.BusinessTypeId,
	d2.Name,
	cq.Sales,
	cq.SalesEmail,
	cq.ValidFrom,
	cq.ValidTo,
	cq.Status,
	cq.AdvanceBilling,
	cq.INBizModel,
	d3.Name
ORDER BY cq.Id DESC
OFFSET (@PageSize * @PageIndex) ROWS
FETCH NEXT @PageSize ROWS ONLY

SELECT t.*, 
	etm.ExternalId EmailTemplateId, etvm.ExternalId EmailTemplateVersionId,
	svetm.ExternalId SVEmailTemplateId, svetvm.ExternalId SVEmailTemplateVersionId,
	stm.ExternalId SMSTemplateId, stvm.ExternalId SMSTemplateVersionId,
	svstm.ExternalId SVSMSTemplateId, svstvm.ExternalId SVSMSTemplateVersionId
FROM #TEMP t
LEFT OUTER JOIN QuotationTemplateVersionSet et ON t.Id = et.ClientQuotationId AND et.IsEmail = 1 AND et.TemplateType = 0 --EmailTemplate
LEFT OUTER JOIN TXCEmailTemplateMapping etm ON et.TemplateId = etm.EmailTemplateId
LEFT OUTER JOIN TXCEmailTemplateVersionMapping etvm ON et.TemplateVersionId = etvm.EmailTemplateVersionId
LEFT OUTER JOIN QuotationTemplateVersionSet svet ON t.Id = svet.ClientQuotationId AND svet.IsEmail = 1 AND svet.TemplateType = 1 --SVEmailTemplate
LEFT OUTER JOIN TXCEmailTemplateMapping svetm ON svet.TemplateId = svetm.EmailTemplateId
LEFT OUTER JOIN TXCEmailTemplateVersionMapping svetvm ON svet.TemplateVersionId = svetvm.EmailTemplateVersionId
LEFT OUTER JOIN QuotationTemplateVersionSet st ON t.Id = st.ClientQuotationId AND st.IsEmail = 0 AND st.TemplateType = 0 --SMSTemplate
LEFT OUTER JOIN TXCSLMSTemplateMapping stm ON st.TemplateId = stm.SLMSTemplateId
LEFT OUTER JOIN TXCSLMSTemplateVersionMapping stvm ON st.TemplateVersionId = stvm.SLMSTemplateVersionId
LEFT OUTER JOIN QuotationTemplateVersionSet svst ON t.Id = svst.ClientQuotationId AND svst.IsEmail = 0 AND svst.TemplateType = 1 --SVSMSTemplate
LEFT OUTER JOIN TXCSLMSTemplateMapping svstm ON svst.TemplateId = svstm.SLMSTemplateId
LEFT OUTER JOIN TXCSLMSTemplateVersionMapping svstvm ON svst.TemplateVersionId = svstvm.SLMSTemplateVersionId

DROP TABLE #TEMP

END
