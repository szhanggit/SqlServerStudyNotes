
CREATE PROCEDURE spGetFinanceReportFeeByBusinessModel
    @BusinessModelIds VARCHAR(200) = NULL ,
    @FromTime DATETIME = NULL ,
    @ToTime DATETIME = NULL ,
    @TestBusinessModelId INT
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        DECLARE @BusinessModelDisplayName TABLE ( Value INT );
        DECLARE @XML XML;
        IF @BusinessModelIds IS NOT NULL
            BEGIN 
                SET @XML = CAST(( '<i>' + REPLACE(@BusinessModelIds, ',',
                                                  '</i><i>') + '</i>' ) AS XML);
                INSERT  INTO @BusinessModelDisplayName
                        SELECT  t.i.value('.', 'INT')
                        FROM    @XML.nodes('i') AS t ( i );
            END;
        ELSE
            BEGIN
                INSERT  INTO @BusinessModelDisplayName
                        SELECT  DisplayNameId
                        FROM    dbo.BusinessModel;
            END;
        WITH    Trans
                  AS ( SELECT   t.Id ,
                                t.TranType ,
                                bmdn.Value AS BusinessModelDisplayNameId
                       FROM     [dbo].[Transaction] AS t WITH ( NOLOCK )
                                INNER JOIN [dbo].[ClientQuotationProduct] AS cqp
                                WITH ( NOLOCK ) ON t.[ClientQuotationProductId] = cqp.[Id]
                                INNER  JOIN [dbo].[ClientQuotation] AS cq WITH ( NOLOCK ) ON cqp.[ClientQuotationId] = cq.[Id]
                                INNER JOIN [dbo].[BusinessModel] AS b WITH ( NOLOCK ) ON cq.[BusinessModelId] = b.[Id]
                                INNER JOIN @BusinessModelDisplayName AS bmdn ON b.DisplayNameId = bmdn.Value
                       WHERE    t.[ResponseCode] = '0000'
                                AND ( t.[TranLocalDateTime] <= @ToTime
                                      OR @ToTime IS NULL
                                    )
                                AND ( t.[TranLocalDateTime] >= @FromTime
                                      OR @FromTime IS NULL
                                    )
                                AND cq.BusinessModelId <> @TestBusinessModelId
                     )
            SELECT  t.BusinessModelDisplayNameId AS Id ,
                    d.Name AS ServiceFeeName ,
                    t.TranType ,
                    SUM(tf.TranFee) AS TranFee
            FROM    Trans AS t
                    INNER JOIN dbo.TransactionFee AS tf WITH ( NOLOCK ) ON tf.TransactionId = t.Id
                    INNER JOIN dbo.ServiceFee AS sf WITH ( NOLOCK ) ON sf.Id = tf.ServiceFeeId
                    INNER JOIN dbo.Dictionary AS d WITH ( NOLOCK ) ON d.Id = sf.ServiceFeeNameId
            GROUP BY t.BusinessModelDisplayNameId ,
                    d.Name ,
                    t.TranType;

	
    END;
