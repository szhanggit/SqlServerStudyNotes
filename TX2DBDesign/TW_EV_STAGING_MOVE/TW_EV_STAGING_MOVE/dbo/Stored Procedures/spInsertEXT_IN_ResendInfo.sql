

CREATE PROCEDURE [dbo].[spInsertEXT_IN_ResendInfo]	
		@RequestId 				[varchar](50) ,
		@DeliveryType 			[tinyint] ,
		@Source 				[tinyint] ,
		@RCN 					[varchar](100),
		@SlmsTaskId 			[bigint] NULL,
		@EmailTaskId 			[bigint] NULL,
		@CreatedTime 			[datetime] 
AS
BEGIN
	DECLARE @EXT_IN_ResendInfoId INT
	SET NOCOUNT ON;
	INSERT INTO [dbo].[EXT_IN_ResendInfo]
		(
		RequestId, 		
		DeliveryType,
		Source,		
		RCN,		
		SlmsTaskId,
		EmailTaskId, 	
		CreatedTime 
		)
	VALUES(
		@RequestId, 		
		@DeliveryType,
		@Source,		
		@RCN,		
		@SlmsTaskId,
		@EmailTaskId, 	
		@CreatedTime 
	)

	SET @EXT_IN_ResendInfoId = SCOPE_IDENTITY()
    SELECT @EXT_IN_ResendInfoId;
END
