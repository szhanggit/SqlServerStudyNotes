
CREATE PROCEDURE [dbo].[spGenerateDistributionTaskMessageVouchers]
    @DistributionTaskId BIGINT ,
    @IsSuccess BIT OUTPUT
AS
    BEGIN
        SET NOCOUNT ON;

        BEGIN TRAN

        BEGIN TRY
            INSERT  INTO dbo.DistributionTaskMessageVoucher
                    ( DistributionTaskMessageId ,
                      VoucherId
                    )
                    SELECT  Id ,
                            VoucherId
                    FROM    dbo.DistributionTaskMessage
                    WHERE   DistributionTaskId = @DistributionTaskId
            UPDATE  dbo.DistributionTaskMessage
            SET     VoucherId = NULL
            WHERE   DistributionTaskId = @DistributionTaskId
		
        END TRY
        BEGIN CATCH
            ROLLBACK TRAN
            SET @IsSuccess = 0
            RETURN
        END CATCH

        COMMIT TRAN

        SET @IsSuccess = 1
    END

