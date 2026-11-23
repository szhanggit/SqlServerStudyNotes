CREATE PROCEDURE [dbo].[spCSSQueryVouchers]
    @VoucherNumber VARCHAR(50) = NULL ,
    @ClientOrderNo VARCHAR(50) = NULL ,
    @Email VARCHAR(100) = NULL ,
    @Mobile VARCHAR(50) = NULL ,
	@ShortUrl VARCHAR(20) = NULL,
	@GUID VARCHAR(50) = NULL,
	@ActiveDate datetime = NULL,
	@VoucherStatus int = NULL,
    @CSUserId INT ,
    @PageIndex INT ,
    @PageSize INT
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @CSUserRole INT
		DECLARE @SQLText NVARCHAR(MAX)

		--CSUserRole=1:Normal		--can see self client record, and return part columns
		--CSUserRole=2:Admin		--can see all record,and return part columns
		--CSUserRole=3:OutSource	--can see all record,and return more columns
		--CSUserRole=4:NormaWithTrash

		--MessageStatus:
        --Initialized = 1,
        --Sending = 2, 
        --SentSuccess = 3,
        --SentFailed = 4,
        --ToBeResent = 5,
        --Trashed = 6,
        --Unknown = 7

        SELECT @CSUserRole = CSUserRole FROM dbo.CSUser WHERE Id = @CSUserId

        IF @CSUserRole = 1 or @CSUserRole = 4
            BEGIN

			DECLARE @childVoucherId BIGINT = 0;
			IF @VoucherNumber is not NULL
            BEGIN
				SELECT @childVoucherId = v.Id FROM dbo.Voucher v WITH(NOLOCK)
						INNER JOIN dbo.VoucherCombo vc WITH(NOLOCK) ON vc.ChildVoucherId = v.Id
						INNER JOIN dbo.Voucher v2  WITH(NOLOCK) ON vc.MasterVoucherId = v2.Id
                        INNER JOIN dbo.OrderBeneficiaryInfo obi WITH (NOLOCK) ON v2.BeneficiaryInfoId = obi.Id
                        INNER JOIN dbo.OrderLine ol WITH (NOLOCK) ON obi.OrderLineId = ol.Id
                        INNER JOIN dbo.[Order] o WITH (NOLOCK) ON ol.OrderId = o.Id
                        INNER JOIN dbo.ClientQuotation cq WITH (NOLOCK) ON o.ClientQuotationId = cq.Id
                        INNER JOIN dbo.Client c WITH (NOLOCK) ON cq.ClientId = c.Id
						INNER JOIN dbo.CSUserClient CC WITH (NOLOCK) ON C.Id = CC.ClientId
                        INNER JOIN dbo.CSUser CSU WITH (NOLOCK) ON CC.CSUserId = CSU.Id
						WHERE v.VoucherNumber = @VoucherNumber AND CSU.Id = @CSUserId AND vc.[Status] = 1
			END

			 Set @SQLText = 
                'SELECT  v.Id AS VoucherId ,
                        v.VoucherNumber ,
                        o.OrderName ,
                        o.OrderNumber ,
                        CASE WHEN o.Mode = 1 THEN ''Non-API''
                             WHEN o.Mode = 2 THEN ''API''
                             WHEN o.Mode = 3 THEN ''PaperVoucher''
                             ELSE ''''
                        END AS OrderMode ,
                        IIF(v.BeneficiaryInfoId IS NULL, p.ProductName, REPLACE(p.ProductName, ''{FV}'', FORMAT(ISNULL(obi.FaceValueWithTax, 0) / 100.0,''0.##''))) ProductName,
						p.ProductCode,
                        cq.ProjectName ,
                        obi.ClientOrderNumber ,
                        v.ActivatedOn ActiveDate,
						v.ShortUrl ShortUrl,
						CASE WHEN v.DistributionEmailStatus = 1 THEN ''Initialized''
                             WHEN v.DistributionEmailStatus = 2 THEN ''Sending''
                             WHEN v.DistributionEmailStatus = 3 THEN ''SentSuccess''
							 WHEN v.DistributionEmailStatus = 4 THEN ''SentFailed''
                             WHEN v.DistributionEmailStatus = 5 THEN ''ToBeResent''
							 WHEN v.DistributionEmailStatus = 6 THEN ''Trashed''
                             ELSE '''' 
						END AS DistributionEmailStatus,
						CASE WHEN v.DistributionSLMSStatus = 1 THEN ''Initialized''
                             WHEN v.DistributionSLMSStatus = 2 THEN ''Sending''
                             WHEN v.DistributionSLMSStatus = 3 THEN ''SentSuccess''
							 WHEN v.DistributionSLMSStatus = 4 THEN ''SentFailed''
                             WHEN v.DistributionSLMSStatus = 5 THEN ''ToBeResent''
							 WHEN v.DistributionSLMSStatus = 6 THEN ''Trashed''
                             ELSE '''' 
						END AS DistributionSLMSStatus
                FROM    Voucher v WITH(NOLOCK)
                        INNER JOIN OrderBeneficiaryInfo obi WITH (NOLOCK) ON v.BeneficiaryInfoId = obi.Id
                        INNER JOIN OrderLine ol WITH (NOLOCK) ON obi.OrderLineId = ol.Id
                        INNER JOIN [Order] o WITH (NOLOCK) ON ol.OrderId = o.Id
                        INNER JOIN Product p WITH (NOLOCK) ON v.ProductId = p.Id
                        INNER JOIN ClientQuotation cq WITH (NOLOCK) ON o.ClientQuotationId = cq.Id
                        INNER JOIN Client c WITH (NOLOCK) ON cq.ClientId = c.Id
                        LEFT JOIN CSUserClient CC WITH (NOLOCK) ON C.Id = CC.ClientId
                        LEFT JOIN CSUser CSU WITH (NOLOCK) ON CC.CSUserId = CSU.Id
						LEFT JOIN CSUserClientQuotation CCQ WITH(NOLOCK) ON CCQ.CSUserId = CSU.Id
                WHERE'
			IF @childVoucherId = 0
				SET @SQLText = @SQLText + ' CSU.Id = ' + cast(@CSUserId as varchar(20))
			ELSE
				SET @SQLText = @SQLText + ' (CSU.Id = ' + cast(@CSUserId as varchar(20)) + ' Or v.Id = ' + cast(@childVoucherId as varchar(20)) + ' ) '; 

			if @VoucherNumber is not null
			   set @SQLText = @SQLText + ' and v.VoucherNumber = '''+ @VoucherNumber + ''''
            
			if @ClientOrderNo is not null
               set @SQLText = @SQLText + ' and obi.ClientOrderNumber = ''' + @ClientOrderNo + ''''

            if @Email is not null
               set @SQLText = @SQLText + ' and obi.Email = ''' + @Email + ''''

            if @Mobile is not null
               set @SQLText = @SQLText + ' and obi.Mobile = ''' + @Mobile +  ''''
            
			if @ShortUrl is not null
				set @SQLText = @SQLText + ' and v.ShortUrl = ''' + @ShortUrl +  ''''

			if @GUID is not null
				set @SQLText = @SQLText + ' and v.[GUID] = ''' + @GUID +  ''''

			set @SQLText = @SQLText +        
                ' and ((CCQ.ID IS NULL) OR (CCQ.ID IS NOT NULL AND CCQ.QuotationId = CQ.Id)) '

			set @SQLText = @SQLText +        
                ' ORDER BY obi.Id DESC
                        OFFSET '
						
			set @SQLText = @SQLText + cast(@PageIndex as varchar(20)) + '*' +  cast(@PageSize as varchar(20)) +  ' ROWS'  
			set @SQLText = @SQLText + ' FETCH NEXT ' + cast(@PageSize as varchar(20)) + ' ROWS ONLY' 
		    
			exec (@SQLText)
				
            END
        IF @CSUserRole = 2
            BEGIN
                
			 Set @SQLText = 
                'SELECT  v.Id AS VoucherId ,
                        v.VoucherNumber ,
                        o.OrderName ,
                        o.OrderNumber ,
                        CASE WHEN o.Mode = 1 THEN ''Non-API''
                             WHEN o.Mode = 2 THEN ''API''
                             WHEN o.Mode = 3 THEN ''PaperVoucher''
                             ELSE ''''
                        END AS OrderMode ,
                        IIF(v.BeneficiaryInfoId IS NULL, p.ProductName, REPLACE(p.ProductName, ''{FV}'', FORMAT(ISNULL(obi.FaceValueWithTax, 0) / 100.0,''0.##''))) ProductName,
						p.ProductCode,
                        cq.ProjectName ,
                        obi.ClientOrderNumber ,
						v.ActivatedOn ActiveDate,
						v.ShortUrl ShortUrl,
						CASE WHEN v.DistributionEmailStatus = 1 THEN ''Initialized''
                             WHEN v.DistributionEmailStatus = 2 THEN ''Sending''
                             WHEN v.DistributionEmailStatus = 3 THEN ''SentSuccess''
							 WHEN v.DistributionEmailStatus = 4 THEN ''SentFailed''
                             WHEN v.DistributionEmailStatus = 5 THEN ''ToBeResent''
							 WHEN v.DistributionEmailStatus = 6 THEN ''Trashed''
                             ELSE '''' 
						END AS DistributionEmailStatus,
						CASE WHEN v.DistributionSLMSStatus = 1 THEN ''Initialized''
                             WHEN v.DistributionSLMSStatus = 2 THEN ''Sending''
                             WHEN v.DistributionSLMSStatus = 3 THEN ''SentSuccess''
							 WHEN v.DistributionSLMSStatus = 4 THEN ''SentFailed''
                             WHEN v.DistributionSLMSStatus = 5 THEN ''ToBeResent''
							 WHEN v.DistributionSLMSStatus = 6 THEN ''Trashed''
                             ELSE '''' 
						END AS DistributionSLMSStatus
                FROM    Voucher v WITH(NOLOCK)
                        INNER JOIN OrderBeneficiaryInfo obi WITH (NOLOCK) ON v.BeneficiaryInfoId = obi.Id
                        INNER JOIN OrderLine ol WITH (NOLOCK) ON obi.OrderLineId = ol.Id
                        INNER JOIN [Order] o WITH (NOLOCK) ON ol.OrderId = o.Id
                        INNER JOIN Product p WITH (NOLOCK) ON v.ProductId = p.Id
                        INNER JOIN ClientQuotation cq WITH (NOLOCK) ON o.ClientQuotationId = cq.Id
                WHERE 1 = 1'

			if @VoucherNumber is not null
			   set @SQLText = @SQLText + ' and v.VoucherNumber = '''+ @VoucherNumber + ''''
            
			if @ClientOrderNo is not null
               set @SQLText = @SQLText + ' and obi.ClientOrderNumber = ''' + @ClientOrderNo + ''''

            if @Email is not null
               set @SQLText = @SQLText + ' and obi.Email = ''' + @Email + ''''

            if @Mobile is not null
               set @SQLText = @SQLText + ' and obi.Mobile = ''' + @Mobile +  ''''

			if @ShortUrl is not null
				set @SQLText = @SQLText + ' and v.ShortUrl = ''' + @ShortUrl +  ''''

			if @GUID is not null
				set @SQLText = @SQLText + ' and v.[GUID] = ''' + @GUID +  ''''

			set    @SQLText = @SQLText +        
                ' ORDER BY obi.Id DESC
                        OFFSET '
						
			set @SQLText = @SQLText + cast(@PageIndex as varchar(20)) + '*' +  cast(@PageSize as varchar(20)) +  ' ROWS'  
			set @SQLText = @SQLText + ' FETCH NEXT ' + cast(@PageSize as varchar(20)) + ' ROWS ONLY' 
		    
			exec (@SQLText)
            END

		IF @CSUserRole = 3
		BEGIN      
			Set @SQLText = 
			'SELECT  v.Id AS VoucherId ,
					v.VoucherNumber ,
					o.OrderName ,
					o.OrderNumber ,
					CASE WHEN o.Mode = 1 THEN ''Non-API''
							WHEN o.Mode = 2 THEN ''API''
							WHEN o.Mode = 3 THEN ''PaperVoucher''
							ELSE ''''
					END AS OrderMode ,
					IIF(v.BeneficiaryInfoId IS NULL, p.ProductName, REPLACE(p.ProductName, ''{FV}'', FORMAT(ISNULL(obi.FaceValueWithTax, 0) / 100.0,''0.##''))) ProductName,
					p.ProductCode,
					cq.ProjectName ,
					obi.ClientOrderNumber ,
					v.ActivatedOn ActiveDate,
					v.ShortUrl ShortUrl,
					CASE WHEN v.DistributionEmailStatus = 1 THEN ''Initialized''
                            WHEN v.DistributionEmailStatus = 2 THEN ''Sending''
                            WHEN v.DistributionEmailStatus = 3 THEN ''SentSuccess''
							WHEN v.DistributionEmailStatus = 4 THEN ''SentFailed''
                            WHEN v.DistributionEmailStatus = 5 THEN ''ToBeResent''
							WHEN v.DistributionEmailStatus = 6 THEN ''Trashed''
                            ELSE '''' 
					END AS DistributionEmailStatus,
					CASE WHEN v.DistributionSLMSStatus = 1 THEN ''Initialized''
                            WHEN v.DistributionSLMSStatus = 2 THEN ''Sending''
                            WHEN v.DistributionSLMSStatus = 3 THEN ''SentSuccess''
							WHEN v.DistributionSLMSStatus = 4 THEN ''SentFailed''
                            WHEN v.DistributionSLMSStatus = 5 THEN ''ToBeResent''
							WHEN v.DistributionSLMSStatus = 6 THEN ''Trashed''
                            ELSE '''' 
					END AS DistributionSLMSStatus,
					c.Name ClientName,
					(select DisplayName from Dictionary where Id = cq.BusinessTypeId)BusinessType,
					IIF(o.IsDirectDelivery=1,''Direct'',''InDirect'') Delivery
			FROM    Voucher v WITH(NOLOCK)
					INNER JOIN OrderBeneficiaryInfo obi WITH (NOLOCK) ON v.BeneficiaryInfoId = obi.Id
					INNER JOIN OrderLine ol WITH (NOLOCK) ON obi.OrderLineId = ol.Id
					INNER JOIN [Order] o WITH (NOLOCK) ON ol.OrderId = o.Id
					INNER JOIN Product p WITH (NOLOCK) ON v.ProductId = p.Id
					INNER JOIN ClientQuotation cq WITH (NOLOCK) ON o.ClientQuotationId = cq.Id
					INNER JOIN Client c WITH (NOLOCK) ON cq.ClientId = c.Id
			WHERE 1 = 1'

			if @VoucherNumber is not null
				set @SQLText = @SQLText + ' and v.VoucherNumber = '''+ @VoucherNumber + ''''
            
			if @ClientOrderNo is not null
				set @SQLText = @SQLText + ' and obi.ClientOrderNumber = ''' + @ClientOrderNo + ''''

			if @Email is not null
				set @SQLText = @SQLText + ' and obi.Email = ''' + @Email + ''''

			if @Mobile is not null
				set @SQLText = @SQLText + ' and obi.Mobile = ''' + @Mobile +  ''''

			if @ShortUrl is not null
				set @SQLText = @SQLText + ' and v.ShortUrl = ''' + @ShortUrl +  ''''

			if @GUID is not null
				set @SQLText = @SQLText + ' and v.[GUID] = ''' + @GUID +  ''''

			if @ActiveDate is not null
				set @SQLText = @SQLText + ' and v.ActivatedOn >=''' + CONVERT(varchar(20),@ActiveDate,112) +  '''and v.ActivatedOn <''' + CONVERT(varchar(20),DATEADD(DAY,1,@ActiveDate),112) + ''''

			if @VoucherStatus is not null
				set @SQLText = @SQLText + ' and v.[Status] = ' + CONVERT(varchar(10),@VoucherStatus)

			set    @SQLText = @SQLText +  ' ORDER BY obi.Id DESC OFFSET '
						
			set @SQLText = @SQLText + cast(@PageIndex as varchar(20)) + '*' +  cast(@PageSize as varchar(20)) +  ' ROWS'  
			set @SQLText = @SQLText + ' FETCH NEXT ' + cast(@PageSize as varchar(20)) + ' ROWS ONLY' 
		    
			exec (@SQLText)
		END
    END
