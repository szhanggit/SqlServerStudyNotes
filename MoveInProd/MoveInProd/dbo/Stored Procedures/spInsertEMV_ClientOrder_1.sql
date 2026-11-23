
CREATE PROCEDURE spInsertEMV_ClientOrder
 @BatchId INT
 ,@ClientQuotationId INT
 ,@ClientOrderNumber NVARCHAR (100)
 ,@CreatedTime DATETIME
 ,@UpdatedTime DATETIME
 AS
BEGIN
	SET NOCOUNT ON;
	INSERT INTO [dbo].[EMV_ClientOrder] (
	[BatchId]
	,[ClientQuotationId]
	,[ClientOrderNumber]
	,[Status]
	,[CreatedTime]
	,[UpdatedTime]
	)
	VALUES(
	@BatchId
	,@ClientQuotationId
	,@ClientOrderNumber
	,1
	,@CreatedTime
	,@UpdatedTime
	)

SELECT SCOPE_IDENTITY()

END
