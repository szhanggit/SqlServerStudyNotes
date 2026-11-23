
CREATE FUNCTION [dbo].[F_GetFNEVWithholdDiscount](
@FinanceFormulaType	TINYINT,		-- 1=Prepaid, 2=Postpaid, 3=Cost
@FaceValue			NUMERIC(15,4),	-- In cent
@SoldPrice			NUMERIC(15,4),	-- In dollar (@SoldPrice - @FaceValue * 1.000000 / 100)
@TranType			SMALLINT,
@ProductType		TINYINT,		-- 1=Product-Based, 2=Value-Based
@TranAmount			NUMERIC(15,4),
@PreTranType		INT,
@InitBalance		INT,			-- Adora.Account.BalanceInitialized
@LEInitBalance		INT				-- The current BalanceAvailable when just enter into L&E.
,@Instance			varchar(20)     = NULL)
RETURNS NUMERIC(20,6)
AS
BEGIN
	DECLARE @ret as NUMERIC(20,6)
	DECLARE @tax DECIMAL(10,5) = 1;
	 IF @Instance IS NOT NULL AND @Instance = 'TW'
	 BEGIN
		 SET @tax = 1.05;
	 END
	SELECT @ret = 0

	IF(@FinanceFormulaType = 1) -- Prepaid
	BEGIN
		IF(@ProductType = 1) -- Product-Based
		BEGIN
			-- Finance Expire for Reverse Redemption or Reverse Pre-Authorization Complete
			IF(@TranType = 116 AND (@PreTranType = 201 OR @PreTranType = 203))
				SET @ret = (@SoldPrice - @FaceValue * 1.000000 / 100) * @TranAmount;
			
			-- Reverse Finance Expire for Redemption or Pre-Authorization Complete
			ELSE IF(@TranType = 117 AND (@PreTranType = 101 OR @PreTranType = 103))
				SET @ret = (@SoldPrice - @FaceValue * 1.000000 / 100) * @TranAmount * -1;
			
			-- Reverse Finance Expire for Trash Money
			ELSE IF(@TranType = 117 AND (@PreTranType = 404))
				--SET @ret = (@SoldPrice - @FaceValue * 1.000000 / 100) * @LEInitBalance * 1.000000 - (@SoldPrice - @FaceValue * 1.000000 / 100) * @InitBalance * 1.000000;
				SET @ret = (@LEInitBalance - @TranAmount) * (@SoldPrice - @FaceValue * 1.000000 / 100);
		END
		ELSE IF (@ProductType = 2) -- Postpaid
		BEGIN
			-- Finance Expire for Reverse Redemption or Reverse Pre-Authorization Complete
			IF(@TranType = 116 AND (@PreTranType = 201 OR @PreTranType = 203)) 
				SET @ret = (@SoldPrice - @FaceValue * 1.000000 / 100) * @TranAmount / @FaceValue * 1.000000 / @tax;
			
			-- Reverse Finance Expire for Redemption or Pre-Authorization Complete
			ELSE IF(@TranType = 117 AND (@PreTranType = 101 OR @PreTranType = 103)) 
				SET @ret = (@SoldPrice - @FaceValue * 1.000000 / 100) * @TranAmount / @FaceValue * 1.000000 / @tax * -1;
			
			-- Reverse Finance Expire for Trash Money
			ELSE IF(@TranType = 117 AND (@PreTranType = 404))
				--SET @ret = (@FaceValue * 1.000000 / 100 - @SoldPrice) * @InitBalance / @FaceValue / 1.05 - (@FaceValue * 1.000000 / 100 - @SoldPrice) * @LEInitBalance / @FaceValue / 1.05;
				SET @ret = (@LEInitBalance - @TranAmount) * 1.000000 / @InitBalance * (@SoldPrice - @FaceValue * 1.000000 / 100);
		END
	END

	RETURN ISNULL(@ret,0)
END
