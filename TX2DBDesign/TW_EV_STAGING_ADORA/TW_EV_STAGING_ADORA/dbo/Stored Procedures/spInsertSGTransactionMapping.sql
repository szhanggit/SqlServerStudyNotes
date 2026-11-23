
-- =============================================
-- Author:		Knight YAO
-- Create date: 2014/05/08
-- Description:	Insert sogo transaction and edenred transaction mapping
-- =============================================
CREATE PROCEDURE [dbo].[spInsertSGTransactionMapping] 
   @SGTranCode VARCHAR(50)
	,@AccountNumber VARCHAR(50)
	,@TranCode VARCHAR(50)
	,@ReloadType INT
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO SGTransactionMapping
	VALUES (
		@SGTranCode
		,@AccountNumber
		,@TranCode
		,@ReloadType
		)
END

