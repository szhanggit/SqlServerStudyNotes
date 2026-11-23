
CREATE FUNCTION [dbo].[F_GetFNEVWithholdAmount](
@FinanceFormulaType	TINYINT,		-- 1=Prepaid, 2=Postpaid, 3=Cost
@FaceValue			NUMERIC(15,4),	-- In cent
@TranType			SMALLINT,
@ProductType		TINYINT,		-- 1=Product-Based, 2=Value-Based
@TranAmount			numeric(15,4),
@PreTranType		INT,
@InitBalance		INT,			-- Adora.Account.BalanceInitialized
@LEInitBalance		INT				-- The current BalanceAvailable when just enter into L&E.
,@Instance			varchar(20)     = NULL)
RETURNS NUMERIC(20,6)
AS
BEGIN
	DECLARE @ret AS NUMERIC(20,6);
	SELECT @ret = 0;
	DECLARE @tax DECIMAL(10,5) = 1;
	 IF @Instance IS NOT NULL AND @Instance = 'TW'
	 BEGIN
		 SET @tax = 1.05;
	 END
	IF(@FinanceFormulaType = 1) -- Prepaid
	BEGIN
		IF(@ProductType = 1) -- Product-Based
		BEGIN
			-- Finance Expire for Reverse Redemption or Reverse Pre-Authorization Complete
			IF(@TranType = 116 AND (@PreTranType = 201 OR @PreTranType = 203))
				SET @ret = @FaceValue * @TranAmount * 1.000000 / 100;
			
			-- Reverse Finance Expire for Redemption or Pre-Authorization Complete
			ELSE IF(@TranType = 117 AND (@PreTranType = 101 OR @PreTranType = 103))
				SET @ret = @FaceValue * @TranAmount * -1.000000 / 100;
			
			-- Reverse Finance Expire for Trash Money
			ELSE IF(@TranType = 117 AND (@PreTranType = 404))
				--SET @ret = @FaceValue * @LEInitBalance * 1.000000 / 100 - @FaceValue * @InitBalance * 1.000000 / 100;
				SET @ret = (@LEInitBalance - @TranAmount) * @FaceValue * 1.000000 / 100;
		END
		ELSE IF (@ProductType = 2) -- Value-Based
		BEGIN
			-- Finance Expire for Reverse Redemption or Reverse Pre-Authorization Complete
			IF(@TranType = 116 AND (@PreTranType = 201 OR @PreTranType = 203))
				SET @ret = @TranAmount * 1.000000 / 100 / @tax;
			
			-- Reverse Finance Expire for Redemption or Pre-Authorization Complete
			ELSE IF(@TranType = 117 AND (@PreTranType = 101 OR @PreTranType = 103))
				SET @ret = @TranAmount * -1.000000 / 100 / @tax;
			
			-- Reverse Finance Expire for Trash Money
			ELSE IF(@TranType = 117 AND (@PreTranType = 404))
				--SET @ret = @LEInitBalance * 1.000000 / 100 / 1.05 - @InitBalance * 1.000000 / 100 / 1.05;
				SET @ret = (@LEInitBalance - @TranAmount) * 1.000000 / @InitBalance * @FaceValue / 100;
		END
	END

	RETURN ISNULL(@ret,0)
END
