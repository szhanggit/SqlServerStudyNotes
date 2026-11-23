
CREATE PROCEDURE [dbo].[spGetGROderBeneficiaryInfoId]
	@ProgramName nvarchar(255) = NULL,
	@GROrderID nvarchar(255) = NULL
AS
BEGIN
	SELECT Id FROM EXT_GR_OrderBeneficiaryInfo
	WHERE (@ProgramName IS NULL OR ProgramName = @ProgramName)
	AND (@GROrderID IS NULL OR GROrderID = @GROrderID)
END
