
CREATE PROCEDURE [dbo].[spGetAcceptanceLoopShopBuffer]
	@RunId						varchar(100),
	@AcceptanceLoopUpdateGUID	varchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ProductId int
	DECLARE @ShopId int
	Declare @ProgramCode varchar(50)
	DECLARE @AcceptanceLoopShopBuffer TABLE
	(
		AcceptanceLoopUpdateId varchar(50), 
		ProgramIdentityCode varchar(50), 
		ProductExternalId int, 
		ShopExternalId int, 
		CreatedOn datetime
	)



	DECLARE C CURSOR FOR
	SELECT DISTINCT TX2ProductId FROM TXCAcceptanceLoopSync WHERE RunId = @RunId

	OPEN C;
	FETCH NEXT FROM C INTO @ProductId
	--------------------------------------------------
	WHILE @@FETCH_STATUS = 0
	BEGIN

		DECLARE inner_cursor CURSOR FOR
		SELECT DISTINCT TX2ShopId FROM TXCAcceptanceLoopSync WHERE RunId = @RunId AND TX2ProductId = @ProductId

		select @ProgramCode = pg.IdentityCode from Product p with(nolock)
		inner join Program pg with(nolock) on p.ProgramId = pg.Id
		where p.Id = @ProductId



		OPEN inner_cursor;
		FETCH NEXT FROM inner_cursor INTO @ShopId
		----------------------------------------------------
		WHILE @@FETCH_STATUS = 0
		BEGIN
			if @ProductId is not null AND @ShopId is not null
			begin
				insert into @AcceptanceLoopShopBuffer(AcceptanceLoopUpdateId, ProgramIdentityCode, ProductExternalId, ShopExternalId, CreatedOn)
				select @AcceptanceLoopUpdateGUID as AcceptanceLoopUpdateId, @ProgramCode as ProgramIdentityCode, @ProductId as ProductExternalId, @ShopId as ShopExternalId, getutcdate() as CreatedOn
			end
			
			FETCH NEXT FROM inner_cursor INTO @ShopId
		END
		----------------------------------------------------
		CLOSE inner_cursor
		DEALLOCATE inner_cursor

		
		FETCH NEXT FROM C INTO @ProductId
	END
	--------------------------------------------------
	CLOSE C
	DEALLOCATE C



	select * from @AcceptanceLoopShopBuffer

END
