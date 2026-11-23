
CREATE PROCEDURE [dbo].[spBulkUpdateSLMSMessageIsTracked]
@UpdatedTable TablePrimaryIdType READONLY,
@IsSuccess bit output
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE T1 SET T1.[IsTracked] = 1 FROM [dbo].[SLMSMessage] AS T1														 
					INNER JOIN @UpdatedTable ut ON T1.Id = ut.Id;
					
	set @IsSuccess = 1;
END;
