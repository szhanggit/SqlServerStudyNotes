
CREATE FUNCTION [dbo].[F_GetIRVAmount]
    (
      @FinanceFormulaType TINYINT , --1 prepaid, 2 postpaid, 3 Cost
      @FaceValue INT , --cent
      @TranType SMALLINT ,--
      @TranAmount INT ,
      @ProductType TINYINT, -- 1--product based, 2--Value based
	  @MGCType CHAR = 'G' --M:Master Voucher; G:General Vocher; C:Child Voucher
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
        DECLARE @ret AS NUMERIC(20, 6)
		DECLARE @tax DECIMAL(10,5) = 1;
	 IF @Instance IS NOT NULL AND @Instance = 'TW'
	 BEGIN
	     SET @MGCType = 'G';
		 SET @tax = 1.05;
	 END
        SELECT  @ret = 0

        IF ( @FinanceFormulaType = 2 )
            BEGIN
                IF ( @ProductType = 1 )
                    BEGIN
                        IF ( @TranType = 101
                             OR @TranType = 103
                           )
                            SET @ret = @FaceValue * @TranAmount * 1.000000 / 100
                        IF ( @TranType = 201
                             OR @TranType = 203
                           )
                            SET @ret = @FaceValue * @TranAmount * -1.000000 / 100
                    END
                ELSE
                    BEGIN
                        IF ( @TranType = 101 OR @TranType = 103)
                            SET @ret = @TranAmount * 1.000000 / 100/@tax
                        IF ( @TranType = 201 OR @TranType = 203)
                            SET @ret = @TranAmount * -1.000000 / 100/@tax
                    END
            END
		IF(@MGCType = 'M' AND (@TranType = 101 OR @TranType = 201 OR @TranType = 103 OR @TranType = 203))
			SET @ret = 0;
        IF(@MGCType = 'C' AND (@TranType = 401 OR @TranType = 501 OR @TranType = 404 OR @TranType = 405))
            SET @ret = 0;
        RETURN ISNULL(@ret,0)
    END
