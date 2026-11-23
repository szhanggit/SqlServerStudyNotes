
CREATE PROCEDURE [dbo].[spCreateOrderGroup]
	@OrderGroupNumber VARCHAR(50),
	@UserName NVARCHAR(50),
	@AllowMixVoucherSupplierInOrder BIT,
	@GRGroupFileId INT = NULL
AS
BEGIN
	SET NOCOUNT, XACT_ABORT ON

	DECLARE @CurrentDateTime DATETIME = GETDATE()

	-- Prepare error table
	CREATE TABLE #ErrorTable
	(
		[Error] VARCHAR(4000),
		[Source] NVARCHAR(200)
	)

	DECLARE @EXT_GR_OrderBeneficiaryInfo TABLE
	(
		Id BIGINT,
		ProgramName NVARCHAR(255),
		GROrderID NVARCHAR(255),
		AwardBy NVARCHAR(255),
		SubProgram NVARCHAR(255),
		Misc1 NVARCHAR(255),
		Misc2 NVARCHAR(255),
		Misc3 NVARCHAR(255),
		CreatedOn DATETIME
	)

	-- Prepare order group info
	SELECT A.*,
		CONVERT(INT, NULL) ClientId,
		CONVERT(INT, NULL) ClientQuotationId,
		CONVERT(INT, NULL) ClientQuotationProductId,
		CONVERT(INT, NULL) ProductVersionId,
		CONVERT(INT, NULL) ProductDefaultEmailTemplateVersionId,
		CONVERT(INT, NULL) ProductDefaultEmailTemplateTagValueId,
		CONVERT(INT, NULL) ProductDefaultSLMSTemplateVersionId,
		CONVERT(INT, NULL) ProductDefaultSLMSTemplateTagValueId,
		CONVERT(INT, NULL) ProductCustomizedEmailTemplateVersionId,
		CONVERT(INT, NULL) ProductCustomizedSLMSTemplateVersionId,
		CONVERT(INT, NULL) EmailTemplateVersionId,
		CONVERT(INT, NULL) EmailTemplateTagValueId,
		CONVERT(INT, NULL) SLMSTemplateVersionId,
		CONVERT(INT, NULL) SLMSTemplateTagValueId,
		CONVERT(INT, NULL) VoucherReservationCodeId,
		D.Id AS  VoucherSupplierId,
		IsExclusive
	INTO #TEMP
	FROM OrderCreateBuffer A INNER JOIN OrderGroup B
		ON A.OrderGroupId = B.Id
		INNER JOIN Product C ON A.ProductCode = C.ProductCode
		LEFT JOIN VoucherSupplier D ON C.VoucherSupplierId = D.Id
	WHERE B.OrderGroupNumber = @OrderGroupNumber
		AND B.Status = 1 -- Draft

	-- Return if order group not found
	IF ((SELECT COUNT(1) FROM #TEMP) = 0)
	BEGIN
		INSERT INTO #ErrorTable
		SELECT 'InvalidOrderGroupNumber', CONVERT(VARCHAR, @OrderGroupNumber)
		DROP TABLE #TEMP

		SELECT * FROM #ErrorTable
		DROP TABLE #ErrorTable
		RETURN
	END

	BEGIN TRY
		-- Lookup client id and client quotation id
		UPDATE #TEMP SET ClientId = A.ClientId, ClientQuotationId = A.Id
		FROM ClientQuotation A
		WHERE #TEMP.QuotationNumber = A.QuotationNumber

		-- Prepare quotation product mapping lookup
		-- Change to use default language after  
		SELECT A.QuotationNumber
			, E.ProductCode
			, C.Id
			, C.ProductVersionId
			--, E.EmailTemplateVersionId
			, F.EmailTemplateVersionId
			--, E.EmailTemplateTagValueId
			, F.EmailTemplateTagValueId
			--, E.SLMSTemplateVersionId
			, G.SLMSTemplateVersionId
			--, E.SLMSTemplateTagValueId
			, G.SLMSTemplateTagValueId
			, E.ProductCustomizedEmailTemplateVersionId
			, E.ProductCustomizedSLMSTemplateVersionId
		INTO #QuotationProduct
		FROM (SELECT DISTINCT QuotationNumber FROM #TEMP) A
		INNER JOIN ClientQuotation B ON A.QuotationNumber = B.QuotationNumber
		INNER JOIN ClientQuotationProduct C ON B.Id = C.ClientQuotationId
		INNER JOIN ProductVersion D ON D.Id = C.ProductVersionId
		INNER JOIN Product E ON E.Id = D.ProductId
		LEFT JOIN (SELECT t1.*  
		           FROM ProductEmailTemplateVersionSet t1 JOIN EmailTemplateVersion t2 ON t1.EmailTemplateVersionId = t2.Id
		                JOIN EmailTemplate t3 ON t3.Id = t2.TemplateId AND t2.LanguageId = t3.DefaultLanguageId) F ON E.ProductEmailTemplateVersionId = F.ProductEmailTemplateVersionId
		LEFT JOIN (SELECT t1.*  
		           FROM ProductSLMSTemplateVersionSet t1 JOIN SLMSTemplateVersion t2 ON t1.SLMSTemplateVersionId = t2.Id
		                JOIN SLMSTemplate t3 ON t3.Id = t2.TemplateId AND t2.LanguageId = t3.DefaultLanguageId) G ON E.ProductSLMSTemplateVersionId = G.ProductSLMSTemplateVersionId

		-- Lookup client quotation product id and product version id
		UPDATE #TEMP SET 
			ClientQuotationProductId = A.Id, 
			ProductVersionId = A.ProductVersionId,
			ProductDefaultEmailTemplateVersionId = A.EmailTemplateVersionId,
			ProductDefaultEmailTemplateTagValueId = A.EmailTemplateTagValueId,
			ProductDefaultSLMSTemplateVersionId = A.SLMSTemplateVersionId,
			ProductDefaultSLMSTemplateTagValueId = A.SLMSTemplateTagValueId,
			ProductCustomizedEmailTemplateVersionId = A.ProductCustomizedEmailTemplateVersionId,
			ProductCustomizedSLMSTemplateVersionId = A.ProductCustomizedSLMSTemplateVersionId
		FROM #QuotationProduct A
		WHERE #TEMP.QuotationNumber = A.QuotationNumber AND #TEMP.ProductCode = A.ProductCode

		DROP TABLE #QuotationProduct

		-- Lookup voucher reservation code id
		UPDATE #TEMP SET VoucherReservationCodeId = A.Id
		FROM VoucherReservationCode A
		WHERE #TEMP.ReservationCode = A.ReservationCode

		-- Assign default voucher reservation code id
		UPDATE #TEMP SET VoucherReservationCodeId = A.Id
		FROM VoucherReservationCode A
		WHERE A.ReservationCode = '#N/A'
		AND #TEMP.VoucherReservationCodeId IS NULL

		-- Lookup customized email template
		UPDATE #TEMP SET EmailTemplateVersionId = A.EmailTemplateVersionId, EmailTemplateTagValueId = A.EmailTemplateTagValueId
		FROM ProductCustomizedEmailTemplateVersionSet A
		WHERE #TEMP.ProductCustomizedEmailTemplateVersionId = A.ProductCustomizedEmailTemplateVersionId
		AND #TEMP.ClientId = A.ClientId

		-- Assign default email template if no customized template found
		UPDATE #TEMP SET EmailTemplateVersionId = ProductDefaultEmailTemplateVersionId, EmailTemplateTagValueId = ProductDefaultEmailTemplateTagValueId
		WHERE EmailTemplateVersionId IS NULL

		-- Lookup customized SLMS template
		UPDATE #TEMP SET SLMSTemplateVersionId = A.SLMSTemplateVersionId, SLMSTemplateTagValueId = A.SLMSTemplateTagValueId
		FROM ProductCustomizedSLMSTemplateVersionSet A
		WHERE #TEMP.ProductCustomizedSLMSTemplateVersionId = A.ProductCustomizedSLMSTemplateVersionId
		AND #TEMP.ClientId = A.ClientId

		-- Assign default SLMS template if no customized template found
		UPDATE #TEMP SET SLMSTemplateVersionId = ProductDefaultSLMSTemplateVersionId, SLMSTemplateTagValueId = ProductDefaultSLMSTemplateTagValueId
		WHERE SLMSTemplateVersionId IS NULL

		DECLARE @QuotationNumber VARCHAR(50)
		DECLARE @PublishTime DATETIME
		DECLARE @OrderSequence INT
		DECLARE @OrderNumber VARCHAR(50)
		DECLARE @OrderId INT
		DECLARE @ProductCode VARCHAR(50)
		DECLARE @OrderLineId INT
		DECLARE @VoucherSupplierId INT
		DECLARE @VoucherSupplierQuotationNumber VARCHAR(50)
		DECLARE @OrderEmailTemplateTagValueId INT
		DECLARE @OrderEmailTemplateVersionId INT
		DECLARE @OrderSLMSTemplateTagValueId INT
		DECLARE @OrderSLMSTemplateVersionId INT

		DECLARE @orderGroupId INT = (SELECT Id FROM dbo.OrderGroup WITH(NOLOCK) WHERE OrderGroupNumber = @OrderGroupNumber);

		DECLARE @TRANCOUNT INT
		SET @TRANCOUNT = @@TRANCOUNT

		IF @TRANCOUNT = 0
			BEGIN TRANSACTION
		ELSE
			SAVE TRANSACTION spCreateOrderGroup

			-- Loop through order
			WHILE EXISTS(SELECT 1 FROM #TEMP WHERE OrderId IS NULL)
			BEGIN
				IF((SELECT TOP 1 IsExclusive FROM #TEMP WHERE OrderId IS NULL) = 1)
				BEGIN
					-- Get quotation number and publish time
					SELECT TOP 1 @QuotationNumber = QuotationNumber, @PublishTime = PublishTime,@VoucherSupplierId = VoucherSupplierId,@VoucherSupplierQuotationNumber = VoucherSupplierQuotationNumber FROM #TEMP WHERE OrderId IS NULL AND IsExclusive = 1
				END

				ELSE
				BEGIN
					IF(@AllowMixVoucherSupplierInOrder = 1)
					BEGIN
						-- Get quotation number and publish time
						SELECT TOP 1 @QuotationNumber = QuotationNumber, @PublishTime = PublishTime,@VoucherSupplierId = VoucherSupplierId,@VoucherSupplierQuotationNumber = VoucherSupplierQuotationNumber FROM #TEMP WHERE OrderId IS NULL AND (IsExclusive = 0 OR ISNULL(VouchersupplierId, 0) = 0)
					END

					--Don't Allow Mix
					ELSE
					BEGIN
						IF((SELECT TOP 1 IsExclusive FROM #TEMP WHERE OrderId IS NULL) = 0)
						BEGIN
							 -- Get quotation number and publish time
							SELECT TOP 1 @QuotationNumber = QuotationNumber, @PublishTime = PublishTime,@VoucherSupplierId = VoucherSupplierId,@VoucherSupplierQuotationNumber = VoucherSupplierQuotationNumber FROM #TEMP WHERE OrderId IS NULL AND IsExclusive = 0
						END
						IF((SELECT TOP 1 ISNULL(VoucherSupplierId, 0) FROM #TEMP WHERE OrderId IS NULL) = 0)
						BEGIN 
							-- Get quotation number and publish time
							SELECT TOP 1 @QuotationNumber = QuotationNumber, @PublishTime = PublishTime,@VoucherSupplierId = VoucherSupplierId,@VoucherSupplierQuotationNumber = VoucherSupplierQuotationNumber FROM #TEMP WHERE OrderId IS NULL AND ISNULL(VouchersupplierId, 0)  = 0
						END
					END
				END

				-- Generate order number
				SELECT @OrderSequence = NEXT VALUE FOR Seq_OrderNumber
				SET @OrderNumber = CONVERT(VARCHAR,GETDATE(),112) + RIGHT(('0000' + CONVERT(VARCHAR,@OrderSequence)), 4)

				-- Insert order table
				INSERT INTO dbo.[Order]
				(
					ClientQuotationId,
					OrderNumber,
					Mode,
					IsDirectDelivery,
					PublishDatetime,
					Status,
					ExecutingStatus,
					ExecutingResponse,
					CreatedBy,
					CreatedOn,
					PackageReceiver,
					PackagePassword,
					OrderName,
					ShortUrlAuthCodeGenerationWay,
					OrderGroupId,
				    MWVEmailTemplate,
					VoucherSupplierId,
					VoucherSupplierQuotationNumber
				)
				SELECT DISTINCT
					ClientQuotationId,
					@OrderNumber,
					1, -- Mode (Non-API)
					1, -- IsDirectDelivery
					@PublishTime,
					IIF(@GRGroupFileId IS NULL,2,8), -- Status (Created=2 Approved=8)
					1, -- Executing Status (Not Started)
					NULL, -- Executing Response
					@UserName, -- CreatedBy
					GETDATE(), -- CreatedOn
					NULL, -- PackageReceiver
					NULL, -- PackagePassword
					'', -- Order Name
					0, -- Short Url Auth Code Generation Way (AutoGenerate)
					OrderGroupId,
					CASE WHEN @VoucherSupplierId = 2 THEN 2
					ELSE 1 END,
					@VoucherSupplierId,
					@VoucherSupplierQuotationNumber
				FROM #TEMP WHERE QuotationNumber = @QuotationNumber AND PublishTime = @PublishTime AND ISNULL(VoucherSupplierId, 0) = ISNULL(@VoucherSupplierId, 0) AND VoucherSupplierQuotationNumber = @VoucherSupplierQuotationNumber

				-- Get order id
				SELECT @OrderId = SCOPE_IDENTITY()

				IF @GRGroupFileId IS NOT NULL
				BEGIN
					INSERT dbo.OrderStatusHistory(OrderId,Operation,Comment,Operator,OperationTime)
						VALUES(@OrderId, 8, N'GRAutoCreateOrderGroupJob', N'spCreateOrderGroup', GETDATE())
				END

				-- Write back order id
				UPDATE #TEMP SET OrderId = @OrderId WHERE QuotationNumber = @QuotationNumber AND PublishTime = @PublishTime AND ISNULL(VoucherSupplierId, 0) = ISNULL(@VoucherSupplierId, 0) AND VoucherSupplierQuotationNumber = @VoucherSupplierQuotationNumber

				-- Loop through order line
				WHILE EXISTS(SELECT 1 FROM #TEMP WHERE OrderId = @OrderId AND OrderLineId IS NULL)
				BEGIN
					-- Get product code
					SELECT TOP 1 @ProductCode = ProductCode FROM #TEMP WHERE OrderId = @OrderId AND OrderLineId IS NULL

					-- Insert order line table
					INSERT INTO OrderLine
					(
						OrderId,
						ClientQuotationProductId,
						TotalQuantity,
						EmailQuantity,
						SLMSQuantity,
						EmailTemplateVersionId,
						SLMSTemplateVersionId,
						DefaultExpirationDate,
						VoucherReservationCodeId,
						NeedShortUrl,
						Status
					)
					SELECT
						@OrderId,
						ClientQuotationProductId,
						SUM(Quantity), -- Total Quantity
						0, -- Email Quantity
						0, -- SLMS Quantity
						NULL,
						NULL,
						NULL, -- Default Expiration Date
						VoucherReservationCodeId,
						0, -- Need Short Url
						1 -- Status (Active)
					FROM #TEMP
					WHERE OrderId = @OrderId AND ProductCode = @ProductCode
					GROUP BY ClientQuotationProductId, EmailTemplateVersionId, SLMSTemplateVersionId, VoucherReservationCodeId

					-- Get order line id
					SELECT @OrderLineId = SCOPE_IDENTITY()

					-- Write back order line id
					UPDATE #TEMP SET OrderLineId = @OrderLineId WHERE OrderId = @OrderId AND ProductCode = @ProductCode

					-- Insert email content tag value set
					-- just with one defulat language
					INSERT INTO OrderEmailTemplateVersion DEFAULT VALUES
					SELECT @OrderEmailTemplateVersionId = SCOPE_IDENTITY()

					INSERT INTO OrderEmailTemplateTagValue DEFAULT VALUES
					SELECT @OrderEmailTemplateTagValueId = SCOPE_IDENTITY()

					INSERT INTO OrderEmailTemplateVersionSet
					        ( OrderEmailTemplateVersionId ,
					          EmailTemplateVersionId ,
					          EmailTemplateTagValueId
					        )
				    SELECT DISTINCT @OrderEmailTemplateVersionId
					      ,EmailTemplateVersionId
						  ,@OrderEmailTemplateTagValueId
					FROM #TEMP
					WHERE OrderId = @OrderId AND ProductCode = @ProductCode

					INSERT INTO OrderEmailTemplateTagValueSet
					        ( ContentTagId ,
					          OrderEmailTemplateTagValueId ,
					          Value
					        )
					SELECT DISTINCT B.ContentTagId
					     , @OrderEmailTemplateTagValueId
						 , B.[Value]
					FROM #TEMP A
					INNER JOIN ProductEmailContentTagValueSet B
						ON A.EmailTemplateTagValueId = B.ProductEmailTemplateTagValueId
					WHERE A.OrderId = @OrderId AND A.ProductCode = @ProductCode
						AND A.EmailTemplateTagValueId IS NOT NULL

					--GR Client_logo_header Client_logo_footer
					DECLARE @headerMId VARCHAR(10) = NULL;
					DECLARE @footerMId VARCHAR(10) = NULL;
					DECLARE @clientId int;
					SELECT @headerMId = EmailHeaderMId, @footerMId = EmailFooterMId, @clientId = ClientId FROM dbo.ClientQuotation WHERE QuotationNumber = @QuotationNumber
					IF @headerMId IS NULL
						SELECT @headerMId = EmailHeaderMId FROM dbo.Client WHERE Id = @clientId
					IF @footerMId IS NULL
						SELECT @footerMId = EmailFooterMId FROM dbo.Client WHERE Id = @clientId
					
					UPDATE tagSet SET tagSet.Value = @headerMId 
						FROM dbo.OrderEmailTemplateTagValueSet tagSet
						JOIN dbo.ContentTag tag ON tag.Id = tagSet.ContentTagId
						WHERE tag.TagName = '{Client_logo_header}' AND tagset.OrderEmailTemplateTagValueId = @OrderEmailTemplateTagValueId

					UPDATE tagSet SET tagSet.Value = @footerMId 
						FROM dbo.OrderEmailTemplateTagValueSet tagSet
						JOIN dbo.ContentTag tag ON tag.Id = tagSet.ContentTagId
						WHERE tag.TagName = '{Client_logo_footer}' AND tagset.OrderEmailTemplateTagValueId = @OrderEmailTemplateTagValueId

                    -- Insert SLMS content tag value set
					-- Just with one default language
                    INSERT INTO OrderSLMSTemplateVersion DEFAULT VALUES
					SELECT @OrderSLMSTemplateVersionId = SCOPE_IDENTITY()

					INSERT INTO OrderSLMSTemplateTagValue DEFAULT VALUES
					SELECT @OrderSLMSTemplateTagValueId = SCOPE_IDENTITY()

					INSERT INTO OrderSLMSTemplateVersionSet
					        ( OrderSLMSTemplateVersionId ,
					          SLMSTemplateVersionId ,
					          SLMSTemplateTagValueId
					        )
				    SELECT DISTINCT @OrderSLMSTemplateVersionId
						  ,SLMSTemplateVersionId
						  ,@OrderSLMSTemplateTagValueId
					FROM #TEMP
					WHERE OrderId = @OrderId AND ProductCode = @ProductCode

					INSERT INTO OrderSLMSTemplateTagValueSet
					        ( ContentTagId ,
					          OrderSLMSTemplateTagValueId ,
					          Value
					        )
					SELECT DISTINCT B.ContentTagId
					     , @OrderSLMSTemplateTagValueId
						 , B.[Value]
					FROM #TEMP A INNER JOIN ProductSLMSContentTagValueSet B
						ON A.SLMSTemplateTagValueId = B.ProductSLMSTemplateTagValueId
					WHERE A.OrderId = @OrderId AND A.ProductCode = @ProductCode
						AND A.SLMSTemplateTagValueId IS NOT NULL

					UPDATE dbo.OrderLine
					SET OrderEmailTemplateVersionId = @OrderEmailTemplateVersionId
					  , OrderSLMSTemplateVersionId = @OrderSLMSTemplateVersionId
					WHERE Id = @OrderLineId
					--INSERT INTO OrderEmailContentTagValueSet
					--SELECT DISTINCT B.ContentTagId, @OrderLineId, B.[Value]
					--FROM #TEMP A
					--INNER JOIN ProductEmailContentTagValueSet B
					--	ON A.EmailTemplateTagValueId = B.ProductEmailTemplateTagValueId
					--WHERE A.OrderId = @OrderId AND A.ProductCode = @ProductCode
					--	AND A.EmailTemplateTagValueId IS NOT NULL
					
					---- Insert SLMS content tag value set
					--INSERT INTO OrderSLMSContentTagValueSet
					-- SELECT DISTINCT B.ContentTagId, @OrderLineId, B.[Value]
					--FROM #TEMP A
					--INNER JOIN ProductSLMSContentTagValueSet B
					--	ON A.SLMSTemplateTagValueId = B.ProductSLMSTemplateTagValueId
					--WHERE A.OrderId = @OrderId AND A.ProductCode = @ProductCode
					--	AND A.SLMSTemplateTagValueId IS NOT NULL
				END
			END

			-- Insert order beneficiary info table and output extension info into to variable
			MERGE INTO OrderBeneficiaryInfo
			USING #TEMP AS T
			ON 1 = 0
			WHEN NOT MATCHED THEN INSERT
			(
				OrderLineId,
				Mobile,
				Email,
				VoucherQuantity,
				ActiveDate,
				ExpirySchemeId,
				ExpiryDate,
				ClientOrderNumber,
				Memo,
				ProductVersionId,
				Name,
				Address,
				PostCode,
				EDOrderNumber,
				MemberId
			)
			VALUES
			(
				T.OrderLineId,
				T.Mobile,
				T.Email,
				T.Quantity,
				@CurrentDateTime, -- Active Date
				T.ExpiryDateType,
				T.ExpiryDate,
				T.ClientOrderNumber,
				T.Memo,
				T.ProductVersionId,
				T.BeneficiaryName, -- Name
				NULL, -- Address
				NULL, -- Postcode
				NULL, -- ED Order Number
				NULL -- Member Id
			)
			OUTPUT inserted.Id, T.ProgramName, T.GROrderID, T.AwardBy, T.SubProgram, T.Misc1, T.Misc2, T.Misc3, @CurrentDateTime INTO @EXT_GR_OrderBeneficiaryInfo;

			-- Insert extension info into table
			INSERT INTO EXT_GR_OrderBeneficiaryInfo (Id, ProgramName, GROrderID, AwardBy, SubProgram, Misc1, Misc2, Misc3, CreatedOn)
			SELECT Id, ProgramName, GROrderID, AwardBy, SubProgram, Misc1, Misc2, Misc3, CreatedOn
			FROM @EXT_GR_OrderBeneficiaryInfo

			-- Write order id and order line id back to table
			UPDATE OrderCreateBuffer SET OrderId = A.OrderId, OrderLineId = A.OrderLineId
			FROM #TEMP A
			WHERE OrderCreateBuffer.Id = A.Id

			DROP TABLE #TEMP

			-- Update order group status to 2 (Created)
			IF @GRGroupFileId IS NULL
				UPDATE OrderGroup SET [Status] = 2 WHERE OrderGroupNumber = @OrderGroupNumber
			ELSE
				UPDATE OrderGroup SET [Status] = 8, ApprovedBy = 'GRAutoCreateOrderGroupJob', ApprovedOn = GETDATE() WHERE OrderGroupNumber = @OrderGroupNumber

			IF @GRGroupFileId IS NOT NULL
			BEGIN
				DECLARE @rowCount INT = 0;
				DECLARE @totalCount INT = 0;
				SELECT @rowCount = COUNT(1), @totalCount = SUM(Quantity) FROM dbo.OrderCreateBuffer WITH(NOLOCK) WHERE OrderGroupId = @OrderGroupId 

				UPDATE GROrderGroupFile SET OrderGroupNumber = @OrderGroupNumber, OrderCount = @rowCount, TotalCount = @totalCount, [Status] = 1, Reason = @OrderGroupNumber WHERE Id = @GRGroupFileId;
			END

		COMMIT
	END TRY
	BEGIN CATCH
		DECLARE @error int, @message varchar(4000), @xstate int;
        SELECT @error = ERROR_NUMBER(),
               @message = ERROR_MESSAGE(), 
               @xstate = XACT_STATE();

		if @xstate = -1
            rollback;
        if @xstate = 1 and @trancount = 0
            rollback
        if @xstate = 1 and @trancount > 0
            rollback transaction spCreateOrderGroup;

		INSERT INTO #ErrorTable
		SELECT CONVERT(varchar, @error) + '_' + @message, ERROR_PROCEDURE()

		IF @GRGroupFileId IS NOT NULL
		BEGIN
			DECLARE @errorMessage VARCHAR(50) = @message;
			UPDATE GROrderGroupFile SET OrderGroupNumber = @OrderGroupNumber, OrderCount = 0, TotalCount = 0, [Status] = 2, Reason = @errorMessage WHERE Id = @GRGroupFileId;
		END
	END CATCH

	SELECT * FROM #ErrorTable
	DROP TABLE #ErrorTable
END
