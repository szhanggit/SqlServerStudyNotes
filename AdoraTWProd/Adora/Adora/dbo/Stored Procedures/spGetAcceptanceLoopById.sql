
-- =============================================
-- Author:		Steven Yu
-- Create date: 2014/04/22
-- Description:	Get acceptance loop info by id.
-- =============================================
CREATE PROCEDURE [dbo].[spGetAcceptanceLoopById]
	@Id	INT
AS
BEGIN
	SET NOCOUNT ON;

select   M.IdentityCode as MerchantCode
			,M.TimeOffset as MerchantTimeOffset
			,S.IdentityCode as ShopCode
			,S.TimeOffset as ShopTimeOffset
			,T.IdentityCode as TerminalCode
			,T.TimeOffset as TerminalTimeOffset
	from AcceptanceLoop AL
	inner join AcceptanceLoopCategory ALC on ALC.AcceptanceLoopId = AL.Id
	inner join MerchantCategory MC on MC.Id = ALC.CategoryId and MC.Status = 1
	inner join Merchant M on M.CategoryId = MC.Id and M.Status = 1
	left join Shop S on S.MerchantId = M.Id and S.Status = 1
	left join Terminal T on T.MerchantId = M.Id and T.Status = 1
	where AL.Status = 1 and AL.Id = @Id
	union
	select   M.IdentityCode as MerchantCode
			,M.TimeOffset as MerchantTimeOffset
			,S.IdentityCode as ShopCode
			,S.TimeOffset as ShopTimeOffset
			,T.IdentityCode as TerminalCode
			,T.TimeOffset as TerminalTimeOffset
	from AcceptanceLoop AL
	inner join AcceptanceLoopCategory ALC on ALC.AcceptanceLoopId = AL.Id
	inner join MerchantCategory MC on MC.Id = ALC.CategoryId and MC.Status = 1
	inner join Merchant M on M.CategoryId = MC.Id and M.Status = 1
	left join Shop S on S.MerchantId = M.Id and S.Status = 1
	left join Terminal T on T.ShopId = S.Id and T.Status = 1
	where AL.Status  = 1 and AL.Id = @Id
	union
	select   M.IdentityCode as MerchantCode
			,M.TimeOffset as MerchantTimeOffset
			,NULL as ShopCode
			,NULL as ShopTimeOffset
			,NULL as TerminalCode
			,NULL as TerminalTimeOffset
	from AcceptanceLoop AL
	inner join AcceptanceLoopMerchant ALM on ALM.AcceptanceLoopId = AL.Id
	inner join Merchant M on M.Id = ALM.MerchantId and M.Status = 1
	--INNER join Shop S on S.MerchantId = M.Id and S.Status = 1
	--LEFT join Terminal T on T.ShopId = S.Id and T.Status = 1
	where AL.Status = 1 and AL.Id = @Id
	union
	select   M.IdentityCode as MerchantCode
			,M.TimeOffset as MerchantTimeOffset
			,NULL as ShopCode
			,NULL as ShopTimeOffset
			,T.IdentityCode as TerminalCode
			,T.TimeOffset as TerminalTimeOffset
	from AcceptanceLoop AL
	inner join AcceptanceLoopMerchant ALM on ALM.AcceptanceLoopId = AL.Id
	inner join Merchant M on M.Id = ALM.MerchantId and M.Status = 1
	left join Terminal T on T.MerchantId = M.Id and T.Status = 1
	where AL.Status = 1 and AL.Id = @Id
	union
	select   M.IdentityCode as MerchantCode
			,M.TimeOffset as MerchantTimeOffset
			,S.IdentityCode as ShopCode
			,S.TimeOffset as ShopTimeOffset
			,T.IdentityCode as TerminalCode
			,T.TimeOffset as TerminalTimeOffset
	from AcceptanceLoop AL
	inner join AcceptanceLoopShop ALS on ALS.AcceptanceLoopId = AL.Id
	inner join Shop S on S.Id = ALS.ShopId and S.Status = 1
	inner join Merchant M on S.MerchantId = M.Id and M.Status = 1
	left join Terminal T on T.ShopId = S.Id and T.Status = 1
	where AL.Status = 1 and AL.Id = @Id
END

