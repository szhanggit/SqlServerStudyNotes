CREATE FUNCTION [dbo].[F_GetBillAmount]
(@FinanceFormulaType TINYINT, --1 prepaid, 2 postpaid,3 Cost
 @QuotationAmount    NUMERIC(15, 4), 
 @FaceValue          INT, --cent
 @TranAmount         INT, --cent
 @ProductType        TINYINT, -- 1--product based, 2--Value based
 @TranType           SMALLINT       = 0, -- 0--make no sense
 @MGCType            CHAR           = 'G' --M:Master Voucher; G:General Vocher; C:Child Voucher
,@Instance			varchar(20)     = NULL
)
RETURNS NUMERIC(20, 6)
AS
     BEGIN
         --101	Redeem
         --201	Reverse Redeem
         --103	Pre-Auth Complete
         --203	Reverse Pre-Auth Complete
         --401	Issue
         --501	Reverse Issue
         --404	Trash
         --405   TrashNoMoney
		 DECLARE @tax DECIMAL(10,5) = 1;
	 IF @Instance IS NOT NULL AND @Instance = 'TW'
	 BEGIN
	     SET @MGCType = 'G';
		 SET @tax = 1.05;
	 END

         DECLARE @ret AS NUMERIC(20, 6);
         SELECT @ret = 0;
         IF(@ProductType = 1) --product based
             BEGIN
                 IF(@FinanceFormulaType = 1
                    OR @FinanceFormulaType = 2)
                     BEGIN
                         SET @ret = @QuotationAmount * @TranAmount;
                 END;
         END;
             ELSE
             BEGIN  --value based
                 IF(@FinanceFormulaType = 1)
                     SET @ret = @FaceValue * @QuotationAmount * 1.000000 / 10000;
                     ELSE
                     IF(@FinanceFormulaType = 2)
                         SET @ret = @TranAmount * @QuotationAmount * 1.000000 / 10000 / @tax;
         END;
         IF(@MGCType = 'M' AND (@TranType = 101 OR @TranType = 201 OR @TranType = 103 OR @TranType = 203))
			SET @ret = 0;
         IF(@MGCType = 'C' AND (@TranType = 401 OR @TranType = 501 OR @TranType = 404 OR @TranType = 405))
            SET @ret = 0;
         RETURN ISNULL(@ret, 0);
     END;
