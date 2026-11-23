
CREATE FUNCTION [dbo].[F_GetNWRAmount]
    (
      @FinanceFormulaType TINYINT , --1 prepaid, 2 postpaid, 3 Cost
      @FaceValue INT , --cent
      @TranType SMALLINT ,--
      @TranAmount INT ,
      @ProductType TINYINT , -- 1--product based, 2--Value based
      @Cost NUMERIC(15, 4) ,
      @ContractAmount NUMERIC(15, 4),
	  @MGCType CHAR = 'G' --M:Master Voucher; G:General Vocher; C:Child Voucher
    ,@Instance			varchar(20)     = NULL
	)
RETURNS NUMERIC(20, 6)
AS
    BEGIN
--101	Redemption
--201	ReverseRedemption
--103	Pre-Auth Complete
--203	Reverse Pre-Auth Complete
--401	Issue
--501	Reverse Issue
--404	TrashMoney
--405   TrashNoMoney
        DECLARE @ret AS NUMERIC(20, 6)
		DECLARE @tax DECIMAL(10,5) = 1;
	 IF @Instance IS NOT NULL AND @Instance = 'TW'
	 BEGIN
	     SET @MGCType = 'G';
		 SET @tax = 1.05;
	 END
        SELECT  @ret = 0
        IF ( @FinanceFormulaType = 1
             OR @FinanceFormulaType = 2
           )
            BEGIN
                IF ( @ProductType = 1 )
                    BEGIN
                        IF ( @TranType = 101
                             OR @TranType = 103
                           )
                            SET @ret = (@FaceValue * 1.000000 / 100 - @Cost) * @TranAmount
                        IF ( @TranType = 201
                             OR @TranType = 203
                           )
                            SET @ret = (@Cost - @FaceValue * 1.000000 / 100) * @TranAmount
                    END
                ELSE
                    BEGIN
                        DECLARE @RebursementRate AS NUMERIC(15, 4)
                        SET @RebursementRate = NULL
			
                        IF ( @FinanceFormulaType = 1 )
                            SET @RebursementRate = @Cost
                        ELSE
                            IF ( @FinanceFormulaType = 2 )
                                SET @RebursementRate = @ContractAmount
			    
                        IF ( @TranType = 101  OR @TranType = 103)
                            SET @ret = @TranAmount * ( 100 - @RebursementRate )
                                * 1.000000 / 10000/@tax
                        IF ( @TranType = 201 OR @TranType = 203)
                            SET @ret = @TranAmount * ( @RebursementRate - 100 )
                                * 1.000000 / 10000/@tax
				
                    END
            END
		IF(@MGCType = 'M' AND (@TranType = 101 OR @TranType = 201 OR @TranType = 103 OR @TranType = 203))
			SET @ret = 0;
        IF(@MGCType = 'C' AND (@TranType = 401 OR @TranType = 501 OR @TranType = 404 OR @TranType = 405))
            SET @ret = 0;
        RETURN ISNULL(@ret,0)
    END
