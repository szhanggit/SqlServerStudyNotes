CREATE PROCEDURE [dbo].[sp_ins_def_auth_key] 
@keyName nvarchar(8),
@keyValue nvarchar(256),
@success INT OUTPUT
AS
BEGIN
	
    BEGIN TRY

        BEGIN TRANSACTION;
		
		IF   
		(SELECT COUNT(*) FROM tb_def_auth_key WHERE key_name = @keyName) > 0
		BEGIN
			SET @success = 2
			ROLLBACK TRANSACTION
			RETURN
		END
		
		
		IF   
		(SELECT COUNT(*) FROM tb_def_auth_key) < 2  
			BEGIN
				
				INSERT INTO [dbo].[tb_def_auth_key]
						   ([key_name]
						   ,[key_value])
					 VALUES
						   (@keyName
						   ,@keyValue)
			
				SET @success = 1
				
			END
			
		ELSE 
			BEGIN
				SET @success = 3
			END

	
        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH 

       IF @@TRANCOUNT > 0
       BEGIN
          ROLLBACK TRANSACTION
       END;

	   THROW;
    END CATCH;

END