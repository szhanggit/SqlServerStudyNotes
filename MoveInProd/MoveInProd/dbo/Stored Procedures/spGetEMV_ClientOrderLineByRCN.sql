
CREATE PROCEDURE [dbo].[spGetEMV_ClientOrderLineByRCN] 
	@RCNS GetEMV_ClientOrderLineByRCNType Readonly
AS
BEGIN
	SET NOCOUNT ON;

	SELECT L.*,O.BatchId,B.FileName
	FROM @RCNS AS R
	JOIN [dbo].[EMV_ClientOrderLine] AS L WITH(NOLOCK) ON L.RCN = R.RCN
	JOIN [dbo].[EMV_ClientOrder] AS O WITH(NOLOCK) ON O.Id = L.ClientOrderId
	JOIN [dbo].[EMV_Batch] AS B WITH(NOLOCK) ON B.Id = O.BatchId
END
