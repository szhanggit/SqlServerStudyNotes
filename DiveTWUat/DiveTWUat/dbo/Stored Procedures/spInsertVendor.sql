
CREATE PROCEDURE [dbo].[spInsertVendor]
    @ProgramCode VARCHAR(20) ,
    @VendorCode VARCHAR(50) ,
    @Name NVARCHAR(200) ,
    @CallSetting NVARCHAR(MAX) ,
    @AssemblyCode VARCHAR(50)
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;


        IF ( NOT EXISTS ( SELECT    *
                          FROM      dbo.Vendor
                          WHERE     ProgramCode = @ProgramCode
                                    AND VendorCode = @VendorCode )
           )
            BEGIN
                INSERT  INTO dbo.Vendor
                        ( ProgramCode ,
                          VendorCode ,
                          Name ,
                          CallSetting ,
                          AssemblyCode ,
                          Status
                        )
                VALUES  ( @ProgramCode ,
                          @VendorCode ,
                          @Name ,
                          @CallSetting ,
                          @AssemblyCode ,
                          1
                        )
            END
        ELSE
            BEGIN
                UPDATE  dbo.Vendor
                SET     Name = @Name ,
                        CallSetting = @CallSetting
                WHERE   ProgramCode = @ProgramCode
                        AND VendorCode = @VendorCode

            END

    END

