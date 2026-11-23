
CREATE PROCEDURE [dbo].[spDeleteOrderCreateBuffer]
	@OrderCreateId VARCHAR(50)
AS
BEGIN
	DELETE OrderCreateBuffer WHERE OrderCreateId = @OrderCreateId
END
