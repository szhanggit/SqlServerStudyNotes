CREATE PROCEDURE [soc].[sp_insert_audit_trace]
(
    @event_id bigint,
	@field_name nvarchar(255),
	@old_value nvarchar(2000),
	@new_value nvarchar(2000)
)
AS
BEGIN
    
	INSERT INTO [soc].[tb_at_audit_trace]
	(
		event_id
		, field_name
		, old_value
		, new_value
	)
	values
	(
		@event_id
		, @field_name
		, @old_value
		, @new_value
	);

END