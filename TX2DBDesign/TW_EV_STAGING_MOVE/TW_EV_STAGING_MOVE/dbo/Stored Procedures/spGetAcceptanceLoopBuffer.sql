
CREATE PROCEDURE [dbo].[spGetAcceptanceLoopBuffer]
	@RunId						varchar(100),
	@AcceptanceLoopUpdateGUID	varchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ProductId int
	Declare @ProgramCode varchar(50)
	DECLARE @AcceptanceLoopBuffer TABLE
	(
		AcceptanceLoopUpdateId varchar(50), 
		ProgramIdentityCode varchar(50), 
		ProductExternalId int, 
		[Status] int, 
		CreatedOn datetime
	)



		DECLARE C CURSOR FOR
		SELECT DISTINCT TX2ProductId FROM TXCAcceptanceLoopSync WHERE RunId = @RunId

		OPEN C;
		FETCH NEXT FROM C INTO @ProductId
	--------------------------------------------------
		WHILE @@FETCH_STATUS = 0
		BEGIN
			select @ProgramCode = pg.IdentityCode from Product p with(nolock)
			inner join Program pg with(nolock) on p.ProgramId = pg.Id
			where p.Id = @ProductId

			if @ProductId is not null
			begin
			      insert into @AcceptanceLoopBuffer(AcceptanceLoopUpdateId, ProgramIdentityCode, ProductExternalId, [Status], CreatedOn)
			      select @AcceptanceLoopUpdateGUID as AcceptanceLoopUpdateId, @ProgramCode as ProgramIdentityCode, @ProductId as ProductExternalId, 1 as [Status], getutcdate() as CreatedOn
			end
		
			FETCH NEXT FROM C INTO @ProductId
		END
	--------------------------------------------------
		CLOSE C
		DEALLOCATE C

	select * from @AcceptanceLoopBuffer
END
