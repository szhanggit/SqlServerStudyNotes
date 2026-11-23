CREATE PROCEDURE spUpdateTX_KGB_Result_08062021  
 @Name NVARCHAR(200) NULL,  
 @Result BIGINT NULL,
 @AlertMessage NVARCHAR(2000) NULL
AS  
BEGIN  
    IF EXISTS(Select 1 From TX_KGB_Result_08062021 WHERE [Name] = @Name)  
    BEGIN  
        UPDATE TX_KGB_Result_08062021 Set Result = @Result, LastUpdateTime = GETDATE(), AlertMessage = @AlertMessage WHERE [Name] = @Name  
    END  
END  