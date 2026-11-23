
CREATE PROCEDURE [dbo].[spGetOrderGroupSummary]
@OrderGroupId INT
AS
BEGIN
	DECLARE @OrderCount INT
	DECLARE @LineCount INT
	DECLARE @TotalQuantity INT

	SELECT @OrderCount = COUNT(1) FROM
	(SELECT DISTINCT QuotationNumber, PublishTime FROM OrderCreateBuffer WHERE OrderGroupId = @OrderGroupId) T
	SELECT @LineCount = COUNT(1), @TotalQuantity = SUM(Quantity) FROM OrderCreateBuffer WHERE OrderGroupId = @OrderGroupId

	SELECT @OrderCount OrderCount, @LineCount LineCount, @TotalQuantity TotalQuantity
END
