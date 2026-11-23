
CREATE PROCEDURE dbo.spGetMoveTransNumForTheDay
@Id INT,
@DateNum INT,
@TransNumber INT OUTPUT
AS
    SET NOCOUNT ON
	SELECT @TransNumber = count(*) FROM [Transaction] WITH(NOLOCK) WHERE TranLocalDate = @DateNum AND ResponseCode != '0001'
	
	update AdoraMoveSyncCheckLog
	set MoveTranNum = @TransNumber
	where Id = @Id;
