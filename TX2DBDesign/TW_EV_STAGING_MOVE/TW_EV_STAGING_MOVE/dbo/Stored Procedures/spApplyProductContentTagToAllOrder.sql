-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE PROCEDURE [dbo].[spApplyProductContentTagToAllOrder]
	@ProductCode VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

	BEGIN TRY
		BEGIN TRANSACTION

		UPDATE T1
		SET T1.Value = T9.Value
		FROM [dbo].[OrderEmailContentTagValueSet] AS T1
			INNER JOIN [dbo].[OrderLine] AS T2 ON T1.OrderLineId = T2.Id
			INNER JOIN [dbo].[ClientQuotationProduct] AS T3 ON T2.[ClientQuotationProductId] = T3.Id
			INNER JOIN [dbo].[ProductVersion] AS T4 ON T3.ProductVersionId = T4.Id
			INNER JOIN [dbo].[Product] AS T5 ON T4.ProductId = T5.Id
			INNER JOIN [dbo].[ProductEmailTemplateVersion] T6 ON T5.ProductEmailTemplateVersionId = T6.Id
			INNER JOIN [dbo].[ProductEmailTemplateVersionSet] T7 ON T6.Id = T7.ProductEmailTemplateVersionId AND T2.EmailTemplateVersionId = T7.EmailTemplateVersionId
			INNER JOIN [dbo].[ProductEmailTemplateTagValue] T8 ON T7.EmailTemplateTagValueId = T8.Id
			INNER JOIN [dbo].[ProductEmailContentTagValueSet] T9 ON T8.Id = T9.ProductEmailTemplateTagValueId AND T1.ContentTagId = T9.ContentTagId
		WHERE T5.ProductCode = @ProductCode
		AND T1.ContentTagId NOT IN (SELECT Id FROM ContentTag WHERE TagName IN ('{EmailSubject}', '{Greetings}', '{SMSGreetings}'))
		
		UPDATE A
		SET A.Value = L.Value
		FROM OrderEmailTemplateTagValueSet A
		INNER JOIN OrderEmailTemplateTagValue B
			ON A.OrderEmailTemplateTagValueId = B.Id
		INNER JOIN OrderEmailTemplateVersionSet C
			ON C.EmailTemplateTagValueId = B.Id
		INNER JOIN OrderEmailTemplateVersion D
			ON C.OrderEmailTemplateVersionId = D.Id
		INNER JOIN OrderLine E
			ON D.Id = E.OrderEmailTemplateVersionId
		INNER JOIN ClientQuotationProduct F
			ON E.ClientQuotationProductId = F.Id
		INNER JOIN ProductVersion G
			ON F.ProductVersionId = G.Id
		INNER JOIN Product H
			ON G.ProductId = H.Id
		INNER JOIN ProductEmailTemplateVersion I
			ON H.ProductEmailTemplateVersionId = I.Id
		INNER JOIN ProductEmailTemplateVersionSet J
			ON I.Id = J.ProductEmailTemplateVersionId
		INNER JOIN ProductEmailTemplateTagValue K
			ON J.EmailTemplateTagValueId = K.Id
		INNER JOIN ProductEmailContentTagValueSet L
			ON K.Id = L.ProductEmailTemplateTagValueId AND C.EmailTemplateVersionId = J.EmailTemplateVersionId AND A.ContentTagId = L.ContentTagId
		WHERE H.ProductCode = @ProductCode
		AND A.ContentTagId NOT IN (SELECT Id FROM ContentTag WHERE TagName IN ('{EmailSubject}', '{Greetings}', '{SMSGreetings}'))

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
			ROLLBACK TRANSACTION;
	END CATCH
END
