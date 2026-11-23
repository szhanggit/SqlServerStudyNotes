
CREATE PROCEDURE spQueryResendInfoByEmail @Email varchar(50), @From DATETIME = NULL, @To DATETIME = NULL
AS
BEGIN
	SET NOCOUNT ON;

	--EmailSubject 规则
	--API Order -> 优先取OrderBeneficiaryInfoExtra.EmailSubject
	--Other Order -> 
	DECLARE @ContentTagId INT = 0;
	SELECT @ContentTagId = Id FROM dbo.ContentTag WITH(NOLOCK) WHERE TagName = '{EmailSubject}'
	
	SELECT VoucherId, VoucherNumber, BeneficiaryInfoId, EmailSubject, ProjectName, OrderId, OrderNumber, PublishTime, ProductName, ProductCode, DistributionTaskMessageId FROM
	(SELECT 
		v.Id VoucherId,
		v.VoucherNumber,
		obi.Id BeneficiaryInfoId,
		CASE o.Mode
			WHEN 2 THEN obiExt.EmailSubject
			ELSE
				CASE
					WHEN o.IsDirectDelivery = 1 AND o.MWVEmailTemplate > 1 THEN vs.[Value]
					ELSE ev.[Subject]
				END
		END EmailSubject, 
		cq.ProjectName,
		o.Id OrderId,
		o.OrderNumber, 
		o.PublishDatetime PublishTime, 
		p.ProductName, 
		p.ProductCode, 
		--t.Id DistributionTaskId
		dm.Id DistributionTaskMessageId,
		rank() OVER(PARTITION BY obi.Id ORDER BY t.Id) rowNumber
	FROM dbo.OrderBeneficiaryInfo obi WITH(NOLOCK)
	JOIN dbo.OrderLine ol WITH(NOLOCK) ON ol.Id = obi.OrderLineId
	JOIN dbo.ClientQuotationProduct cqp WITH(NOLOCK) ON cqp.Id = ol.ClientQuotationProductId
	JOIN dbo.ProductVersion pv WITH(NOLOCK) ON pv.Id = cqp.ProductVersionId
	JOIN dbo.Product p WITH(NOLOCK) ON p.Id = pv.ProductId
	JOIN dbo.Voucher v WITH(NOLOCK) ON v.BeneficiaryInfoId = obi.Id
	JOIN dbo.[Order] o WITH(NOLOCK) ON o.Id = ol.OrderId
	JOIN dbo.ClientQuotation cq WITH(NOLOCK) ON cq.Id = o.ClientQuotationId
	LEFT JOIN dbo.OrderBeneficiaryInfoExtra obiExt WITH(NOLOCK) ON obiExt.Id = obi.Id
	LEFT JOIN dbo.OrderEmailTemplateVersionSet ts WITH(NOLOCK,FORCESEEK) ON ts.OrderEmailTemplateVersionId = ol.OrderEmailTemplateVersionId
	LEFT JOIN dbo.OrderEmailTemplateTagValueSet vs WITH(NOLOCK,FORCESEEK) ON vs.OrderEmailTemplateTagValueId = ts.EmailTemplateTagValueId AND vs.ContentTagId = @ContentTagId
	LEFT JOIN dbo.EmailTemplateVersion ev WITH(NOLOCK,FORCESEEK) ON ev.Id = ts.EmailTemplateVersionId AND ISNULL(obi.LanguageId, ev.LanguageId) = ev.LanguageId
	INNER JOIN dbo.DistributionTaskMessageVoucher dmv WITH(NOLOCK,INDEX=VoucherId_DTMV_Index) ON dmv.VoucherId = v.Id
	INNER JOIN dbo.DistributionTaskMessage dm WITH(NOLOCK,FORCESEEK) ON dm.Id = dmv.DistributionTaskMessageId
	INNER JOIN dbo.DistributionTask t WITH(NOLOCK,FORCESEEK) ON t.Id = dm.DistributionTaskId AND t.MessageType = 1
	WHERE obi.Email = @Email AND o.[Status] = 64 
	AND o.PublishDatetime >= @From AND o.PublishDatetime <= @To
	)temp
	WHERE temp.rowNumber = 1
END
