CREATE PROCEDURE getThirdPartyNotifDetails
	-- Add the parameters for the stored procedure here
	@ProductName nvarchar(200)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
			SELECT  
			M.Name as  MerchantName, 
			P.ProductCode as ProductCode, 
			P.ProductName as ProductName, 
			DATEADD(second,1, p.ValidTo) as ExpirationDate

            FROM AcceptanceLoopMerchant ACL WITH(NOLOCK)
            INNER JOIN Merchant M WITH(NOLOCK) on ACL.MerchantId = M.Id
			inner join Product P with(nolock) on P.AcceptanceLoopId = ACL.AcceptanceLoopId
			
			where P.ProductName = @ProductName
END
