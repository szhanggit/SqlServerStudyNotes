create procedure spUpdateAccordingToVoucherMCDetailInfo
	@InputTable AdoraMSPropType READONLY
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

insert into #VoucherMCTemp (ProcessId, VoucherNumber, ProgramCode, 
ComboType, MasterVoucherNumber, ChildVoucherNumber, VoucherNumberGenerateWay,
IsMasterProduct, BeneficiaryInfoId, IsFakeBeneficiaryInfoId) select ProcessId, VoucherNumber, ProgramCode, 
ComboType, MasterVoucherNumber, ChildVoucherNumber, VoucherNumberGenerateWay,
IsMasterProduct, BeneficiaryInfoId, IsFakeBeneficiaryInfoId from @InputTable;

	
update ts
set ts.ComboType = vt.ComboType, 
ts.MasterVoucherNumber = vt.MasterVoucherNumber, 
ts.ChildVoucherNumber = vt.ChildVoucherNumber, 
ts.VoucherNumberGenerateWay = vt.VoucherNumberGenerateWay, 
ts.IsMasterProduct = vt.IsMasterProduct, 
ts.BeneficiaryInfoId = vt.BeneficiaryInfoId, 
ts.IsFakeBeneficiaryInfoId = vt.IsFakeBeneficiaryInfoId,
ts.ProcessStatus = 1,
ts.ProcessedDate = GetDate()
from TransactionBKForSupport ts with(nolock)
inner join #VoucherMCTemp vt with(nolock) on ts.Id = vt.ProcessId

END