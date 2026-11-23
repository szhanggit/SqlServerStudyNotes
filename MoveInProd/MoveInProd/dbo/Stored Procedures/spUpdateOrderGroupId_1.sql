
CREATE PROCEDURE [dbo].[spUpdateOrderGroupId]
	@OrderCreateId VARCHAR(50),
	@OrderGroupId INT
AS
BEGIN
	UPDATE OrderCreateBuffer SET OrderGroupId = @OrderGroupId WHERE OrderCreateId = @OrderCreateId
END
