
CREATE PROCEDURE [dbo].[spSendVoucherRetry]                
AS                
BEGIN            
          
SET NOCOUNT ON          
          
SELECT [Id]
      ,[OrderId]
      ,[VoucherId]
      ,[VoucherNumber]
      ,[ServiceProviderCode]
      ,[RequestId]
      ,[MessageType]
      ,[TryCount]
      ,[ResponseCode]
      ,[CreatedTime]
      ,[UpdatedTime]
  FROM [dbo].[SendVoucherRetryInfo] with(nolock)
  where TryCount<3 and (ResponseCode is null or ResponseCode <>'0000')       
          
END