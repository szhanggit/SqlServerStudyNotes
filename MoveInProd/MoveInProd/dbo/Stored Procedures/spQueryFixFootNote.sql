CREATE PROC spQueryFixFootNote 
	@BusinessTypeId INT,
	@NeedTrustAccount BIT = NULL,
	@OrderLineId INT
AS
BEGIN
	SET NOCOUNT ON;

	--NeedTrustAccount = null (旧数据)
		--1.通过BusinessType查询
		--2.如果查询结果有多个，取第一个
	--NeedTrustAccount = true
		--1.通过BusinessType和TrustAccount共同决定
		--2.如果没有符合条件的，逻辑同NeedTrustAccount = false
	--NeedTrustAccount = false
		--1.通过BusinessType查询
		--2.如果查询结果有多个，优先使用Default
	

	DECLARE @ContentTagValueId INT = NULL;

	IF @NeedTrustAccount IS NULL
    BEGIN
		SELECT TOP (1) @ContentTagValueId = v.Id FROM dbo.ContentTagValue v 
			JOIN dbo.ApplyCondition a ON a.Id = v.ApplyConditionId
			JOIN dbo.ApplyCondition_BusinessType b ON b.ApplyConditionId = a.Id
			WHERE b.BusinessTypeId = @BusinessTypeId
			ORDER BY v.Id
	END

	IF @NeedTrustAccount = 1
	BEGIN
		DECLARE @TrustAccountId INT = NULL;
		SET @TrustAccountId = (SELECT TOP (1) TrustAccountId FROM dbo.OrderLineTrustAccount WITH(NOLOCK) WHERE OrderLineId = @OrderLineId ORDER BY Id DESC);

		SELECT @ContentTagValueId = v.Id FROM dbo.ContentTagValue v 
			JOIN dbo.ApplyCondition a ON a.Id = v.ApplyConditionId
			JOIN dbo.ApplyCondition_BusinessType b ON b.ApplyConditionId = a.Id
			JOIN dbo.ApplyCondition_TrustAccount t ON t.ApplyConditionId = a.Id
			WHERE b.BusinessTypeId = @BusinessTypeId  AND t.TrustAccountId = @TrustAccountId
	END
			
	IF @ContentTagValueId IS NULL
	BEGIN
		SELECT TOP (1) @ContentTagValueId = v.Id FROM dbo.ContentTagValue v 
			JOIN dbo.ApplyCondition a ON a.Id = v.ApplyConditionId
			JOIN dbo.ApplyCondition_BusinessType b ON b.ApplyConditionId = a.Id
			WHERE b.BusinessTypeId = @BusinessTypeId
			ORDER BY v.IsDefault DESC, v.Id
	END

	SELECT Id,ContentTagId,HtmlValue,TextValue FROM dbo.ContentTagValue WHERE Id = @ContentTagValueId
END
