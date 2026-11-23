
CREATE PROCEDURE spGetFinanceReportFeeByClient
    @ClientIds VARCHAR(1000) = NULL ,
    @FromTime DATETIME = NULL ,
    @ToTime DATETIME = NULL
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        DECLARE @TabClientId TABLE ( Value INT );
        DECLARE @XML XML;
        IF @ClientIds IS NOT NULL
            BEGIN 
                SET @XML = CAST(( '<i>' + REPLACE(@ClientIds, ',', '</i><i>')
                                  + '</i>' ) AS XML);
                INSERT  INTO @TabClientId
                        SELECT  t.i.value('.', 'INT')
                        FROM    @XML.nodes('i') AS t ( i );
                WITH    Trans
                          AS ( SELECT   t.Id ,
                                        t.TranType ,
                                        c.Value AS ClientId
                               FROM     [dbo].[Transaction] AS t WITH ( NOLOCK )
                                        INNER JOIN [dbo].[Order] AS o WITH ( NOLOCK ) ON t.[OrderId] = o.[Id]
                                        INNER JOIN [dbo].[ClientQuotation] AS cq
                                        WITH ( NOLOCK ) ON o.[ClientQuotationId] = cq.[Id]
                                        INNER JOIN @TabClientId AS c ON cq.ClientId = c.Value
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
                    SELECT  t.ClientId AS Id ,
                            d.Name AS ServiceFeeName ,
                            t.TranType ,
                            SUM(tf.TranFee) AS TranFee
                    FROM    Trans AS t
                            INNER JOIN dbo.TransactionFee AS tf WITH ( NOLOCK ) ON tf.TransactionId = t.Id
                            INNER JOIN dbo.ServiceFee AS sf WITH ( NOLOCK ) ON sf.Id = tf.ServiceFeeId
                            INNER JOIN dbo.Dictionary AS d WITH ( NOLOCK ) ON d.Id = sf.ServiceFeeNameId
                    GROUP BY t.ClientId ,
                            d.Name ,
                            t.TranType;
            END;
        ELSE
            BEGIN
                WITH    Trans
                          AS ( SELECT   t.Id ,
                                        t.TranType ,
                                        cq.ClientId
                               FROM     [dbo].[Transaction] AS t WITH ( NOLOCK )
                                        INNER JOIN [dbo].[Order] AS o WITH ( NOLOCK ) ON t.[OrderId] = o.[Id]
                                        INNER JOIN [dbo].[ClientQuotation] AS cq
                                        WITH ( NOLOCK ) ON o.[ClientQuotationId] = cq.[Id]
                               WHERE    t.[ResponseCode] = '0000'
                                        AND ( t.[TranLocalDateTime] <= @ToTime
                                              OR @ToTime IS NULL
                                            )
                                        AND ( t.[TranLocalDateTime] >= @FromTime
                                              OR @FromTime IS NULL
                                            )
                             )
                    SELECT  t.ClientId AS Id ,
                            d.Name AS ServiceFeeName ,
                            t.TranType ,
                            SUM(tf.TranFee) AS TranFee
                    FROM    Trans AS t
                            INNER JOIN dbo.TransactionFee AS tf WITH ( NOLOCK ) ON tf.TransactionId = t.Id
                            INNER JOIN dbo.ServiceFee AS sf WITH ( NOLOCK ) ON sf.Id = tf.ServiceFeeId
                            INNER JOIN dbo.Dictionary AS d WITH ( NOLOCK ) ON d.Id = sf.ServiceFeeNameId
                    GROUP BY t.ClientId ,
                            d.Name ,
                            t.TranType;
            END;
       
	
    END;
