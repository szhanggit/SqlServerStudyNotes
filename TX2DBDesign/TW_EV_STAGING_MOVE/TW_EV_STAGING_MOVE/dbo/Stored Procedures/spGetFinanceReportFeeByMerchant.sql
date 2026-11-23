
CREATE PROCEDURE spGetFinanceReportFeeByMerchant
    @MerchantIds VARCHAR(1000) = NULL ,
    @FromTime DATETIME = NULL ,
    @ToTime DATETIME = NULL
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        DECLARE @TabMerchantId TABLE ( Value INT );
        DECLARE @XML XML;
        IF @MerchantIds IS NOT NULL
            BEGIN 
                SET @XML = CAST(( '<i>' + REPLACE(@MerchantIds, ',', '</i><i>')
                                  + '</i>' ) AS XML);
                INSERT  INTO @TabMerchantId
                        SELECT  t.i.value('.', 'INT')
                        FROM    @XML.nodes('i') AS t ( i );
                WITH    Trans
                          AS ( SELECT   t.Id ,
                                        t.TranType ,
                                        m.Value AS MerchantId
                               FROM     [dbo].[Transaction] AS t WITH ( NOLOCK )
                                        INNER JOIN @TabMerchantId AS m ON t.MerchantId = m.Value
                                        INNER JOIN [dbo].[ClientQuotationProduct]
                                        AS cqp WITH ( NOLOCK ) ON t.[ClientQuotationProductId] = cqp.[Id]
                                        INNER  JOIN [dbo].[ClientQuotation] AS cq
                                        WITH ( NOLOCK ) ON cqp.[ClientQuotationId] = cq.[Id]
                                        INNER JOIN [dbo].[BusinessModel] AS b
                                        WITH ( NOLOCK ) ON cq.[BusinessModelId] = b.[Id]
                                        INNER JOIN dbo.Dictionary AS dic ON b.DisplayNameId = dic.Id
                               WHERE    t.[ResponseCode] = '0000'
                                        AND ( t.[TranLocalDateTime] <= @ToTime
                                              OR @ToTime IS NULL
                                            )
                                        AND ( t.[TranLocalDateTime] >= @FromTime
                                              OR @FromTime IS NULL
                                            )
                                        AND dic.DisplayName <> 'Test'
                             )
                    SELECT  t.MerchantId AS Id ,
                            d.Name AS ServiceFeeName ,
                            t.TranType ,
                            SUM(tf.TranFee) AS TranFee
                    FROM    Trans AS t
                            INNER JOIN dbo.TransactionFee AS tf WITH ( NOLOCK ) ON tf.TransactionId = t.Id
                            INNER JOIN dbo.ServiceFee AS sf WITH ( NOLOCK ) ON sf.Id = tf.ServiceFeeId
                            INNER JOIN dbo.Dictionary AS d WITH ( NOLOCK ) ON d.Id = sf.ServiceFeeNameId
                    GROUP BY t.MerchantId ,
                            d.Name ,
                            t.TranType;
            END;
        ELSE
            BEGIN
                WITH    Trans
                          AS ( SELECT   t.Id ,
                                        t.TranType ,
                                        t.MerchantId AS MerchantId
                               FROM     [dbo].[Transaction] AS t WITH ( NOLOCK )
                               WHERE    t.[ResponseCode] = '0000'
                                        AND ( t.[TranLocalDateTime] <= @ToTime
                                              OR @ToTime IS NULL
                                            )
                                        AND ( t.[TranLocalDateTime] >= @FromTime
                                              OR @FromTime IS NULL
                                            )
                             )
                    SELECT  t.MerchantId AS Id ,
                            d.Name AS ServiceFeeName ,
                            t.TranType ,
                            SUM(tf.TranFee) AS TranFee
                    FROM    Trans AS t
                            INNER JOIN dbo.TransactionFee AS tf WITH ( NOLOCK ) ON tf.TransactionId = t.Id
                            INNER JOIN dbo.ServiceFee AS sf WITH ( NOLOCK ) ON sf.Id = tf.ServiceFeeId
                            INNER JOIN dbo.Dictionary AS d WITH ( NOLOCK ) ON d.Id = sf.ServiceFeeNameId
                    GROUP BY t.MerchantId ,
                            d.Name ,
                            t.TranType;
            END;
       
	
    END;
