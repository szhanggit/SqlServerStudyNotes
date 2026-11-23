
CREATE PROCEDURE spInsertCampaignVoucherTrustAccount
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @currentDate datetime = getdate();
    DECLARE @maxDate DATE = DATEFROMPARTS(2999, 12, 31);
    DECLARE @rowCount int = 3000;
    WHILE (@rowCount = 3000)
    BEGIN
        INSERT dbo.VoucherTrustAccount
            (
            Id,
            TrustAccountId,
            TrustAmountOption,
            TrustAccountBatchNo,
            Amount,
            ExpiryPolicyId,
            ExpiryDate
            )
        Select top 3000
            v.Id,
            ot.TrustAccountId, -- TrustAccountId - int
            ot.TrustAccountOption, -- TrustAmountOption - int
            ot.TrustAccountBatchNo, -- TrustAccountBatchNo - nvarchar(200)
            ot.Amount, -- Amount - numeric(20, 6)
            ot.ExpiryPolicyId, -- ExpiryPolicyId - int
            IIF(ot.ExpiryPolicyId = 2, 
				DATEADD(SECOND,-1,DATEADD(DAY,1,CONVERT(DATETIME,CONVERT(DATE,v.ExpiryDate)))), 
				IIF(ot.ValidTo > @maxDate, DATEADD(SECOND,-1,DATEADD(DAY,1,CONVERT(DATETIME,CONVERT(DATE,DATEADD(YEAR, 1, pcv.CreatedOn))))), ot.ValidTo)
				)
        from PreIssuedCampaignVoucher pcv with(nolock)
            join Voucher v with(nolock) on v.Id = pcv.VoucherId
            join OrderBeneficiaryInfo obi with(nolock) on obi.Id = v.BeneficiaryInfoId
            join OrderLineTrustAccount ot with(nolock) on ot.OrderLineId = obi.OrderLineId
            left join VoucherTrustAccount vta with(nolock) on vta.Id = v.Id
        where pcv.ProcessStatus = 0
            and vta.Id is null
            and ot.ValidFrom < @currentDate AND ot.ValidTo > @currentDate
        order by pcv.CreatedOn
        SET @rowCount = @@ROWCOUNT;
    END
END
