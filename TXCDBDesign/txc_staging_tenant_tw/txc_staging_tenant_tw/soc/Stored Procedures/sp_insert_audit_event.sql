CREATE PROCEDURE [soc].[sp_insert_audit_event]
(
    @tenant_id int,
	@event_type int,
	@event_name nvarchar(255),
	@event_who nvarchar(255),
	@event_when nvarchar(255),
	@event_where nvarchar(255),
	@event_keyword nvarchar(255),
	@event_content nvarchar(2000)
    
)
AS
BEGIN
    INSERT INTO [soc].tb_ae_audit_event(
	tenant_id
	, event_type
	, event_name
	, event_who
	, event_when
	, event_where
	, event_keyword
	, event_content)
	values
	(
	@tenant_id
	, @event_type
	, @event_name
	, @event_who
	, @event_when
	, @event_where
	, @event_keyword
	, @event_content)

	SELECT SCOPE_IDENTITY();
END