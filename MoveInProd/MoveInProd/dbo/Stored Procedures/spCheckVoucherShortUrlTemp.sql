CREATE PROCEDURE [dbo].[spCheckVoucherShortUrlTemp]
    @SessionId VARCHAR(50) ,
    @ShortUrlAuthCodeGenerationWay TINYINT ,
    @ReturnCode VARCHAR(20) OUTPUT
AS
    BEGIN
        IF ( EXISTS ( SELECT    1
                      FROM      VoucherShortUrlTemp t1
                                JOIN VoucherShortUrlTemp t2 ON t1.VoucherAlias = t2.VoucherAlias
                      WHERE     t1.SessionId = @SessionId
                      GROUP BY  t1.VoucherAlias
                      HAVING    COUNT(1) > 1 ) )
            BEGIN
                SELECT  t.Id
                FROM    [VoucherShortUrlTemp] t
                        JOIN ( SELECT   t1.VoucherAlias
                               FROM     VoucherShortUrlTemp t1
                                        JOIN VoucherShortUrlTemp t2 ON t1.VoucherAlias = t2.VoucherAlias
                               WHERE    t1.SessionId = @SessionId
                               GROUP BY t1.VoucherAlias
                               HAVING   COUNT(t1.VoucherAlias) > 1
                             ) t3 ON t.VoucherAlias = t3.VoucherAlias
                WHERE   t.SessionId = @SessionId

                DELETE  t
                FROM    [VoucherShortUrlTemp] t
                        JOIN ( SELECT   t1.VoucherAlias
                               FROM     VoucherShortUrlTemp t1
                                        JOIN VoucherShortUrlTemp t2 ON t1.VoucherAlias = t2.VoucherAlias
                               WHERE    t1.SessionId = @SessionId
                               GROUP BY t1.VoucherAlias
                               HAVING   COUNT(t1.VoucherAlias) > 1
                             ) t3 ON t.VoucherAlias = t3.VoucherAlias
                WHERE   t.SessionId = @SessionId  
		 	
                SET @ReturnCode = '1'
                RETURN;
            END

        IF ( EXISTS ( SELECT    1
                      FROM      VoucherShortUrl vs
                                JOIN VoucherShortUrlTemp vst ON vs.VoucherAlias = vst.VoucherAlias
                      WHERE     vst.SessionId = @SessionId ) )
            BEGIN
                SELECT  vst.Id
                FROM    VoucherShortUrl vs
                        JOIN VoucherShortUrlTemp vst ON vs.VoucherAlias = vst.VoucherAlias
                WHERE   vst.SessionId = @SessionId

                DELETE  vst
                FROM    VoucherShortUrl vs
                        JOIN VoucherShortUrlTemp vst ON vs.VoucherAlias = vst.VoucherAlias
                WHERE   vst.SessionId = @SessionId

                SET @ReturnCode = '2'
                RETURN;
            END

        BEGIN TRY	
            BEGIN TRANSACTION
            IF ( @ShortUrlAuthCodeGenerationWay = 1 )
                BEGIN 
                    INSERT  INTO VoucherShortUrl
                            ( Id ,
                              VoucherAlias ,
                              AuthCode
                            )
                            SELECT  vsu.Id ,
                                    vsu.VoucherAlias ,
                                    RIGHT(v.VoucherNumber, 4) AS AuthCode
                            FROM    VoucherShortUrlTemp AS vsu WITH ( NOLOCK )
                                    INNER JOIN dbo.Voucher AS v WITH ( NOLOCK ) ON vsu.Id = v.Id
                            WHERE   SessionId = @SessionId
                END
            ELSE
                BEGIN
                    INSERT  INTO VoucherShortUrl
                            ( Id ,
                              VoucherAlias ,
                              AuthCode
                            )
                            SELECT  Id ,
                                    VoucherAlias ,
                                    AuthCode
                            FROM    VoucherShortUrlTemp
                            WHERE   SessionId = @SessionId
                END
			
            DELETE  VoucherShortUrlTemp
            WHERE   SessionId = @SessionId

            SET @ReturnCode = '0'
            COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH
            SET @ReturnCode = '3'
            ROLLBACK TRANSACTION;
        END CATCH		

    END


