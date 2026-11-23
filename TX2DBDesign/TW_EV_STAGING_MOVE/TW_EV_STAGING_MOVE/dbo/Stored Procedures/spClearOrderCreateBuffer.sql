
CREATE PROCEDURE [dbo].[spClearOrderCreateBuffer]
@OrderGroupId INT
AS
BEGIN
	DELETE OrderCreateBuffer WHERE OrderGroupId = @OrderGroupId
END
