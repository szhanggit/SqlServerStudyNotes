create procedure spGetInCacheVoucherMCDetailInfo
	@InputTable VoucherMSPropType READONLY
AS
BEGIN


IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = '#VoucherMCTemp')
BEGIN
	CREATE TABLE [dbo].[#VoucherMCTemp]
	(
		[Id] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
		[ProcessId] [int] NULL,
		[VoucherNumber] [varchar](50) NULL,
		[ProgramCode] [varchar](50) NULL,
		[OrderNumber] [varchar](50) NULL,
		[ComboType] [varchar](10) NULL,
		[MasterVoucherNumber] [varchar](50) NULL,
		[ChildVoucherNumber]  [varchar](50) NULL,
		[VoucherNumberGenerateWay] [int] NULL,
		[IsMasterProduct] [int] NULL,
		[BeneficiaryInfoId] [int] NULL,
		[IsFakeBeneficiaryInfoId] [int] NULL,
		PRIMARY KEY CLUSTERED ([Id] ASC),
	)
END

insert into #VoucherMCTemp (ProcessId, VoucherNumber, ProgramCode) select Id as ProcessId, VoucherNumber, ProgramCode from @InputTable;

	DECLARE @MasterVoucher varchar(50);
	DECLARE @ChildVoucher varchar(50);
	DECLARE @res varchar(10);
	DECLARE @ProgramCode varchar(50);
	DECLARE @VoucherNumber varchar(50);
	DECLARE @OrderNumber varchar(50);
    DECLARE @ProcessId int;
	DECLARE @VoucherNumberGenerateWay int;
	DECLARE @IsMasterProduct int;
	DECLARE @BeneficiaryInfoId int;
	DECLARE @IsFakeBeneficiaryInfoId int;
	DECLARE @BusinessCursor as CURSOR;
	SET @BusinessCursor = CURSOR FOR
	select ProcessId from #VoucherMCTemp with(nolock)

	OPEN @BusinessCursor;
	FETCH NEXT FROM @BusinessCursor INTO @ProcessId;
	WHILE @@FETCH_STATUS = 0
	BEGIN
	-------------

	select @VoucherNumber = VoucherNumber, @ProgramCode = ProgramCode, @ProgramCode = ProgramCode, @OrderNumber = OrderNumber from #VoucherMCTemp with(nolock) where ProcessId = @ProcessId;
	EXEC	[dbo].[spCheckInCacheVoucherMCProp]
			@Voucher = @VoucherNumber,
			@ProgramCode = @ProgramCode,
			@MasterVoucher = @MasterVoucher OUTPUT,
			@ChildVoucher = @ChildVoucher OUTPUT,
			@res = @res OUTPUT,
			@VoucherNumberGenerateWay = @VoucherNumberGenerateWay OUTPUT,
			@IsMasterProduct = @IsMasterProduct OUTPUT

	update #VoucherMCTemp
	set ComboType = @res, 
	MasterVoucherNumber = @MasterVoucher, 
	ChildVoucherNumber = @ChildVoucher, 
	VoucherNumberGenerateWay = @VoucherNumberGenerateWay,
	IsMasterProduct = @IsMasterProduct
	where ProcessId = @ProcessId;

	set @VoucherNumber = null;	
	set @ProgramCode = null;
	set @MasterVoucher = null;
	set @ChildVoucher = null;
	set @res = null;
	set @ProcessId = 0;
	set @VoucherNumberGenerateWay = 0;
	----------------
	FETCH NEXT FROM @BusinessCursor INTO @ProcessId;
	END	
	
	select * from #VoucherMCTemp with(nolock);

END