CREATE proc [order].[getSequenceNextValue]
	(
	@SequenceName nvarchar(100),
	@IsFixReturnLength bit,
	@ReturnLength tinyint,
	@PaddingCharacter char(1),
	@ret  nvarchar(100) output
)
as
begin
	declare @sql as nvarchar(500)
	declare @nextvalue as bigint
	select @sql = N'select @nextvalue = next value for ' + @SequenceName;
	exec SP_EXECUTESQL @sql, N'@nextvalue bigint out', @nextvalue output
	if(@IsFixReturnLength = 1)
  begin
		select @ret = right(replicate(@PaddingCharacter,@ReturnLength)+CAST(@nextvalue as nvarchar(100)),@ReturnLength)
	end
  else
  begin
		select @ret = CAST(@nextvalue as nvarchar(100))
	end
end