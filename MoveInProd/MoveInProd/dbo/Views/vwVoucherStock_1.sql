
CREATE VIEW [dbo].[vwVoucherStock]
AS

SELECT [Id], [ProgramId], [ProductId], [VoucherNumber], [SessionId], [StockStatus], [CreateTime], [AssignTime], [GUID], [BalanceAvailable], [ReservationBatchId], [ExpiryDate], [PinCode] FROM VoucherStock_A_65 WITH(NOLOCK)
UNION ALL
SELECT [Id], [ProgramId], [ProductId], [VoucherNumber], [SessionId], [StockStatus], [CreateTime], [AssignTime], [GUID], [BalanceAvailable], [ReservationBatchId], [ExpiryDate], [PinCode] FROM VoucherStock_B_66 WITH(NOLOCK)
UNION ALL
SELECT [Id], [ProgramId], [ProductId], [VoucherNumber], [SessionId], [StockStatus], [CreateTime], [AssignTime], [GUID], [BalanceAvailable], [ReservationBatchId], [ExpiryDate], [PinCode] FROM VoucherStock_C_67 WITH(NOLOCK)
UNION ALL
SELECT [Id], [ProgramId], [ProductId], [VoucherNumber], [SessionId], [StockStatus], [CreateTime], [AssignTime], [GUID], [BalanceAvailable], [ReservationBatchId], [ExpiryDate], [PinCode] FROM VoucherStock_D_68 WITH(NOLOCK)
UNION ALL
SELECT [Id], [ProgramId], [ProductId], [VoucherNumber], [SessionId], [StockStatus], [CreateTime], [AssignTime], [GUID], [BalanceAvailable], [ReservationBatchId], [ExpiryDate], [PinCode] FROM VoucherStock_E_69 WITH(NOLOCK)
UNION ALL
SELECT [Id], [ProgramId], [ProductId], [VoucherNumber], [SessionId], [StockStatus], [CreateTime], [AssignTime], [GUID], [BalanceAvailable], [ReservationBatchId], [ExpiryDate], [PinCode] FROM VoucherStock_F_70 WITH(NOLOCK)
UNION ALL
SELECT [Id], [ProgramId], [ProductId], [VoucherNumber], [SessionId], [StockStatus], [CreateTime], [AssignTime], [GUID], [BalanceAvailable], [ReservationBatchId], [ExpiryDate], [PinCode] FROM VoucherStock_G_71 WITH(NOLOCK)

