
CREATE PROCEDURE [dbo].[spIsRequestExist] 
     @RequestId VARCHAR(50)
	,@IsExist BIT OUTPUT
AS
BEGIN
  SET NOCOUNT ON;
  SET @IsExist = 0
  if(exists(select 1 from APILog WITH(nolock) where RequestId = @RequestId))
  BEGIN
    SET @IsExist = 1
    return
  END
END

