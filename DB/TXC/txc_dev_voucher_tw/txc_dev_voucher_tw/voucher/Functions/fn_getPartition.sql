/*
=================================================================================
Create user defined function for calculating partition number.
=================================================================================
*/

CREATE FUNCTION [voucher].[fn_getPartition]
(
    @input NVARCHAR(MAX),
	@partitionAmount INT
)
RETURNS INT
AS
BEGIN
    DECLARE @hashBinary VARBINARY(64)
    DECLARE @hashInt INT

    SET @hashBinary = HASHBYTES('SHA2_512', @input)
    SET @hashInt = CAST(CONVERT(VARBINARY(MAX), @hashBinary) AS INT)

    RETURN (ABS(@hashInt) % @partitionAmount + 1)
END