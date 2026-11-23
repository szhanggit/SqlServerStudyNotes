CREATE PROCEDURE [dbo].[spClearingStatisticInfo_katie] @ClearingId BIGINT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ChangeInvoicePrepaidAmount INT;
    DECLARE @ChangeInvoicePostpaidAmount INT;
    DECLARE @ChangeInvoiceCount INT

    SELECT  @ChangeInvoicePrepaidAmount = SUM(IIF(p.IsPrepaid = 1, IIF(a.ValueType = 1, ISNULL(p.FaceValue, 0), ISNULL(d.TranAmount, 0)), 0)),
            @ChangeInvoicePostpaidAmount = SUM(IIF(p.IsPrepaid = 0, IIF(a.ValueType = 1, ISNULL(p.FaceValue, 0), ISNULL(d.TranAmount, 0)), 0)),
            @ChangeInvoiceCount = COUNT(*)
    FROM    dbo.MultiAccountsTransaction mt WITH(NOLOCK)
            JOIN dbo.MultiAccountsTransactionDetail d WITH(NOLOCK) ON d.MultiAccountsTransactionId = mt.Id AND mt.TranType = 902
            JOIN dbo.Program pg WITH(NOLOCK) ON mt.ProgramCode = pg.IdentityCode
            JOIN dbo.Account a WITH(NOLOCK) ON a.AccountNumber = d.AccountNumber
                                            AND a.ProgramId = pg.Id
                                            AND a.ConsumeShopCode = mt.ShopCode
			JOIN dbo.Product AS p WITH(NOLOCK) ON p.Id = a.ProductId
            JOIN dbo.Clearing c WITH(NOLOCK) ON mt.MerchantCode = c.MerchantCode
                                            AND mt.ShopCode = c.ShopCode
                                            AND mt.TerminalCode = c.TerminalCode
                                            AND mt.ProgramCode = c.ProgramCode
                                            AND mt.BusinessDay = c.BusinessDay
                                            AND (mt.ShiftCode = c.ShiftCode OR c.ClearingType = 2)
			WHERE c.Id = @ClearingId AND mt.ResponseCode = '0000'
    IF @ChangeInvoiceCount < ( SELECT COUNT(*)
									FROM dbo.MultiAccountsTransaction mt WITH(NOLOCK)
									JOIN dbo.MultiAccountsTransactionDetail d WITH(NOLOCK) ON d.MultiAccountsTransactionId = mt.Id AND mt.TranType = 902
									JOIN dbo.Clearing c WITH(NOLOCK) ON mt.MerchantCode = c.MerchantCode
																	AND mt.ShopCode = c.ShopCode
																	AND mt.TerminalCode = c.TerminalCode
																	AND mt.ProgramCode = c.ProgramCode
																	AND mt.BusinessDay = c.BusinessDay
																	AND (mt.ShiftCode = c.ShiftCode OR c.ClearingType = 2)
									WHERE c.Id = @ClearingId AND mt.ResponseCode = '0000'
                                )
    BEGIN 
        SELECT  @ChangeInvoicePrepaidAmount = SUM(IIF(p.IsPrepaid = 1, IIF(a.ValueType = 1, ISNULL(p.FaceValue, 0), ISNULL(d.TranAmount, 0)), 0)),
                @ChangeInvoicePostpaidAmount = SUM(IIF(p.IsPrepaid = 0, IIF(a.ValueType = 1, ISNULL(p.FaceValue, 0), ISNULL(d.TranAmount, 0)), 0))
        FROM    dbo.MultiAccountsTransaction mt WITH(NOLOCK)
                JOIN dbo.MultiAccountsTransactionDetail d WITH(NOLOCK) ON d.MultiAccountsTransactionId = mt.Id AND mt.TranType = 902
                JOIN dbo.Program pg WITH(NOLOCK) ON mt.ProgramCode = pg.IdentityCode
                JOIN dbo.AccountHistory a WITH(NOLOCK) ON a.AccountNumber = d.AccountNumber
                                                        AND a.ProgramId = pg.Id
                                                        AND a.ConsumeShopCode = mt.ShopCode
				JOIN dbo.Product AS p WITH(NOLOCK) ON p.Id = a.ProductId
                JOIN dbo.Clearing c WITH(NOLOCK) ON mt.MerchantCode = c.MerchantCode
                                                AND mt.ShopCode = c.ShopCode
                                                AND mt.TerminalCode = c.TerminalCode
												AND mt.ProgramCode = c.ProgramCode
                                                AND mt.BusinessDay = c.BusinessDay
												AND (mt.ShiftCode = c.ShiftCode OR c.ClearingType = 2)
				WHERE c.Id = @ClearingId AND mt.ResponseCode = '0000'
    END

	SET @ChangeInvoicePrepaidAmount = ISNULL(@ChangeInvoicePrepaidAmount, 0);
	SET @ChangeInvoicePostpaidAmount = ISNULL(@ChangeInvoicePostpaidAmount, 0);
	--Sale为卖出的 Refund为退款的 两者相减为Total 即总营业额
	SELECT  (SUM(IIF(p1.Id IS NOT NULL AND (mt.TranType = 101 OR mt.TranType = 103), IIF(a.ValueType = 1, ISNULL(p1.FaceValue, 0), ISNULL(detail.TranAmount, 0)), 0)) + @ChangeInvoicePrepaidAmount ) AS PrepaidSalesAmount,
			(SUM(IIF(p1.Id IS NOT NULL AND (mt.TranType = 201 OR mt.TranType = 203), IIF(a.ValueType = 1, ISNULL(p1.FaceValue, 0), ISNULL(detail.TranAmount, 0)), 0)) + @ChangeInvoicePrepaidAmount )  AS PrepaidRefundedAmount,

			(SUM(IIF(p2.Id IS NOT NULL AND (mt.TranType = 101 OR mt.TranType = 103), IIF(a.ValueType = 1, ISNULL(p2.FaceValue, 0), ISNULL(detail.TranAmount, 0)), 0)) + @ChangeInvoicePostpaidAmount ) AS PostpaidSalesAmount,
			(SUM(IIF(p2.Id IS NOT NULL AND (mt.TranType = 201 OR mt.TranType = 203), IIF(a.ValueType = 1, ISNULL(p2.FaceValue, 0), ISNULL(detail.TranAmount, 0)), 0)) + @ChangeInvoicePostpaidAmount )  AS PostpaidRefundedAmount
	FROM    dbo.Clearing c WITH(NOLOCK)
			LEFT JOIN dbo.ClearingDetail cd WITH(NOLOCK) ON cd.ClearingId = c.Id
			LEFT JOIN dbo.Account a WITH(NOLOCK) ON a.AccountNumber = cd.AccountNumber
			LEFT JOIN dbo.Product p1 WITH(NOLOCK) ON p1.Id = a.ProductId AND p1.IsPrepaid = 1
			LEFT JOIN dbo.Product p2 WITH(NOLOCK) ON p2.Id = a.ProductId AND p2.IsPrepaid = 0
			LEFT JOIN dbo.MultiAccountsTransaction AS mt WITH(NOLOCK) ON mt.ProgramCode = c.ProgramCode
															AND c.MerchantCode = mt.MerchantCode
															AND c.ShopCode = mt.ShopCode
															AND c.TerminalCode = mt.TerminalCode
															AND cd.TerminalSSN = mt.TerminalSSN
			LEFT JOIN dbo.MultiAccountsTransactionDetail detail WITH(NOLOCK) ON detail.MultiAccountsTransactionId = mt.Id AND detail.AccountNumber = a.AccountNumber
	WHERE c.Id = @ClearingId
END
