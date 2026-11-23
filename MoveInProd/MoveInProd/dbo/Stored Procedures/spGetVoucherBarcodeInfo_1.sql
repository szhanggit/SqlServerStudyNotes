

CREATE PROCEDURE [dbo].[spGetVoucherBarcodeInfo]
    @VoucherId INT
AS
    BEGIN
        SET NOCOUNT ON;
		
		--00002	FamilyMart
		--00003	7-ELEVEN
		--00014	StarBucks
		--00016	SoftWorld
		--IQiYi	FamilyMartBardCodeOne 的IdentityCode UAT和生产不一样

		declare @true bit = 1;
		declare @false bit = 0;

        SELECT  v.Id AS Id ,
                v.VoucherNumber AS VoucherNo ,
                v.GUID AS VoucherGuid ,
                pg.IdentityCode AS ProgramCode ,
				case when pg.Name = 'FamilyMart' then ISNULL(fm.Barcode1,'')
					 when pg.Name = '7-ELEVEN' then ISNULL(seb.Barcode1,'')
					 when pg.Name = 'StarBucks' then sbk.[QRCode]
					 when pg.Name = 'SoftWorld' then ISNULL(sw.Barcode1,'')
					 when pg.Name = 'iQIYI' then ISNULL(iqy.ActivationCode,'')
					 when pg.Name = 'FamilyMartBardCodeOne' then ISNULL(fmc1.Bardcode1,'')
					 else '' end AS Barcode1 ,
                case when pg.Name = 'FamilyMart' then ISNULL(fm.Barcode2,'')
					 when pg.Name = '7-ELEVEN' then ISNULL(seb.Barcode2,'')
					 when pg.Name = 'StarBucks' then ''
					 when pg.Name = 'SoftWorld' then ISNULL(sw.Barcode2,'')
					 else '' end AS Barcode2 ,
				case when pg.Name = 'FamilyMart' then ISNULL(fm.Barcode3,'')
					 when pg.Name = '7-ELEVEN' then ''
					 when pg.Name = 'StarBucks' then ''
					 when pg.Name = 'SoftWorld' then ''
					 else '' end AS Barcode3 ,
				case when pg.Name = 'FamilyMart' then ISNULL(fm.Barcode4,'')
					 when pg.Name = '7-ELEVEN' then ''
					 when pg.Name = 'StarBucks' then ''
					 when pg.Name = 'SoftWorld' then ''
					 else '' end AS Barcode4 ,
				case when pg.Name = 'iQIYI' then 'Code128A'
					else ISNULL(pbs.Barcode1Type,'') end AS Barcode1Type,
                ISNULL(pbs.Barcode2Type,'') AS Barcode2Type ,
                ISNULL(pbs.Barcode3Type,'') AS Barcode3Type ,
                ISNULL(pbs.Barcode4Type,'') AS Barcode4Type ,
                case when pg.Name = 'iQIYI' then @true
					else ISNULL(pbs.IsBarcode1APIEnabled, @false) end AS IsBarcode1APIEnabled ,
                ISNULL(pbs.IsBarcode2APIEnabled, @false) AS IsBarcode2APIEnabled ,				
                ISNULL(pbs.IsBarcode3APIEnabled, @false) AS IsBarcode3APIEnabled ,
                ISNULL(pbs.IsBarcode4APIEnabled, @false) AS IsBarcode4APIEnabled ,
				case when pg.Name = 'iQIYI' then @true
					else ISNULL(pbs.IsBarcode1DisplayText, @false) end AS IsBarcode1DisplayText ,
                ISNULL(pbs.IsBarcode2DisplayText, @false) AS IsBarcode2DisplayText ,				
                ISNULL(pbs.IsBarcode3DisplayText, @false) AS IsBarcode3DisplayText ,
                ISNULL(pbs.IsBarcode4DisplayText, @false) AS IsBarcode4DisplayText ,
                v.ShortUrl VoucherAlias,
                v.AuthCode
        FROM    Voucher v
                LEFT JOIN ProductBarcodeSetting pbs ON v.ProductId = pbs.Id
                JOIN VoucherReservationBatch vrb ON v.ReservationBatchId = vrb.id
                JOIN Product p ON v.ProductId = p.Id
                JOIN Program pg ON p.ProgramId = pg.Id
				LEFT JOIN EXT_TW_FamilyMart fm ON v.ExtendId = fm.Id
				LEFT JOIN EXT_TW_SEBarcode seb ON v.ExtendId = seb.Id
                LEFT JOIN EXT_TW_Starbucks sbk ON v.ExtendId = sbk.Id
                LEFT JOIN EXT_TW_SoftWorld sw ON v.ExtendId = sw.Id
				LEFT JOIN EXT_TW_FamilyMartBardCodeOne fmc1 ON v.ExtendId = fmc1.Id
				LEFT JOIN EXT_TW_IQiYi iqy ON v.ExtendId = iqy.Id
        WHERE   v.Id = @VoucherId
                AND v.Status < 64
                AND v.BeneficiaryInfoId IS NOT NULL
                AND p.Status = 1
    END

