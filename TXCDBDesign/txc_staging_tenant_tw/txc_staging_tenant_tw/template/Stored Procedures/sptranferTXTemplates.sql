
Create PROCEDURE [template].[sptranferTXTemplates]
	@DataInputBasic [template].sourceTemplateBasicParameter Readonly,
	@DataInputVer [template].sourceTemplateVersionParameter Readonly,
	@TXTemplateType INT
AS
BEGIN

DECLARE @Map AS TABLE
(
    TempId int,
    InsertedId int
)

DECLARE @MapVersion AS TABLE
(
    TX2ConnectionId int,
    InsertedVersionId int
)

BEGIN TRANSACTION
BEGIN TRY
--email or sms
IF @TXTemplateType = 1 or @TXTemplateType = 2 or @TXTemplateType = 3
BEGIN
	MERGE INTO template.tb_t_template USING @DataInputBasic AS source 
        ON 1 = 0
    WHEN NOT MATCHED THEN
        INSERT (template_name
              , [type]
              , [sub_type]
			  , [status]
			  , [default_language]
        )
        VALUES (source.template_name
              , source.type 
              , source.[sub_type]
			  , source.[status]
			  , source.[default_language]
        )
        OUTPUT source.template_id, inserted.template_id 
        INTO @Map (TempId, InsertedId);

    INSERT INTO template.tb_t_template_version(
         template_id
       , language_id
       , [version]
       , is_current_version
	   , [description]
	   , subject1
	   , content1
	   , subject2
	   , content2
	   , subject3
	   , content3
	   , TX2ConnectionId
    )
	OUTPUT inserted.TX2ConnectionId, inserted.template_version_id INTO @MapVersion (TX2ConnectionId, InsertedVersionId)
    SELECT 
		InsertedId
        , language_id
		, [version]
		, is_current_version
		, [description]
		, subject1
		, content1
		, subject2
		, content2
		, subject3
		, content3
		, OD.template_version_id
    FROM @DataInputVer as OD
    INNER JOIN @Map as Map 
        ON OD.template_id = Map.TempId;
	
	SELECT MapVer.InsertedVersionId as ExternalTXCId, MapVer.TX2ConnectionId as TXConnectionId, @TXTemplateType as TXTemplateType FROM @MapVersion as MapVer 
END

COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
	SELECT ERROR_NUMBER(), ERROR_MESSAGE();
END CATCH

END
