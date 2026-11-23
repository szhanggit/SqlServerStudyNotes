
CREATE PROCEDURE spInsertEMV_ClientOrderLine
	@ClientOrderId INT
	,@ClientQuotationProductId INT
 	,@ProgramName 				VARCHAR (250) NULL
	,@ProgramId 				VARCHAR (50)
	,@LocalRedemptionID 		VARCHAR (100)
	,@UserID 					VARCHAR (50)
	,@UserName 					VARCHAR (200)
	,@FirstName 				VARCHAR (100)
	,@MiddleName 				VARCHAR (100) NULL
	,@LastName 					VARCHAR (100) NULL
	,@Email 					VARCHAR(200)
	,@ContactPhone 				VARCHAR(25)
	,@Country 					VARCHAR(20)
	,@RedemptionDate 			VARCHAR(30)
 	,@RCN 						VARCHAR(100)
 	,@RedemptionItemName 		VARCHAR (250)
	,@SKU 						VARCHAR (25)
 	,@Quantity 					INT
 	,@UnitItemPoints 			INT NULL
	,@TotalItemPoints 			INT NULL
	,@DeliveryType 				TINYINT
	,@DeliveryPriority 			VARCHAR (20) NULL
	,@ClientOrderNumber 		VARCHAR (100) NULL
 	,@Priority 					INT 
	,@Remarks 					VARCHAR (250) NULL
	,@ClientSKUCode 			VARCHAR (25) NULL
	,@FLEX1						VARCHAR (250) NULL
	,@FLEX2						VARCHAR (250) NULL
	,@FLEX3						VARCHAR (250) NULL
	,@FLEX4						VARCHAR (250) NULL
	,@FLEX5						VARCHAR (250) NULL
 	,@CreatedTime 				DATETIME
 	,@UpdatedTime 				DATETIME
AS
BEGIN
	DECLARE @EMV_ClientOrderLineId INT
	DECLARE @EMV_ClientOrderTaskId INT
	SET @EMV_ClientOrderTaskId = -1
	SET NOCOUNT ON;
	INSERT INTO [dbo].[EMV_ClientOrderLine]
		(
		[ClientOrderId]
		,[ClientQuotationProductId]
		,[ProgramName]
		,[ProgramId]
		,[LocalRedemptionID]
		,[UserID]
		,[UserName]
		,[FirstName]
		,[MiddleName]
		,[LastName]
		,[Email]
		,[ContactPhone]
		,[Country]
		,[RedemptionDate]
		,[RCN]
		,[RedemptionItemName]
		,[SKU]
		,[Quantity]
		,[UnitItemPoints]
		,[TotalItemPoints]
		,[DeliveryType]
		,[DeliveryPriority]
		,[ClientOrderNumber]
		,[Priority]
		,[Remarks] 		
		,[ClientSKUCode] 
		,[FLEX1] 		
		,[FLEX2] 		
		,[FLEX3] 		
		,[FLEX4] 		
		,[FLEX5] 		
		,[Status]
		,[CreatedTime]
		,[UpdatedTime]
		)
	VALUES(
			@ClientOrderId
	, @ClientQuotationProductId
	, @ProgramName 		
, @ProgramId 		
, @LocalRedemptionID 
, @UserID 			
, @UserName 			
, @FirstName 		
, @MiddleName 		
, @LastName 			
, @Email 			
, @ContactPhone 		
, @Country 			
, @RedemptionDate 	
	, @RCN
	, @RedemptionItemName 	
	, @SKU 				
	, @Quantity
	, @UnitItemPoints 	
, @TotalItemPoints 	
, @DeliveryType 		
, @DeliveryPriority 	
, @ClientOrderNumber 
	, @Priority
	,@Remarks 		
,@ClientSKUCode 
,@FLEX1			
,@FLEX2			
,@FLEX3			
,@FLEX4			
,@FLEX5			
	, 1
	, @CreatedTime
	, @UpdatedTime
	)

	SET @EMV_ClientOrderLineId = SCOPE_IDENTITY()
    SELECT @EMV_ClientOrderLineId;
END
