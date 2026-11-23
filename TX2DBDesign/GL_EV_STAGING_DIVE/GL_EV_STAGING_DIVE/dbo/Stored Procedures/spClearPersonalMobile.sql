
CREATE PROCEDURE spClearPersonalMobile
	-- Add the parameters for the stored procedure here
    @ClearDate DateTime
AS
    BEGIN
		SET NOCOUNT ON;
		DECLARE @minId BIGINT
        DECLARE @maxId BIGINT
        DECLARE @stepStart BIGINT
        DECLARE @stepEnd BIGINT
        DECLARE @to NVARCHAR(20)
        DECLARE @content NVARCHAR(50)

        select @to = '99'+CONVERT(nvarchar(10) , getdate(), 112 )
        select @content = CONVERT(nvarchar(10) , getdate(), 112 )+'auditorremove'
			
		select @minId = min(Id),@maxId = max(Id)  from SLMSMessageArchive with(nolock) where SentOn between @ClearDate and DATEADD(DAY,1,@ClearDate)
        set @stepStart =@minId;
        set @stepEnd =@stepStart+3000;
        
		while @stepStart <= @maxId
		begin
			IF @stepEnd>@maxId
            BEGIN
                set @stepEnd=@maxId
            END
            update SLMSMessageArchive set [MobilePhone] = @to,Parameters = @content where Id between @stepStart and @stepEnd

            set @stepStart =@stepEnd+1;
            set @stepEnd =@stepStart+3000;
		end
		
    END
