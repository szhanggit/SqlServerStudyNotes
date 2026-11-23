

CREATE PROCEDURE [dbo].[spGetEMV_ClientOrderLineByTXOrderNumber]
	@OrderNumbers GetEMV_ClientOrderLineByTXOrderNumberType Readonly
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		L.[Id]
      , L.[ClientOrderId]
      , L.[ClientQuotationProductId]
      , L.[ProgramName]
      , L.[ProgramId]
      , L.[LocalRedemptionID]
      , L.[UserID]
      , L.[UserName]
      , L.[FirstName]
      , L.[MiddleName]
      , L.[LastName]
      , L.[Email]
      , L.[ContactPhone]
      , L.[Country]
      , L.[RedemptionDate]
      , L.[RCN]
      , L.[RedemptionItemName]
      , L.[SKU]
      , L.[Quantity]
      , L.[UnitItemPoints]
      , L.[TotalItemPoints]
      , L.[DeliveryType]
      , L.[DeliveryPriority]
      , L.[ClientOrderNumber]
      , L.[Priority]
      , L.[Remarks]
      , L.[ClientSKUCode]
      , L.[FLEX1]
      , L.[FLEX2]
      , L.[FLEX3]
      , L.[FLEX4]
      , L.[FLEX5]
      , OO.[Status]
      , L.[CreatedTime]
      , L.[UpdatedTime]
      , L.[OrderNumber]
	  , O.BatchId
	  , B.FileName
          , B.Status as BatchStatus
	  , case OO.ExecutingStatus when 1 then 'NotStart'
	  when 2 then 'Assign Voucher'
	  when 3 then 'Pending Insufficient Stock'
	  when 4 then 'SyncToAuth'
	  when 5 then 'SyncToAuthFail'
	  when 6 then 'Distribute'
	  when 7 then 'DistributeFail'
	  when 8 then 'Complete'
	  when 9 then 'CreateThirdPartyOrder'
	  when 10 then 'CreateThirdPartyOrderFail' end  as [Result]
	FROM @OrderNumbers AS ot
		JOIN [dbo].[EMV_ClientOrderLine] AS L WITH(NOLOCK) ON L.OrderNumber = ot.OrderNumber
		JOIN [dbo].[EMV_ClientOrder] AS O WITH(NOLOCK) ON O.Id = L.ClientOrderId
		JOIN [dbo].[EMV_Batch] AS B WITH(NOLOCK) ON B.Id = O.BatchId
		JOIN [dbo].[Order] as OO WITH(NOLOCK) ON OO.OrderNumber = ot.OrderNumber
END
