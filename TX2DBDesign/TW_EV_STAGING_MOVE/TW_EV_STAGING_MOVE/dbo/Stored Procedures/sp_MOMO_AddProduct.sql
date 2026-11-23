CREATE PROCEDURE sp_MOMO_AddProduct
    @MasterProductCode VARCHAR(50) ,
    @ChildProductCode VARCHAR(50)
AS
    BEGIN
    declare @ChildProductId int
    declare @ChildProductVersionId int

    select @ChildProductId = Id
    from Product with(nolock)
    where ProductCode = @ChildProductCode
    select @ChildProductVersionId = Id
    from ProductVersion with(nolock)
    where ProductId = @ChildProductId and IsCurrentVersion = 1

    IF NOT EXISTS (select 1
    from Product p with(nolock)
        join ProductVersion pv with(nolock) on pv.ProductId = p.Id
        join ProductComboSet pcs with(nolock) on pcs.ProductComboId = pv.ProductComboId
    where p.ProductCode = @MasterProductCode and pv.IsCurrentVersion = 1 and pcs.ChildProductId=@ChildProductId)
BEGIN

        INSERT INTO ProductComboSet
            (
            ProductComboId,
            ChildProductId,
            ChildProductVersionId,
            [Sequence]
            )
        select top 1
            pcs.ProductComboId, @ChildProductId, @ChildProductVersionId, [Sequence]+1
        from Product p with(nolock)
            join ProductVersion pv with(nolock) on pv.ProductId = p.Id
            join ProductComboSet pcs with(nolock) on pcs.ProductComboId = pv.ProductComboId
        where p.ProductCode = @MasterProductCode and pv.IsCurrentVersion = 1
        order by pcs.Sequence desc
    END
END
