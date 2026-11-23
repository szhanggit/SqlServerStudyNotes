
CREATE PROCEDURE [dbo].[spInsertEXT_IN_APIOrderInfo]
	@ClientQuotationProductId INT
	,@ProgramId 				VARCHAR (50)
	,@FirstName 				VARCHAR (100)
	,@MiddleName 				VARCHAR (100) NULL
	,@LastName 					VARCHAR (100) NULL
	,@Email 					VARCHAR(200)
	,@ContactPhone 				VARCHAR(25)
 	,@RCN 						VARCHAR(100)
	,@SKU 						VARCHAR (25)
 	,@Quantity 					INT
	,@DeliveryType 				TINYINT
	,@ClientOrderNumber 		VARCHAR (100) NULL
	,@ClientSKUCode 			VARCHAR (25) NULL
	,@FLEX1						VARCHAR (250) NULL
	,@FLEX2						VARCHAR (250) NULL
	,@FLEX3						VARCHAR (250) NULL
	,@FLEX4						VARCHAR (250) NULL
	,@FLEX5						VARCHAR (250) NULL
	,@ClientQuotationId			INT
	,@TransactionId				VARCHAR(50) NULL
 	,@CreatedTime 				DATETIME
 	,@UpdatedTime 				DATETIME
AS
BEGIN
	DECLARE @EXT_IN_APIOrderInfoId INT
	SET NOCOUNT ON;
	INSERT INTO [dbo].[EXT_IN_APIOrderInfo]
		(
		[ClientQuotationProductId]
		,[ProgramId]
		,[FirstName]
		,[MiddleName]
		,[LastName]
		,[Email]
		,[ContactPhone]
		,[RCN]
		,[SKU]
		,[Quantity]
		,[DeliveryType]
		,[ClientOrderNumber]
		,[ClientSKUCode] 
		,[FLEX1] 		
		,[FLEX2] 		
		,[FLEX3] 		
		,[FLEX4] 		
		,[FLEX5]
		,[ClientQuotationId]
		,[TransactionId]
		,[CreatedTime]
		,[UpdatedTime]
		)
	VALUES(
			@ClientQuotationProductId
	, @ProgramId 		
	, @FirstName 		
	, @MiddleName 		
	, @LastName 			
	, @Email 			
	, @ContactPhone 		
	, @RCN
	, @SKU 				
	, @Quantity
	, @DeliveryType 		
	, @ClientOrderNumber 
	,@ClientSKUCode 
	,@FLEX1			
	,@FLEX2			
	,@FLEX3			
	,@FLEX4			
	,@FLEX5
	,@ClientQuotationId
	,@TransactionId
	, @CreatedTime
	, @UpdatedTime
	)

	SET @EXT_IN_APIOrderInfoId = SCOPE_IDENTITY()
    SELECT @EXT_IN_APIOrderInfoId;
END
