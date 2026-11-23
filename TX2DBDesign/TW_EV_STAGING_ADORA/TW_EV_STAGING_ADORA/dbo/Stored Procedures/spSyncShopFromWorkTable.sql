-- =============================================
-- Author:		Steven Yu
-- Create date: 2014/05/23
-- Description:	This is used to do clear statistics.
-- =============================================
CREATE PROCEDURE spSyncShopFromWorkTable
    @BatchId			   uniqueidentifier
    ,@ErrorMessage		   nvarchar(4000)	   OUTPUT
    ,@ErrorLine		   int			   OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    BEGIN TRY
	   INSERT INTO SecurityKey
	   SELECT SW.SecurityKey
	   FROM ShopWork SW
	   LEFT JOIN SecurityKey SK ON SW.SecurityKey = SK.Value
	   WHERE SW.BatchId = @BatchId AND SK.Id IS NULL

	   UPDATE S
	   SET  IdentityCode   =	  SW.IdentityCode
		  ,[MerchantId]   =	  SW.MerchantId
		  ,Name		   =   SW.Name
		  ,TimeOffset	   =	  SW.TimeOffset
		  ,Telephone	   =	  SW.Telephone
		  ,[Address]	   =	  SW.[Address]
		  ,Longitude	   =	  SW.Longitude
		  ,Latitude	   =	  SW.Latitude
		  ,SecurityKeyId  =	  SK.Id
		  ,[Status]	   =	  SW.[Status]
		  ,MaxFailNumber  =	  P.ShopMaxFailNumber
	   FROM Shop S
	   INNER JOIN ShopWork SW ON SW.ExternalId = S.ExternalId AND SW.ProgramId = S.ProgramId AND SW.BatchId = @BatchId
	   INNER JOIN SecurityKey SK ON SW.SecurityKey = SK.Value
	   INNER JOIN Program P ON SW.ProgramId = P.Id

	   INSERT INTO Shop
	   (ProgramId,ExternalId,IdentityCode,Name,MerchantId,TimeOffset,Telephone,[Address],Longitude,Latitude,SecurityKeyId,[Status],MaxFailNumber)
	   SELECT SW.ProgramId,SW.ExternalId,SW.IdentityCode,SW.Name,SW.MerchantId,SW.TimeOffset,SW.Telephone,SW.[Address],SW.Longitude,SW.Latitude,SK.Id,SW.[Status],P.ShopMaxFailNumber
	   FROM ShopWork SW
	   INNER JOIN SecurityKey SK ON SW.SecurityKey = SK.Value
	   INNER JOIN Program P ON SW.ProgramId = P.Id
	   LEFT JOIN Shop S ON SW.ExternalId = S.ExternalId AND SW.ProgramId = S.ProgramId AND SW.MerchantId = S.MerchantId
	   WHERE S.Id IS NULL AND SW.BatchId = @BatchId

	   DELETE FROM ShopWork
	   where BatchId = @BatchId
    END TRY
    BEGIN CATCH
	   SELECT @ErrorMessage = ERROR_MESSAGE()
	   SELECT @ErrorLine = ERROR_LINE()
    END CATCH
END
